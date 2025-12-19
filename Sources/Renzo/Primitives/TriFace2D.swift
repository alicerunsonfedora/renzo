//
//  TriFace2D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

/// A representation of a point in two-dimensional space.
public typealias Point2D = PlaydateKit.Point

/// A representation of a triangular face in two-dimensional space.
public struct TriFace2D: Equatable {
    /// The first point of the face.
    public var pointA: Point2D

    /// The second point of the face.
    public var pointB: Point2D

    /// The third point of the face.
    public var pointC: Point2D

    public init(a pointA: Point2D, b pointB: Point2D, c pointC: Point2D) {
        self.pointA = pointA
        self.pointB = pointB
        self.pointC = pointC
    }
}

extension TriFace2D {
    /// The face's signed area.
    ///
    /// The signed area is typically used to determine its winding order so that 3D renderers can cull faces
    /// that shouldn't be rendered.
    public var signedArea: Float {
        (pointB.x - pointA.x) * (pointC.y - pointB.y) - (pointC.x - pointB.x)
            * (pointB.y - pointA.y)
    }
}
