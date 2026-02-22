//
//  Size3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A representation of a size in three-dimensional space.
public struct Size3D: Equatable, Hashable, Sendable {
    /// The width component of the size.
    public var width: Float

    /// The length component of the size.
    public var length: Float

    /// The height component of the size.
    public var height: Float

    public init(width: Float, length: Float, height: Float) {
        self.width = width
        self.length = length
        self.height = height
    }

    public var description: String {
        "Size3D(width: \(width), length: \(length), height: \(height))"
    }
}

extension Size3D {
    /// A size that represents zero.
    public static var zero: Size3D { Size3D(width: 0, length: 0, height: 0) }
}
