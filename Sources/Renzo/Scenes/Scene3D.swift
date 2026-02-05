//
//  Scene3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A representation of a scene in three-dimensional space.
///
/// Scenes consist of at least a single camera and can optionally contain models. Rather than storing the models
/// directly, references are stored that map to an existing model in the game's resources.
public struct Scene3D: Equatable {
    /// The cameras in the scene.
    public var cameras: [Camera3D]

    /// The model references in the scene.
    public var models: [ModelReference]

    /// The point lights in the scene.
    public var lights: [Light3D]

    public init(cameras: [Camera3D], models: [ModelReference] = [], lights: [Light3D] = []) {
        self.cameras = cameras
        self.models = models
        self.lights = lights
    }

    public var description: String {
        "Scene(cameras: \(cameras.count), models: \(models.count), lights: \(lights.count))"
    }
}
