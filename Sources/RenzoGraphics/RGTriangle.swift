//
//  RGTriangle.swift
//  Renzo
//
//  Created by Marquis Kurt on 29-12-2025.
//

import PlaydateKit
import RenzoFoundation

/// A representation of a triangular face in two-dimensional space.
public struct RGTriangle: Equatable {
    /// The first point of the face.
    public var pointA: Point

    /// The second point of the face.
    public var pointB: Point

    /// The third point of the face.
    public var pointC: Point

    public init(a pointA: Point, b pointB: Point, c pointC: Point) {
        self.pointA = pointA
        self.pointB = pointB
        self.pointC = pointC
    }
}

extension RGTriangle {
    /// The face's signed area.
    ///
    /// The signed area is typically used to determine its winding order so that 3D renderers can cull faces
    /// that shouldn't be rendered.
    public var signedArea: Float {
        (pointB.x - pointA.x) * (pointC.y - pointB.y) - (pointC.x - pointB.x)
            * (pointB.y - pointA.y)
    }
}

/// Sorts a triangle by its Y index.
func RGSortTriangle(_ tri: RGTriangle) -> RGTriangle {
    var sortedTri = RGTriangle(a: tri.pointA, b: tri.pointB, c: tri.pointC)
    if sortedTri.pointB.y < sortedTri.pointA.y {
        (sortedTri.pointA, sortedTri.pointB) = (sortedTri.pointB, sortedTri.pointA)
    }
    if sortedTri.pointC.y < sortedTri.pointB.y {
        (sortedTri.pointB, sortedTri.pointC) = (sortedTri.pointC, sortedTri.pointB)
    }
    if sortedTri.pointB.y < sortedTri.pointA.y {
        (sortedTri.pointA, sortedTri.pointB) = (sortedTri.pointB, sortedTri.pointA)
    }

    return sortedTri
}

/// Fills a triangle with a given color.
/// - Parameter tri: The triangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillTriangle(_ tri: RGTriangle, color: RGColor = .black) {
    guard var frameBuffer = Graphics.getFrame() else {
        RFReportError("Failed to get frame buffer.")
        return
    }
    var sortedTri = RGSortTriangle(tri)
    sortedTri.pointA.x = floorf(sortedTri.pointA.x)
    sortedTri.pointB.x = floorf(sortedTri.pointB.x)
    sortedTri.pointC.x = floorf(sortedTri.pointC.x)

    sortedTri.pointA.y = floorf(sortedTri.pointA.y)
    sortedTri.pointB.y = floorf(sortedTri.pointB.y)
    sortedTri.pointC.y = floorf(sortedTri.pointC.y)

    if sortedTri.pointA.y == sortedTri.pointC.y { return }
    if sortedTri.pointA.x == sortedTri.pointB.x, sortedTri.pointB.x == sortedTri.pointC.x { return }
    if Int(sortedTri.pointA.y) >= Display.height || sortedTri.pointC.y < 0 { return }
    if sortedTri.pointA.x < 0, sortedTri.pointB.x < 0, sortedTri.pointC.x < 0 { return }

    let width = Float(Display.width)
    if sortedTri.pointA.x >= width, sortedTri.pointB.x >= width, sortedTri.pointC.x >= width { return }

    if sortedTri.pointB.y == sortedTri.pointC.y {
        RGFillBottomFlatTriangle(sortedTri, color: color, into: &frameBuffer)
        return
    }
    if sortedTri.pointA.y == sortedTri.pointB.y {
        RGFillTopFlatTriangle(sortedTri, color: color, into: &frameBuffer)
        return
    }

    let deltaY = (sortedTri.pointB.y - sortedTri.pointA.y) / (sortedTri.pointC.y - sortedTri.pointA.y)
    let deltaX = sortedTri.pointC.x - sortedTri.pointA.x
    let cutter = Point(x: sortedTri.pointA.x + deltaY * deltaX, y: sortedTri.pointB.y)

    let top = RGTriangle(a: sortedTri.pointB, b: cutter, c: sortedTri.pointC)
    let bottom = RGTriangle(a: sortedTri.pointA, b: sortedTri.pointB, c: cutter)

    RGFillTopFlatTriangle(top, color: color, into: &frameBuffer)
    RGFillBottomFlatTriangle(bottom, color: color, into: &frameBuffer)
}

