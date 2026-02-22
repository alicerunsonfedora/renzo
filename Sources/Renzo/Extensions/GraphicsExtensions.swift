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
    /// - Parameter triangle: The triangle to draw on the screen.
    /// - Parameter color: The fill color of the triangle.
    @available(*, deprecated, message: "Use PGFillTriangle from PDGraphics.")
    public static func fillTriangle(_ triangle: TriFace2D, color: Color = .black) {
        PGFillTriangle(PGTriangle(triangle), color: color)
    }

    /// Draws a wireframe triangle at the points provided by the face.
    ///
    /// > Important: This is a rather computationally expensive function. It is not recommended to draw
    /// > triangles this way, as it can decrease the performance of the device. Instead, consider using the
    /// >  `PGFillTriangle(:color:)` from the PDGraphics library instead.
    ///
    /// - Parameter triangle: The triangle to draw on the screen.
    /// - Parameter lineWidth: The width of the lines used to draw the triangle.
    public static func drawTriangle(_ triangle: TriFace2D, lineWidth: Int = 1) {
        Graphics.drawLine(Line(start: Point(triangle.pointA), end: Point(triangle.pointB)), lineWidth: lineWidth)
        Graphics.drawLine(Line(start: Point(triangle.pointA), end: Point(triangle.pointC)), lineWidth: lineWidth)
        Graphics.drawLine(Line(start: Point(triangle.pointC), end: Point(triangle.pointB)), lineWidth: lineWidth)
    }
}
