//
//  RawGraphics.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

private let byteLength = 8
private let rowStride = 52

public struct RGBounds {
    public var minX: Int
    public var minY: Int
    public var maxX: Int
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
 
    // Divide by the byte length to access at bit level.
    bounds.minX /= byteLength
    bounds.maxX /= byteLength

    for y in bounds.minY..<bounds.maxY {
        for x in bounds.minX...bounds.maxX {
            let sliceX = x * 8
            let minPixelX = UInt8(max(0, Int(rect.x) - sliceX))
            let maxPixelX = UInt8(min(8, Int(rect.maxX) - sliceX))

            var bitPattern: UInt8 = 0b11111111
            for i in minPixelX..<maxPixelX {
                // TODO(marquiskurt): Dafuq?
                bitPattern &= ~(1 << (7-i))
            }
            frameBuffer[x + y * rowStride] = bitPattern
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