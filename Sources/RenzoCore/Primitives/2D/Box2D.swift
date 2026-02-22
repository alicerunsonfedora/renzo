//
//  Box2D.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-02-2026.
//

/// A representation of a box in two-dimensional space.
public struct Box2D: Sendable, Equatable, Hashable {
    /// The box's origin point.
    public var origin: Point2D

    /// The box's size.
    public var size: Size2D

    public init(origin: Point2D, size: Size2D) {
        self.origin = origin
        self.size = size
    }
}

extension Box2D {
    /// The centermost point of the box.
    public var center: Point2D {
        Point2D(x: midX, y: midY)
    }

    /// The box's minimum X value.
    public var minX: Float { origin.x }

    /// The box's median X value.
    public var midX: Float { origin.x + (size.width / 2) }

    /// The box's maximum X value.
    public var maxX: Float { origin.x + size.width }

    /// The box's minimum Y value.
    public var minY: Float { origin.y }

    /// The box's median Y value.
    public var midY: Float { origin.y + (size.height / 2) }

    /// The box's maximum Y value.
    public var maxY: Float { origin.y + size.height }

    /// Returns whether the box contains a point.
    /// - Parameter point: The point to validate.
    public func contains(point: Point2D) -> Bool {
        point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }
}
