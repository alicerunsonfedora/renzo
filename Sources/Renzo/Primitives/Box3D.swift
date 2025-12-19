//
//  Box3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

/// A representation of a box in three-dimensional space.
///
/// A box can be considered a three-dimensional variant of a PlaydateUIKit `UIRect` or a PlaydateKit `Rect`.
public struct Box3D: Equatable {
    /// The origin of the box.
    public var origin: Point3D

    /// The size of the box in all three dimensions.
    public var size: Size3D

    public init(origin: Point3D, size: Size3D) {
        self.origin = origin
        self.size = size
    }
}

extension Box3D {
    public var description: String {
        "Box3D(origin: \(origin.description), size: \(size.description))"
    }

    /// The centermost point of the box.
    public var center: Point3D {
        Point3D(
            x: origin.x + (size.length / 2),
            y: origin.y + (size.length / 2),
            z: origin.z + (size.height / 2))
    }

    /// The minimum point along the X axis.
    public var minX: Float { origin.x }

    /// The middle point along the X axis.
    public var midX: Float { origin.x + (size.width / 2) }

    /// The maximum point along the X axis.
    public var maxX: Float { origin.x + size.width }

    /// The minimum point along the Y axis.
    public var minY: Float { origin.y }

    /// The middle point along the Y axis.
    public var midY: Float { origin.y + (size.length / 2) }

    /// The maximum point along the Y axis.
    public var maxY: Float { origin.y + size.length }

    /// The minimum point along the Z axis.
    public var minZ: Float { origin.z }

    /// The middle point along the Z axis.
    public var midZ: Float { origin.z + (size.height / 2) }

    /// The maximum point along the Z axis.
    public var maxZ: Float { origin.z + size.height }

    /// Returns whether the specified point in space is contained in the box.
    /// - Parameter point: The point that might be included in the box.
    /// - Parameter includeHeight: Whether the height of the box should also be considered.
    public func contains(point: Point3D, includeHeight: Bool = true) -> Bool {
        let lengthContained = point.x >= minX && point.x <= maxX
        let widthContained = point.y >= minY && point.y <= maxY
        let heightContained = point.z >= minZ && point.z <= maxZ

        if includeHeight {
            return lengthContained && widthContained && heightContained
        }
        return lengthContained && widthContained
    }

    /// Returns whether the box intersects another box.
    public func intersects(other: Box3D) -> Bool {
        self.minX <= other.maxX && self.maxX >= other.minX
            && self.minY <= other.maxY && self.maxY >= other.minY
            && self.minZ <= other.minZ && self.maxZ >= other.minZ
    }
}

/// A representation of an axis-aligned bounding box.
///
/// Axis aligned bounding boxes are typically used to check whether three-dimensional objects are colliding with each
/// other.
public typealias AlignedBox = Box3D

extension AlignedBox {
    /// Create an axis-aligned bounding box for the given model.
    /// > Important: This initializer expects that the model provided is in world space.
    /// - Parameter model: The model to create an axis-aligned bounding box of.
    /// - Parameter safeMargin: The safe margin to apply to ensure more accurate collision checks.
    public init(axisAlignedFor model: Model3D, safeMargin: Float = 0.01) {
        var minVert = model[0].pointA
        var maxVert = model[0].pointA

        for face in model {
            minVert = min(minVert, face.pointA)
            minVert = min(minVert, face.pointB)
            minVert = min(minVert, face.pointC)

            maxVert = max(maxVert, face.pointA)
            maxVert = max(maxVert, face.pointB)
            maxVert = max(maxVert, face.pointC)
        }

        minVert -= safeMargin
        maxVert += safeMargin

        let sizeVert = (maxVert - minVert)

        self.origin = minVert
        self.size = Size3D(width: sizeVert.x, length: sizeVert.y, height: sizeVert.z)
    }
}
