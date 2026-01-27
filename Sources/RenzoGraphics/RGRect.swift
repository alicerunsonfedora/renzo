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
    let bounds = RGClipRectToBounds(rect)

    // A clear color effectively does nothing, so we can avoid going through the frame buffer entirely.
    if case .solid(.clear) = color {
        return
    }

    for y in bounds.minY..<bounds.maxY {
        RGDrawScanline(bounds.minX, bounds.maxX, y: y, color: color, into: &frameBuffer)
    }
}
