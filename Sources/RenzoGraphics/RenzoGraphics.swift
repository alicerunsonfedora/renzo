//
//  RenzoGraphics.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit
import RenzoFoundation

let byteLength = 8
let rowStride = 52
let stripWidth = 1

let RGDisplayWidth = Display.width
let RGDisplayHeight = Display.height

let RGDisplayWidthF = Float(Display.width)
let RGDisplayHeightF = Float(Display.height)

/// A typealias representing a color.
public typealias RGColor = Graphics.Color

/// A typealias representing a frame buffer.
///
/// A frame buffer represents the Playdate's display, consisting of byte rows. Rows are 32-bit aligned, and the stride
/// is 52 rows. The last two bytes per row are not displayed on the screen. The frame buffer can be viewed as a
/// two-dimensional array of bits, effectively.
///
/// Bytes are represented in MSB-order, where the pixel in the zeroth column is represented by bit 0x80 of the first
/// byte of the row.
public typealias RGBuffer = UnsafeMutablePointer<UInt8>

#if AllowXOR
    enum RGPatternApplyMode {
        case copy, xor
    }
#endif

// swiftlint:disable cyclomatic_complexity function_body_length

/// Draws a scanline across the specified X points and Y level.
/// - Parameter x0: The starting point of the scanline.
/// - Parameter x1: The ending point of the scanline.
/// - Parameter y: The Y level of the scanline.
/// - Parameter color: The color of the scanline.
/// - Parameter frameBuffer: The frame buffer to draw the scanline into.
public func RGDrawScanline(_ x0: Int, _ x1: Int, y: Int, color: RGColor = .black, into frameBuffer: inout RGBuffer) {
    if case .solid(.clear) = color {
        RFReportWarning("Drawing a clear line does nothing.")
        return
    }

    var (start, end) = (x0, x1)
    if start > end {
        (start, end) = (end, start)
    }

    if end < 0 || start >= RGDisplayWidth {
        return
    }

    start = max(start, 0)
    end = min(end, RGDisplayWidth - 1)

    let byteOffset: UInt8 = 7
    let stripsPerRow = rowStride / stripWidth
    let (startStrip, endStrip) = (start >> 3, end >> 3)
    let row = y * stripsPerRow

    let patternRowIndex = y % 8
    var pattern: UInt8 = 0
    var patternBitmask: UInt8 = 255
    #if AllowXOR
        var patternMode: RGPatternApplyMode = .copy
    #endif

    switch color {
    case .solid(.white), .solid(.clear):
        pattern = 255
    #if AllowXOR
        case .solid(.black):
            break
        case .solid(.xor):
            patternMode = .xor
    #else
        case .solid(.black), .solid(.xor):
            break
    #endif
    case .pattern(let bitmap, let mask):
        pattern = RGGetBitPatternRow(bitmap, row: patternRowIndex)
        patternBitmask = RGGetBitPatternRow(mask, row: patternRowIndex)
    @unknown default:
        RFReportError("An unsupported color type was provided to RGDrawScanline: \(color)")
        return
    }

    for x in startStrip...endStrip {
        var strip = frameBuffer[x + row]
        let stripX = x * 8
        let stripStart = max(start - stripX, 0)
        let stripEnd = UInt8(min(end - stripX, 7))

        let startMask: UInt8 = 255 >> stripStart
        let endMask: UInt8 = 255 << (byteOffset - stripEnd)
        var bitmask = startMask & endMask
        bitmask &= patternBitmask

        let trimmedPattern = bitmask & pattern
        #if AllowXOR
            switch patternMode {
            case .copy:
                strip &= ~bitmask
                strip = strip | trimmedPattern
            case .xor:
                strip = strip ^ trimmedPattern
            }
        #else
            strip &= ~bitmask
            strip = strip | trimmedPattern
        #endif
        frameBuffer[x + row] = strip
    }
}

// swiftlint:enable cyclomatic_complexity function_body_length
