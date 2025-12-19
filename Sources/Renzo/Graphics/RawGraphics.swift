//
//  RawGraphics.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

/// Fills a rectangle with a given color.
/// - Parameter rect: The rectangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillRect(_ rect: Rect, color: Graphics.Color = .black) {
    guard let frameBuffer = Graphics.getFrame() else { return }
    // TODO(marquiskurt): Stub! Stub! Stuuuuub!
}

/// Fills a triangle with a given color.
/// - Parameter tri: The triangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillTriangle(_ tri: TriFace2D, color: Graphics.Color = .black) {
    guard let frameBuffer = Graphics.getFrame() else { return }
    // TODO(marquiskurt): Stub! Stub! Stuuuuub!
}