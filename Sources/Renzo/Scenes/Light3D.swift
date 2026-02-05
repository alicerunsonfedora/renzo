//
//  Light3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 04-02-2026.
//

/// A structure representing a point light in a scene.
public struct Light3D: Equatable {
    /// The light's world position.
    public var position: Point3D

    /// The energy of the light.
    public var power: Float

    /// The falloff distance of the light.
    public var falloff: Float

    public init(position: Point3D, power: Float, falloff: Float) {
        self.position = position
        self.power = power
        self.falloff = falloff
    }
}

extension Light3D {
    public var description: String {
        "Light3D(position: \(position.description), power: \(power), falloff: \(falloff))"
    }
}
