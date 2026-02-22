//
//  PerspectiveProjection.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

#if Playdate && hasFeature(Embedded) && canImport(PlaydateKit)
    import PlaydateKit
#else
    import Foundation
#endif

/// A projection method that projects points relative the position and rotation of a camera in three-dimensional space.
public class PerspectiveProjection: Projection3D {
    /// The camera from which points are projected.
    public var camera: Camera3D {
        didSet { didSetCamera() }
    }

    /// The camera's rotation represented as a quaternion.
    public private(set) var cameraRotation: Quaternion

    /// The multiplier determining the between pixels and world units (i.e., the number of pixels representing a single
    /// world unit when it is precisely one world unit away from camera).
    public private(set) var fovMult: Float

    /// The camera's frame.
    public var frame: Box2D {
        didSet {
            self.fovMult = tanf(camera.fieldOfView / 2) * 2 * Float(frame.size.width)
        }
    }

    /// Create a projection from a camera in a given render region.
    /// - Parameter camera: The camera from which points will be projected.
    /// - Parameter rect: The region describing the surface to render to.
    public init(camera: Camera3D, in region: Box2D) {
        self.fovMult = tanf(camera.fieldOfView / 2) * 2 * Float(region.size.width)
        self.cameraRotation = Quaternion(euler: camera.rotation).inverted()
        self.camera = camera
        self.frame = region
    }

    public func project(_ point: Point3D) -> Point2D {
        // Convert the point from object space, to world space, to the camera's object space.
        let offset = point - camera.position
        var viewspacePosition = offset.rotatedBy(cameraRotation)
        viewspacePosition.z *= -1

        // Ignore points that are behind the camera by returning a zero value.
        if viewspacePosition.z <= 0 {
            return .zero
        }

        // Account for "the perspective divide".
        let parallax = self.fovMult / viewspacePosition.z

        return Point2D(
            x: self.frame.center.x + (viewspacePosition.x * parallax),
            y: self.frame.center.y - (viewspacePosition.y * parallax))
    }

    func didSetCamera() {
        cameraRotation = Quaternion(euler: camera.rotation).inverted()
        fovMult = tanf(camera.fieldOfView / 2) * 2 * Float(frame.size.width)
    }
}
