//
//  Projection3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDGraphics

extension Projection3D {
    /// Project a face from three-dimensional space into its two-dimensional space counterpart.
    /// - Parameter face: The face to project into two-dimensional space.
    public func project(_ face: TriFace3D) -> TriFace2D {
        let pointA = project(face.pointA)
        let pointB = project(face.pointB)
        let pointC = project(face.pointC)
        return TriFace2D(a: pointA, b: pointB, c: pointC)
    }

    /// Project a face from three-dimensional space into its two-dimensional space counterpart.
    /// - Parameter face: The face to project into two-dimensional space.
    public func project(_ face: TriFace3D) -> PGTriangle {
        let projection: TriFace2D = self.project(face)
        return PGTriangle(projection)
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
