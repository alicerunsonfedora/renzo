//
//  Projection3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-02-2026.
//

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
