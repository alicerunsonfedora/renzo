//
//  SceneObject.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// An object that appears in a scene.
///
/// In most cases, it might not be desirable to work with model data directly. A scene object provides a convenient way
/// to pair a 3D model with world space data such as rotation and position.
public class SceneObject {
    /// The raw model data representing the object.
    public var model: Model3D

    /// The object's world position.
    public var worldPosition: Point3D

    /// The object's world rotation.
    public var worldRotation: Point3D

    /// The object's world scale.
    public var worldScale: Point3D

    /// Create a scene object.
    /// - Parameter model: The raw model data the object is shown on screen.
    /// - Parameter worldPosition: The model's world position.
    /// - Parameter worldRotation: The model's world rotation.
    /// - Parameter worldScale: The model's world scale.
    public init(
        model: Model3D, worldPosition: Point3D, worldRotation: Point3D, worldScale: Point3D = .one
    ) {
        self.model = model
        self.worldPosition = worldPosition
        self.worldRotation = worldRotation
        self.worldScale = worldScale
    }

    /// Retrieves a model that applied to world scale.
    public func getTransformedModel() -> Model3D {
        model.transformedBy(
            Transform3D(
                position: worldPosition,
                eulerRotation: worldRotation,
                scale: worldScale))
    }
}

extension SceneObject: Equatable {
    public static func == (lhs: SceneObject, rhs: SceneObject) -> Bool {
        lhs.model == rhs.model
            && lhs.worldPosition == rhs.worldPosition
            && lhs.worldRotation == rhs.worldRotation
            && lhs.worldScale == rhs.worldScale
    }
}

extension SceneObject {
    /// The transformation that converts the model into world space.
    public var transformation: Transform3D {
        Transform3D(position: worldPosition, eulerRotation: worldRotation, scale: worldScale)
    }
}
