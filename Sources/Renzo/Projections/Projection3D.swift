//
//  Projection3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDGraphics

/// A protocol that defines a projection from three-dimensional space into two-dimensional space.
public protocol Projection3D: AnyObject {
    /// Project a point from three-dimensional space into its two-dimensional space counterpart.
    ///
    /// > Important: Projections assume that the point is in the correct world position. Depending on the
    /// > implementation, you may need to pre-process the point before projecting it.
    ///
    /// - Parameter point: The point to project into two-dimensional space.
    func project(_ point: Point3D) -> Point2D
}

extension Projection3D {
    /// Project a face from three-dimensional space into its two-dimensional space counterpart.
    /// - Parameter face: The face to project into two-dimensional space.
    public func project(_ face: TriFace3D) -> TriFace2D {
        let pointA = project(face.pointA)
        let pointB = project(face.pointB)
        let pointC = project(face.pointC)
        return TriFace2D(a: pointA, b: pointB, c: pointC)
    }

    /// Project a set of faces from three-dimensional space into its two-dimensional space counterparts.
    /// - Parameter faces: The faces to project into two-dimensional space.
    public func project(_ faces: [TriFace3D]) -> [TriFace2D] {
        return faces.map { self.project($0) }
    }

    /// Project an entire model from three-dimensional space to its two-dimensional space counterpart.
    /// - Parameter model: The model to project into two-dimensional space.
    public func project(_ model: Model3D) -> [TriFace2D] {
        return model.map { face in
            self.project(face)
        }
    }
}
