//
//  TriFace3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A representation of a triangular face in three-dimensional space.
public struct TriFace3D: Equatable, Hashable, Sendable {
    /// The first point of the face.
    public var pointA: Point3D

    /// The second point of the face.
    public var pointB: Point3D

    /// The third point of the face.
    public var pointC: Point3D

    /// The triangle's color.
    ///
    /// A color value of `0` is black, and a color value of `1` is white.
    public var color: Float

    public init(a pointA: Point3D, b pointB: Point3D, c pointC: Point3D, color: Float = 1) {
        self.pointA = pointA
        self.pointB = pointB
        self.pointC = pointC
        self.color = color
    }
}

extension TriFace3D: Transformable3D {
    public func transformedBy(_ transform: Transform3D) -> TriFace3D {
        var newSelf = self
        newSelf.pointA.transformBy(transform)
        newSelf.pointB.transformBy(transform)
        newSelf.pointC.transformBy(transform)
        return newSelf
    }

    public mutating func transformBy(_ transform: Transform3D) {
        self = self.transformedBy(transform)
    }
}

extension TriFace3D {
    public var description: String {
        "TriFace3D(a: \(pointA.description), b: \(pointB.description), c: \(pointC.description), color: \(color))"
    }

    public static func + (lhs: TriFace3D, rhs: Point3D) -> TriFace3D {
        TriFace3D(a: lhs.pointA + rhs, b: lhs.pointB + rhs, c: lhs.pointC + rhs, color: lhs.color)
    }

    /// The centermost point in the triangle.
    public var centroid: Point3D {
        (pointA + pointB + pointC) / 3
    }

    /// The vector that is perpendicular to the face's surface.
    public var normal: Point3D {
        let edge1 = pointB - pointA
        let edge2 = pointC - pointA
        return edge1 ** edge2
    }
}
