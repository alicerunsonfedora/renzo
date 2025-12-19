//
//  Transform3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A structure describing a three-dimensional transformation.
public struct Transform3D: Equatable {
    /// The position that the transformation will translate by.
    public var position: Point3D

    /// The rotation that the transformation will rotate by.
    public var rotation: Quaternion

    /// The scale that the transformation will scale by.
    public var scale: Point3D

    public init(position: Point3D = .zero, rotation: Quaternion = .identity, scale: Point3D = .one) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }

    @_disfavoredOverload
    public init(position: Point3D = .zero, eulerRotation: Point3D = .zero, scale: Point3D = .one) {
        self.position = position
        self.rotation = Quaternion(euler: eulerRotation)
        self.scale = scale
    }
}

/// A protocol that defines transformation capabilities in three-dimensional space.
public protocol Transformable3D {
    /// Returns a copy of the object with a transformation applied.
    /// - Parameter transform: The transformation applied to the object.
    func transformedBy(_ transform: Transform3D) -> Self

    /// Transform the object with a given transformation.
    /// - Parameter transform: The transformation to apply.
    mutating func transformBy(_ transform: Transform3D)
}

extension Transformable3D {
    /// Returns a copy of the object translated by a point.
    /// - Parameter position: The position to translate the object by.
    public func translatedBy(_ position: Point3D) -> Self {
        self.transformedBy(Transform3D(position: position))
    }

    /// Returns a copy of the object translated by a point.
    /// - Parameter position: The position to translate the object by.
    public mutating func translateBy(_ position: Point3D) {
        self.transformBy(Transform3D(position: position))
    }

    /// Returns a copy of the object rotated by a quaternion.
    /// - Parameter rotation: The quaternion to rotate the object by.
    public func rotatedBy(_ rotation: Quaternion) -> Self {
        self.transformedBy(Transform3D(rotation: rotation))
    }

    /// Rotate the object by a quaternion.
    /// - Parameter rotation: The quaternion to rotate the object by.
    public mutating func rotateBy(_ rotation: Quaternion) {
        self.transformBy(Transform3D(rotation: rotation))
    }

    /// Returns a copy of the object rotated by an Euler (XYZ) rotation.
    /// - Parameter rotation: The Euler rotation to rotate the object by.
    public func rotatedBy(euler: Point3D) -> Self {
        self.transformedBy(Transform3D(eulerRotation: euler))
    }

    /// Rotate the object by an Euler (XYZ) rotation.
    /// - Parameter rotation: The Euler rotation to rotate the object by.
    public mutating func rotateBy(euler: Point3D) {
        self.transformBy(Transform3D(eulerRotation: euler))
    }

    /// Returns a copy of the object scaled by a vector.
    /// - Parameter scale: The vector to scale the object by.
    public func scaledBy(_ scale: Point3D) -> Self {
        self.transformedBy(Transform3D(scale: scale))
    }

    /// Scale the object by a vector.
    /// - Parameter scale: The vector to scale the object by.
    public mutating func scaleBy(_ scale: Point3D) {
        self.transformBy(Transform3D(scale: scale))
    }
}
