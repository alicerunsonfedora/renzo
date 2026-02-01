//
//  GraphicsExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDGraphics
import PlaydateKit

extension Graphics {
    /// Draws a filled triangle at the points provided by the face.
    ///
    /// > Note: If you need more performance, consider using `PGFillTriangle` from the PDGraphics library instead of
    /// > this extension method.
    ///
    /// - Parameter triangle: The triangle to draw on the screen.
    /// - Parameter color: The fill color of the triangle.
    public static func fillTriangle(_ triangle: TriFace2D, color: Color = .black) {
        Graphics.fillTriangle(
            p1: triangle.pointA, p2: triangle.pointB, p3: triangle.pointC, color: color)
    }

    /// Draws a wireframe triangle at the points provided by the face.
    ///
    /// > Important: This is a rather computationally expensive function. It is not recommended to draw
    /// > triangles this way, as it can decrease the performance of the device. Instead, consider using the
    /// > ``Graphics.fillTriangle(_:,color)`` method.
    ///
    /// - Parameter triangle: The triangle to draw on the screen.
    /// - Parameter lineWidth: The width of the lines used to draw the triangle.
    public static func drawTriangle(_ triangle: TriFace2D, lineWidth: Int = 1) {
        Graphics.drawLine(Line(start: triangle.pointA, end: triangle.pointB), lineWidth: lineWidth)
        Graphics.drawLine(Line(start: triangle.pointA, end: triangle.pointC), lineWidth: lineWidth)
        Graphics.drawLine(Line(start: triangle.pointC, end: triangle.pointB), lineWidth: lineWidth)
    }
}
