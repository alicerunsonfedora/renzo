//
//  RenzoGraphics.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

private let byteLength = 8
private let rowStride = 52

/// A typealias representing a color.
public typealias RGColor = Graphics.Color

/// Fills a rectangle with a given color.
/// - Parameter rect: The rectangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillRect(_ rect: Rect, color: Graphics.Color = .black) {
    guard var frameBuffer = Graphics.getFrame() else { return }
    RGFillRect(rect, color: color, into: &frameBuffer)
}

/// Fills a rectangle with a given color.
/// - Parameter rect: The rectangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
/// - Parameter frameBuffer: The frame buffer to draw the rectangle into.
func RGFillRect(_ rect: Rect, color: Graphics.Color = .black, into frameBuffer: inout UnsafeMutablePointer<UInt8>) {
    guard rect.width > 0, rect.height > 0 else { return }
    // NOTE(marquiskurt): Frame considered a 2D array of bits ([[0, 0, 0, 0, 0, 0, 0, 0], ...])!
    var bounds = RGClipRectToBounds(rect)
    let byteOffset = UInt8(byteLength - 1)

    // A clear color effectively does nothing, so we can avoid going through the frame buffer entirely.
    if case .solid(let solidColor) = color, solidColor == .clear {
        print("There's a clear color set here. This does nothing.")
        return
    }

    // Divide by the byte length to access at bit level.
    bounds.minX /= byteLength
    bounds.maxX /= byteLength

    for y in bounds.minY..<bounds.maxY {
        let patternRowIndex = y % 8
        var patternBitmap: UInt8 = 255
        var patternBitmask: UInt8 = 0

        if case .pattern(let bitmap, let mask) = color {
            patternBitmap = RGGetBitPatternRow(bitmap, row: patternRowIndex)
            patternBitmask = RGGetBitPatternRow(mask, row: patternRowIndex)
        }

        for x in bounds.minX...bounds.maxX {
            let sliceIndex = x + y * rowStride
            var currentPattern = frameBuffer[sliceIndex]
            let sliceX = x * byteLength
            let minPixelX = UInt8(max(0, Int(rect.x) - sliceX))
            let maxPixelX = UInt8(min(byteLength, Int(rect.maxX) - sliceX))

            var bitmask: UInt8 = 0
            for pixel in minPixelX..<maxPixelX {
                let shift: UInt8 = 1 << (byteOffset - pixel)
                bitmask |= shift
            }

            switch color {
            case .solid(.black):
                currentPattern &= ~bitmask
                let colorPattern: UInt8 = 0b00000000
                let trimmedPattern = (bitmask & colorPattern)
                frameBuffer[sliceIndex] = currentPattern | trimmedPattern
            case .solid(.white), .solid(.clear):
                currentPattern &= ~bitmask
                let colorPattern: UInt8 = 0b11111111
                let trimmedPattern = (bitmask & colorPattern)
                frameBuffer[sliceIndex] = currentPattern | trimmedPattern
            case .solid(.xor):
                let colorPattern: UInt8 = 0b11111111
                let trimmedPattern = (bitmask & colorPattern)
                frameBuffer[sliceIndex] = currentPattern ^ trimmedPattern
            case .pattern:
                bitmask &= patternBitmask
                currentPattern &= ~bitmask
                let trimmedPattern = (bitmask & patternBitmap)
                frameBuffer[sliceIndex] = currentPattern | trimmedPattern
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Internal Mechanisms

/// Sets the specified pixel bit in a bit pattern to a specified solid color.
/// - Parameter bitPattern: The bit pattern containing the pixel bit to recolor.
/// - Parameter color: The color to set the pixel bit to.
/// - Parameter shift: The shift value corresponding to the pixel bit to set.
func RGSetBitSolidColor(_ bitPattern: inout UInt8, color: Graphics.SolidColor, shift: UInt8) {
    switch color {
    case .black:
        bitPattern &= ~shift
    case .white, .clear:
        bitPattern |= shift
    case .xor:
        bitPattern ^= shift
    @unknown default:
        bitPattern &= shift
    }
}
