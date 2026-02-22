//
//  Size2D.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-02-2026.
//

/// A representation of a size in two-dimensional space.
public struct Size2D: Sendable, Equatable, Hashable {
    /// The size's width.
    public var width: Float

    /// The size's height.
    public var height: Float

    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }

    public var description: String {
        "Size2D(width: \(width), height: \(height))"
    }
}

extension Size2D {
    public static var zero: Size2D { Size2D(width: 0, height: 0) }
}
