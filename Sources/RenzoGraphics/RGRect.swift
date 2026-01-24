//
//  RGRect.swift
//  Renzo
//
//  Created by Marquis Kurt on 24-01-2026.
//

import PlaydateKit
import RenzoFoundation

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
func RGFillRect(_ rect: Rect, color: Graphics.Color = .black, into frameBuffer: inout RGBuffer) {
    guard rect.width > 0, rect.height > 0 else { return }
    var bounds = RGClipRectToBounds(rect)
    let byteOffset = UInt8(byteLength - 1)

    // A clear color effectively does nothing, so we can avoid going through the frame buffer entirely.
    if case .solid(let solidColor) = color, solidColor == .clear {
        RFReportWarning("Filling a rectangle with a clear color does nothing.")
        return
    }

    // Divide by the byte length to access at bit level.
    bounds.minX /= byteLength
    bounds.maxX /= byteLength

    for y in bounds.minY..<bounds.maxY {
        let patternRowIndex = y % 8
        var patternBitmap: UInt8 = RGRawColor.black.rawValue
        var patternBitmask: UInt8 = RGRawColor.white.rawValue

        if case .pattern(let bitmap, let mask) = color {
            patternBitmap = RGGetBitPatternRow(bitmap, row: patternRowIndex)
            patternBitmask = RGGetBitPatternRow(mask, row: patternRowIndex)
        }

        for x in bounds.minX...bounds.maxX {
            let sliceIndex = x + y * rowStride
            var bitmask = RGCreateBitmask(x: x, y: y, rect: rect, byteOffset: byteOffset)

            switch color {
            case .solid(.black):
                RGApplyPattern(RGRawColor.white.rawValue, to: &frameBuffer, at: sliceIndex, bitmask: bitmask)
            case .solid(.white), .solid(.clear):
                RGApplyPattern(RGRawColor.black.rawValue, to: &frameBuffer, at: sliceIndex, bitmask: bitmask)
            case .solid(.xor):
                RGApplyPattern(
                    RGRawColor.black.rawValue, to: &frameBuffer, at: sliceIndex, bitmask: bitmask, mode: .xor)
            case .pattern:
                bitmask &= patternBitmask
                RGApplyPattern(patternBitmap, to: &frameBuffer, at: sliceIndex, bitmask: bitmask)
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Internal Mechanisms

/// Create a bitmask for the specified frame buffer region.
func RGCreateBitmask(x: Int, y: Int, rect: Rect, byteOffset: UInt8) -> UInt8 {
    let sliceX = x * byteLength
    let minPixelX = UInt8(max(0, Int(rect.x) - sliceX))
    let maxPixelX = UInt8(min(byteLength, Int(rect.maxX) - sliceX))

    var bitmask: UInt8 = 0
    for pixel in minPixelX..<maxPixelX {
        let shift: UInt8 = 1 << (byteOffset - pixel)
        bitmask |= shift
    }
    return bitmask
}

/// Apply a pattern to the frame buffer.
/// - Parameter pattern: The pattern being applied to the frame buffer.
/// - Parameter frameBuffer: The frame buffer that will draw the new pattern.
/// - Parameter sliceIndex: The frame buffer region's position.
/// - Parameter bitmask: The bitmask that limits where the pattern will be applied in the slice.
/// - Parameter mode: The pattern application mode.
func RGApplyPattern(
    _ pattern: UInt8,
    to frameBuffer: inout RGBuffer,
    at sliceIndex: Int,
    bitmask: UInt8,
    mode: RGPatternApplyMode = .copy
) {
    var currentPattern = frameBuffer[sliceIndex]
    if mode == .copy {
        currentPattern &= ~bitmask
    }

    let trimmedPattern = bitmask & pattern
    switch mode {
    case .copy:
        frameBuffer[sliceIndex] = currentPattern | trimmedPattern
    case .xor:
        frameBuffer[sliceIndex] = currentPattern ^ trimmedPattern
    }
}
