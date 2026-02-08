//
//  Camera3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A representation of a camera in three-dimensional space.
public struct Camera3D: Equatable {
    /// The camera's position in the world.
    public var position: Point3D

    /// The camera's Euler rotation in the world.
    public var rotation: Point3D

    /// The camera's field of view represented in radians.
    public var fieldOfView: Float

    public init(position: Point3D, rotation: Point3D, fieldOfView: Float) {
        self.position = position
        self.rotation = rotation
        self.fieldOfView = fieldOfView
    }

    public var description: String {
        "Camera(position: \(position.description), rotation: \(rotation.description), fov: \(fieldOfView))"
    }
}