/// Fills a triangle with a flat bottom a given color.
/// - Parameter tri: The triangle that will be filled on the screen.
/// - Parameter color: The color to fill the triangle with.
/// - Parameter frameBuffer: The frame buffer the triangle will be filled into.
func RGFillBottomFlatTriangle(_ tri: RGTriangle, color: RGColor = .black, into frameBuffer: inout RGBuffer) {
    let top = tri.pointA
    var left = tri.pointB
    var right = tri.pointC

    if left.x > right.x {
        (left.x, right.x) = (right.x, left.x)
    }

    let invertSlopeA = (left.x - top.x) / (left.y - top.y)
    let invertSlopeB = (right.x - top.x) / (right.y - top.y)

    var currentX_1 = top.x
    var currentX_2 = top.x

    for scanlineY in Int(top.y)...Int(left.y) {
        guard (0..<Display.height).contains(scanlineY) else {
            currentX_1 += invertSlopeA
            currentX_2 += invertSlopeB
            continue
        }
        RGDrawScanline(x1: currentX_1, x2: currentX_2, scanlineY: scanlineY, color: color, into: &frameBuffer)
        currentX_1 += invertSlopeA
        currentX_2 += invertSlopeB
    }
}

/// Fills a triangle with a flat top a given color.
/// - Parameter tri: The triangle that will be filled on the screen.
/// - Parameter color: The color to fill the triangle with.
/// - Parameter frameBuffer: The frame buffer the triangle will be filled into.
func RGFillTopFlatTriangle(_ tri: RGTriangle, color: RGColor = .black, into frameBuffer: inout RGBuffer) {
    let bottom = tri.pointC
    var left = tri.pointA
    var right = tri.pointB

    if left.x > right.x {
        (left.x, right.x) = (right.x, left.x)
    }

    let invertSlopeA = (bottom.x - left.x) / (bottom.y - left.y)
    let invertSlopeB = (bottom.x - right.x) / (bottom.y - right.y)

    var currentX_1 = bottom.x
    var currentX_2 = bottom.x

    for scanlineY in stride(from: Int(bottom.y), to: Int(left.y) - 1, by: -1) {
        guard (0..<Display.height).contains(scanlineY) else {
            currentX_1 += invertSlopeA
            currentX_2 += invertSlopeB
            continue
        }

        RGDrawScanline(x1: currentX_1, x2: currentX_2, scanlineY: scanlineY, color: color, into: &frameBuffer)
        currentX_1 -= invertSlopeA
        currentX_2 -= invertSlopeB
    }
}

func RGDrawScanline(x1: Float, x2: Float, scanlineY: Int, color: RGColor, into frameBuffer: inout RGBuffer) {
    var (currentX_1, currentX_2) = (x1, x2)
    if currentX_1 > currentX_2 {
        (currentX_1, currentX_2) = (currentX_2, currentX_1)
    }
    if currentX_2 < 0 || Int(currentX_1) >= Display.width {
        return
    }
    let width = currentX_2 - currentX_1

    let rect = Rect(origin: Point(x: currentX_1, y: Float(scanlineY)), width: width, height: 1)
    RGFillRect(rect, color: color, into: &frameBuffer)
}

private func RGValidateScanline(
    x1: Float,
    x2: Float,
    in range: ClosedRange<Float>,
    sourceTri: RGTriangle,
    mode: String
) {
    if range.contains(x1...x2) {
        return
    }
    let formattedTri = RGFormatTriangle(sourceTri)
    RFReportWarning(
        """
        The range for the scanline doesn't fit within the expected triangle X ranges.
        This might cause unexpected scanline rendering.
            Render Mode: \(mode)
            Expected Range: \(range.lowerBound, precision: 0)...\(range.upperBound, precision: 0)
            Scanline Range: \(x1, precision: 0)...\(x2, precision: 0)
            Drawn Triangle: \(formattedTri)
        """
    )
}

private func RGFormatTriangle(_ tri: RGTriangle) -> String {
    let pointA = "(\(tri.pointA.x, precision: 0), \(tri.pointA.y, precision: 0))"
    let pointB = "(\(tri.pointB.x, precision: 0), \(tri.pointB.y, precision: 0))"
    let pointC = "(\(tri.pointC.x, precision: 0), \(tri.pointC.y, precision: 0))"
    return "V1: \(pointA), V2: \(pointB), V3: \(pointC)"
}
