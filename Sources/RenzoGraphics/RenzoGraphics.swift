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

/// A typealias representing a color.
public typealias RGColor = Graphics.Color

enum RGRawColor: UInt8 {
    case white = 0
    case black = 255
}

/// A typealias representing a frame buffer.
///
/// A frame buffer represents the Playdate's display, consisting of byte rows. Rows are 32-bit aligned, and the stride
/// is 52 rows. The last two bytes per row are not displayed on the screen. The frame buffer can be viewed as a
/// two-dimensional array of bits, effectively.
///
/// Bytes are represented in MSB-order, where the pixel in the zeroth column is represented by bit 0x80 of the first
/// byte of the row.
public typealias RGBuffer = UnsafeMutablePointer<UInt8>

/// An enumeration of the pattern application modes.
public enum RGPatternApplyMode {
    /// The pattern should be copied to the current bytes, overwriting anything pre-existing.
    case copy

    /// The pattern should be XOR'ed with the current bytes.
    case xor
}

/// Draws a scanline across the specified X points and Y level.
/// - Parameter x0: The starting point of the scanline.
/// - Parameter x1: The ending point of the scanline.
/// - Parameter y: The Y level of the scanline.
/// - Parameter color: The color of the scanline.
public func RGDrawScanline(_ x0: Int, _ x1: Int, y: Int, color: RGColor = .black) {
    guard var frameBuffer = Graphics.getFrame() else {
        RFReportError("Failed to get the frame buffer.")
        return
    }
    RGDrawScanline(x0, x1, y: y, color: color, into: &frameBuffer)
}

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

    let byteOffset = UInt8(byteLength) - 1
    let stripsPerRow = rowStride / stripWidth
    let (startStrip, endStrip) = (start >> 3, end >> 3)
    let row = y * stripsPerRow

    let patternRowIndex = y % 8
    var pattern: UInt8 = 0
    var patternBitmask: UInt8?
    var patternMode: RGPatternApplyMode = .copy

    switch color {
    case .solid(.black):
        break
    case .solid(.white), .solid(.clear):
        pattern = 255
    case .solid(.xor):
        pattern = 255
        patternMode = .xor
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
        let stripEnd = min(end - stripX, Int(byteOffset))

        let startMask: UInt8 = 255 >> stripStart
        let endMask: UInt8 = 255 << (byteOffset - UInt8(stripEnd))
        var bitmask = startMask & endMask
        if let patternBitmask {
            bitmask &= patternBitmask
        }

        let trimmedPattern = bitmask & pattern
        switch patternMode {
        case .copy:
            strip &= ~bitmask
            strip = strip | trimmedPattern
        case .xor:
            strip = strip ^ trimmedPattern
        }
        frameBuffer[x + row] = strip
    }
}
