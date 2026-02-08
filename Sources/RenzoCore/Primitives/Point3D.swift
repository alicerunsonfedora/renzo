//
//  Point3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 08-02-2026.
//

#if Playdate && hasFeature(Embedded) && canImport(PlaydateKit)
    import PlaydateKit
#else
    import Foundation
#endif

infix operator **
infix operator **=

/// A representation of a three-dimensional point in space.
public struct Point3D: Equatable {
    /// The point along the X axis.
    public var x: Float

    /// The point along the Y axis.
    public var y: Float

    /// The point along the Z axis.
    public var z: Float

    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Point3D {
    /// A point that represents (0, 0, 0).
    public static var zero: Point3D { Point3D(x: 0, y: 0, z: 0) }

    /// A point that represents (1, 1, 1).
    public static var one: Point3D { Point3D(x: 1, y: 1, z: 1) }

    public var description: String {
        "Point3D(x: \(x), y: \(y), z: \(z))"
    }

    /// The magnitude or length of the vector.
    public var length: Float {
        sqrtf(x * x + y * y + z * z)
    }

    /// The squared magnitude or length of the vector.
    public var squaredLength: Float {
        x * x + y * y + z * z
    }

    public static func + (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func + (lhs: Point3D, rhs: Float) -> Point3D {
        lhs + Point3D(x: rhs, y: rhs, z: rhs)
    }

    public static func += (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs + rhs
    }

    public static func += (lhs: inout Point3D, rhs: Float) {
        lhs = lhs + rhs
    }

    public static func - (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func - (lhs: Point3D, rhs: Float) -> Point3D {
        lhs - Point3D(x: rhs, y: rhs, z: rhs)
    }

    public static func -= (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs - rhs
    }

    public static func -= (lhs: inout Point3D, rhs: Float) {
        lhs = lhs - rhs
    }

    public static func * (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }

    public static func * (lhs: Point3D, rhs: Float) -> Point3D {
        lhs * Point3D(x: rhs, y: rhs, z: rhs)
    }

    public static func *= (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs * rhs
    }

    public static func *= (lhs: inout Point3D, rhs: Float) {
        lhs = lhs * rhs
    }

    public static func / (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }

    public static func / (lhs: Point3D, rhs: Float) -> Point3D {
        lhs / Point3D(x: rhs, y: rhs, z: rhs)
    }

    public static func /= (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs / rhs
    }

    public static func /= (lhs: inout Point3D, rhs: Float) {
        lhs = lhs / rhs
    }

    /// Returns the cross product of the vector.
    public static func ** (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(
            x: lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.z * rhs.x - lhs.x * rhs.z,
            z: lhs.x * rhs.y - lhs.y * rhs.x)
    }

    /// Returns the cross product of the vector.
    public static func crossProduct(lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(
            x: lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.z * rhs.x - lhs.x * rhs.z,
            z: lhs.x * rhs.y - lhs.y * rhs.x)
    }

    /// Returns the cross product of the vector.
    public func crossProduct(with other: Point3D) -> Point3D {
        Self.crossProduct(lhs: self, rhs: other)
    }

    public static func **= (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs ** rhs
    }

    /// Returns the dot product of itself with another point.
    public func dotProduct(with other: Point3D) -> Float {
        self.x * other.x + self.y * other.y + self.z * other.z
    }

    /// Returns a normalized version of the point, such that all components add up to 1.
    public func normalized() -> Point3D {
        let savedLength = self.length
        guard savedLength > 0 else { return .zero }
        return self / savedLength
    }

    /// Returns the distance to another point.
    /// - Parameter other: The other point to get the distance to.
    public func distance(to other: Point3D) -> Float {
        let offset = self - other
        return offset.length
    }

    /// Returns the squared distance to another point.
    /// - Parameter other: The other point to get the distance to.
    public func squaredDistance(to other: Point3D) -> Float {
        let offset = self - other
        return offset.squaredLength
    }
}

extension Point3D: Transformable3D {
    public func transformedBy(_ transform: Transform3D) -> Point3D {
        var transformedVec = self

        /// Handle scaling the vector.
        if transform.scale != .one {
            transformedVec *= transform.scale
        }

        // Then handle rotating the vector.
        if transform.rotation != .identity {
            transformedVec = transformedVec.rotatebyQuat(transform.rotation)
        }

        // Then apply the translation.
        transformedVec += transform.position

        return transformedVec
    }

    public mutating func transformBy(_ transform: Transform3D) {
        self = self.transformedBy(transform)
    }

    private func rotatebyQuat(_ quaternion: Quaternion) -> Self {
        var new = self

        // swiftlint:disable identifier_name
        let ww = quaternion.w * quaternion.w
        let xx = quaternion.x * quaternion.x
        let yy = quaternion.y * quaternion.y
        let zz = quaternion.z * quaternion.z
        let wx = quaternion.w * quaternion.x
        let wy = quaternion.w * quaternion.y
        let wz = quaternion.w * quaternion.z
        let xy = quaternion.x * quaternion.y
        let xz = quaternion.x * quaternion.z
        let yz = quaternion.y * quaternion.z
        // swiftlint:enable identifier_name

        new.x =
            ww * self.x + 2 * wy * self.z - 2 * wz * self.y + xx * self.x + 2 * xy * self.y + 2 * xz
            * self.z - zz * self.x - yy * self.x
        new.y =
            2 * xy * self.x + yy * self.y + 2 * yz * self.z + 2 * wz * self.x - zz * self.y + ww
            * self.y
            - 2 * wx * self.z - xx * self.y
        new.z =
            2 * xz * self.x + 2 * yz * self.y + zz * self.z - 2 * wy * self.x - yy * self.z + 2 * wx
            * self.y - xx * self.z + ww * self.z

        return new
    }
}

// MARK: - Maths

/// Returns the minimum between two three-dimensional points, component wise.
public func min(_ lhs: Point3D, _ rhs: Point3D) -> Point3D {
    Point3D(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y), z: min(lhs.z, rhs.z))
}

/// Returns the maximum between two three-dimensional points, component wise.
public func max(_ lhs: Point3D, _ rhs: Point3D) -> Point3D {
    Point3D(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y), z: max(lhs.z, rhs.z))
}
