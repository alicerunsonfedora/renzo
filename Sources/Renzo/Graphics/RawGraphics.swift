//
//  RawGraphics.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

private let byteLength = 8
private let rowStride = 52

typealias BitPattern = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)

/// A structure representing the bounds of a rectangle.
public struct RGBounds {
    /// The minimum X value.
    public var minX: Int

    /// The minimum Y value.
    public var minY: Int

    /// The maximum X value.
    public var maxX: Int

    /// The maximum Y value.
    public var maxY: Int
}

/// Clips the specified rectangle such that it can be drawn within the bounds of the Playdate's screen.
/// - Parameter rect: The rectangle to clip to the display's bounds.
/// - Returns: The rectangle expressed as bounds inside the Playdate's screen.
public func RGClipRectToBounds(_ rect: Rect) -> RGBounds {
    let rectMinX = Int(max(0, rect.x))
    var rectMaxX = Int(rect.maxX)
    if rectMaxX >= Display.width {
        rectMaxX = Display.width - 1
    }

    let rectMinY = Int(max(0, rect.y))
    var rectMaxY = Int(rect.maxY)
    if rectMaxY >= Display.height {
        rectMaxY = Display.height - 1
    }

    return RGBounds(minX: rectMinX, minY: rectMinY, maxX: rectMaxX, maxY: rectMaxY)
}

/// Fills a rectangle with a given color.
/// - Parameter rect: The rectangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillRect(_ rect: Rect, color: Graphics.Color = .black) {
    // NOTE(marquiskurt): Frame considered a 2D array of bits ([[0, 0, 0, 0, 0, 0, 0, 0], ...])!
    guard let frameBuffer = Graphics.getFrame() else { return }
    var bounds = RGClipRectToBounds(rect)
    let byteOffset = UInt8(byteLength - 1)

    // A clear color effectively does nothing, so we can avoid going through the frame buffer entirely.
    if case .solid(let solidColor) = color, solidColor == .clear {
        return
    }

    // Divide by the byte length to access at bit level.
    bounds.minX /= byteLength
    bounds.maxX /= byteLength

    for y in bounds.minY..<bounds.maxY {
        let patternRowIndex = y % 8
        var bitmapRow: UInt8 = 255
        if case .pattern(let bitmap, let mask) = color {
            bitmapRow = RGGetBitPatternRow(bitmap, row: patternRowIndex)
            let maskRow = RGGetBitPatternRow(mask, row: patternRowIndex)
            bitmapRow ^= maskRow
        }

        for x in bounds.minX...bounds.maxX {
            let sliceIndex = x + y * rowStride
            let currentPattern = frameBuffer[sliceIndex]

            let sliceX = x * byteLength

            let minPixelX = UInt8(max(0, Int(rect.x) - sliceX))
            let maxPixelX = UInt8(min(byteLength, Int(rect.maxX) - sliceX))

            var newPattern: UInt8 = currentPattern
            for pixel in minPixelX..<maxPixelX {
                let shift: UInt8 = 1 << (byteOffset - pixel)
                switch color {
                case .solid(let solidColor):
                    RGSetBitSolidColor(&newPattern, color: solidColor, shift: shift)
                case .pattern:
                    newPattern ^= bitmapRow & shift
                }
            }
            frameBuffer[sliceIndex] = newPattern
        }
    }
}

/// Fills a triangle with a given color.
/// - Parameter tri: The triangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillTriangle(_ tri: TriFace2D, color: Graphics.Color = .black) {
    guard let frameBuffer = Graphics.getFrame() else { return }
    // TODO(marquiskurt): Stub! Stub! Stuuuuub!
}

// MARK: - Internal Mechanisms

/// Retrieves the row for a specified 8x8 bit pattern.
/// - Parameter bitmap: The bit pattern to retrieve the current row for.
/// - Parameter row: The row to retrieve. Row should be between 0..<8.
func RGGetBitPatternRow(_ bitmap: BitPattern, row: Int) -> UInt8 {
    return switch row {
    case 1: bitmap.1
    case 2: bitmap.2
    case 3: bitmap.3
    case 4: bitmap.4
    case 5: bitmap.5
    case 6: bitmap.6
    case 7: bitmap.7
    default: bitmap.0
    }
}

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
