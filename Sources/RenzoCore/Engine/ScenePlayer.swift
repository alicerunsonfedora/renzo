//
//  ScenePlayer.swift
//  Renzo
//
//  Created by Marquis Kurt on 21-02-2026.
//

/// A protocol that defines a player object in a scene.
public protocol ScenePlayer: AnyObject {
    /// The player's current world position.
    var position: Point3D { get set }

    /// The player's current world rotation.
    var rotation: Quaternion { get set }

    /// The player's current world scale.
    var scale: Point3D { get set }
}

extension ScenePlayer {
    /// The transformation representing the player's spatial data.
    public var transform: Transform3D {
        Transform3D(position: position, rotation: rotation, scale: scale)
    }
}
