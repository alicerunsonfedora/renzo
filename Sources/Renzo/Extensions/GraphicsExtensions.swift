//
//  GraphicsExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDGraphics
import PlaydateKit

let bayer: [[UInt8]] = [
    [0, 32, 8, 40, 2, 34, 10, 42],
    [48, 16, 56, 24, 50, 18, 58, 26],
    [12, 44, 4, 36, 14, 46, 6, 38],
    [60, 28, 52, 20, 62, 30, 54, 22],
    [3, 35, 11, 43, 1, 33, 9, 41],
    [51, 19, 59, 27, 49, 17, 57, 25],
    [15, 47, 7, 39, 13, 45, 5, 37],
    [63, 31, 55, 23, 61, 29, 53, 21],
]

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

extension Graphics.Color {
    public static func dithered(by opacity: Float) -> Graphics.Color {
        var pattern: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        let threshold = UInt8((1 - opacity) * 64)
        for row in 0..<8 {
            for col in 0..<8 {
                if bayer[row][col] >= threshold {
                    pattern[row] |= (1 << col)  // set
                } else {
                    pattern[row] &= ~(1 << col)  // clear
                }
            }
        }
        return .pattern(
            (
                pattern[0], pattern[1], pattern[2], pattern[3], pattern[4], pattern[5], pattern[6],
                pattern[7]
            ),
            mask: (255, 255, 255, 255, 255, 255, 255, 255)
        )
    }
}
