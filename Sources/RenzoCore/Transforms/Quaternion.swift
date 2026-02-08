//
//  Quaternion.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

#if Playdate && hasFeature(Embedded) && canImport(PlaydateKit)
    import PlaydateKit
#else
    import Foundation
#endif

/// A structural representation of a quaternion.
///
/// Quaternions are typically used to define a series of non-commutative rotations.
public struct Quaternion: Equatable, Hashable, Sendable {
    /// The quaternion's W component.
    public var w: Float

    /// The quaternion's X component.
    public var x: Float

    /// The quaternion's Y component.
    public var y: Float

    /// The quaternion's Z component.
    public var z: Float

    public init(w: Float, x: Float, y: Float, z: Float) {
        let length = sqrtf(w * w + x * x + y * y + z * z)
        self.w = w / length
        self.x = x / length
        self.y = y / length
        self.z = z / length
    }

    /// Create a quaternion by converting a point representing an Euler rotation.
    ///
    /// > Important: This initializer assumes that the Euler rotation is in 'XYZ' order.
    /// - Parameter euler: The Euler rotation to convert into a quaternion.
    public init(euler: Point3D) {
        let xQuat = Quaternion(w: cosf(euler.x / 2), x: sinf(euler.x / 2), y: 0, z: 0)
        let yQuat = Quaternion(w: cosf(euler.y / 2), x: 0, y: sinf(euler.y / 2), z: 0)
        let zQuat = Quaternion(w: cosf(euler.z / 2), x: 0, y: 0, z: sinf(euler.z / 2))

        // Rotation using XYZ Euler angles.
        self = (yQuat * zQuat) * xQuat
    }

    public var description: String {
        "Quaternion(w: \(w), x: \(x), y: \(y), z: \(z))"
    }

}

extension Quaternion {
    /// The identity quaternion (i.e., no rotation applied).
    public static var identity: Quaternion { Quaternion(w: 1, x: 0, y: 0, z: 0) }

    public static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        Quaternion(
            w: lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z,
            x: lhs.x * rhs.w + lhs.w * rhs.x + lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.w * rhs.y - lhs.x * rhs.z + lhs.y * rhs.w + lhs.z * rhs.x,
            z: lhs.w * rhs.z + lhs.x * rhs.y - lhs.y * rhs.x + lhs.z * rhs.w
        )
    }

    public static func *= (lhs: inout Quaternion, rhs: Quaternion) {
        lhs = lhs * rhs
    }

    /// Returns the inverse of the quaternion.
    public func inverted() -> Quaternion {
        var newQuat = self
        newQuat.x *= -1
        newQuat.y *= -1
        newQuat.z *= -1
        return newQuat
    }

    /// Returns the conjugate of the quaternion.
    ///
    /// In this implementation, it is identical to ``inverted()``.
    public func conjugated() -> Quaternion {
        self.inverted()
    }
}
