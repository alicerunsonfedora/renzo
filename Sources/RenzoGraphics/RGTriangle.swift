///
//  RGTriangle.swift
//  Renzo
//
//  Created by Marquis Kurt on 29-12-2025.
//

import PlaydateKit

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
        let originalA = sortedTri.pointA
        sortedTri.pointA = sortedTri.pointB
        sortedTri.pointB = originalA
    }

    if sortedTri.pointC.y < sortedTri.pointB.y {
        let originalC = sortedTri.pointC
        sortedTri.pointC = sortedTri.pointB
        sortedTri.pointB = originalC

        if sortedTri.pointB.y < sortedTri.pointA.y {
            let originalA = sortedTri.pointA
            sortedTri.pointA = sortedTri.pointB
            sortedTri.pointB = originalA
        }
    }
    return sortedTri
}

/// Fills a triangle with a given color.
/// - Parameter tri: The triangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func RGFillTriangle(_ tri: RGTriangle, color: RGColor = .black) {
    guard var frameBuffer = Graphics.getFrame() else {
        print("Failed to get frame buffer!")
        return
    }
    let sortedTri = RGSortTriangle(tri)
    if sortedTri.pointB.y == sortedTri.pointC.y {
        RGFillBottomTriangle(sortedTri, color: color, into: &frameBuffer)
        return
    }
    if sortedTri.pointA.y == sortedTri.pointB.y {
        RGFillTopTriangle(sortedTri, color: color, into: &frameBuffer)
        return
    }

    let deltaY = (sortedTri.pointB.y - sortedTri.pointA.y) / (sortedTri.pointC.y - sortedTri.pointA.y)
    let deltaX = sortedTri.pointC.x - sortedTri.pointA.x
    let cutter = Point(x: sortedTri.pointA.x + deltaY * deltaX, y: sortedTri.pointB.y)

    RGFillTopTriangle(RGTriangle(a: sortedTri.pointB, b: cutter, c: sortedTri.pointC), color: color, into: &frameBuffer)
    RGFillBottomTriangle(
        RGTriangle(a: sortedTri.pointA, b: sortedTri.pointB, c: cutter), color: color, into: &frameBuffer)
}

/// Fills a triangle with a flat bottom a given color.
/// - Parameter tri: The triangle that will be filled on the screen.
/// - Parameter color: The color to fill the triangle with.
/// - Parameter frameBuffer: The frame buffer the triangle will be filled into.
func RGFillBottomTriangle(_ tri: RGTriangle, color: RGColor = .black, into frameBuffer: inout RGBuffer) {
    let top = tri.pointA
    var (left, right) = (tri.pointB, tri.pointC)

    if left.x > right.x {
        let originalRight = right
        right = left
        left = originalRight
    }

    let invertSlopeA = (left.x - top.x) / (left.y - top.y)
    let invertSlopeB = (right.x - top.x) / (right.y - top.y)

    var (currentX_1, currentX_2) = (top.x, top.x)
    for scanlineY in Int(top.y)...Int(left.y) {
        let rect = Rect(origin: Point(x: currentX_1, y: Float(scanlineY)), width: currentX_2 - currentX_1, height: 1)
        RGFillRect(rect, color: color, into: &frameBuffer)
        currentX_1 += invertSlopeA
        currentX_2 += invertSlopeB
    }
}

/// Fills a triangle with a flat top a given color.
/// - Parameter tri: The triangle that will be filled on the screen.
/// - Parameter color: The color to fill the triangle with.
/// - Parameter frameBuffer: The frame buffer the triangle will be filled into.
func RGFillTopTriangle(_ tri: RGTriangle, color: RGColor = .black, into frameBuffer: inout RGBuffer) {
    let bottom = tri.pointC
    var (left, right) = (tri.pointA, tri.pointB)

    if left.x > right.x {
        let originalRight = right
        right = left
        left = originalRight
    }

    let invertSlopeA = (bottom.x - left.x) / (bottom.y - left.y)
    let invertSlopeB = (bottom.x - right.x) / (bottom.y - right.y)

    var (currentX_1, currentX_2) = (bottom.x, bottom.x)
    for scanlineY in stride(from: Int(bottom.y), to: Int(left.y), by: -1) {
        let rect = Rect(origin: Point(x: currentX_1, y: Float(scanlineY)), width: currentX_2 - currentX_1, height: 1)
        RGFillRect(rect, color: color, into: &frameBuffer)
        currentX_1 -= invertSlopeA
        currentX_2 -= invertSlopeB
    }
}
