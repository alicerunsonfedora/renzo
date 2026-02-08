//
//  ModelReference.swift
//  Renzo
//
//  Created by Marquis Kurt on 15-12-2025.
//

/// A structure representing a model reference.
///
/// In scenes, models are stored by their position and rotation, along with the model name on the Playdate's disk. When
/// reading the models from a scene, the reader should ensure that it maps the appropriate name to a model file in the
/// game's resources.
public struct ModelReference: Equatable, Hashable, Sendable {
    /// The name of the model as it appears in the game's resources.
    ///
    /// > Important: Names must be considered unique, as scenes should not contain more than one model of the same
    /// > name.
    public var name: String

    /// The model's position in the world.
    public var position: Point3D

    /// The model's Euler rotation in the world.
    public var rotation: Point3D

    /// The model's scale in the world.
    public var scale: Point3D

    public init(name: String, position: Point3D, rotation: Point3D, scale: Point3D) {
        self.name = name
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}
