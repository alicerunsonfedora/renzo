//
//  Point2D.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-02-2026.
//

/// A representation of a point in two-dimensional space.
public struct Point2D: Sendable, Equatable, Hashable {
    /// The point along the X axis.
    public var x: Float

    /// The point along the Y axis.
    public var y: Float

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

extension Point2D {
    public static var zero: Self { Point2D(x: 0, y: 0) }
    public static var one: Self { Point2D(x: 1, y: 1) }

    public static func + (lhs: Self, rhs: Self) -> Self {
        Point2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func + (lhs: Self, rhs: Float) -> Self {
        Point2D(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    public static func += (lhs: inout Self, rhs: Float) {
        lhs = lhs + rhs
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        Point2D(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func - (lhs: Self, rhs: Float) -> Self {
        Point2D(x: lhs.x - rhs, y: lhs.y - rhs)
    }

    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    public static func -= (lhs: inout Self, rhs: Float) {
        lhs = lhs - rhs
    }

    public static func * (lhs: Self, rhs: Self) -> Self {
        Point2D(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    public static func * (lhs: Self, rhs: Float) -> Self {
        Point2D(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    public static func *= (lhs: inout Self, rhs: Float) {
        lhs = lhs * rhs
    }

    public static func / (lhs: Self, rhs: Self) -> Self {
        Point2D(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    public static func / (lhs: Self, rhs: Float) -> Self {
        Point2D(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    public static func /= (lhs: inout Self, rhs: Float) {
        lhs = lhs / rhs
    }
}
