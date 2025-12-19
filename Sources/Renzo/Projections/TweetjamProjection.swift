//
//  TweetjamProjection.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A simple projection that assumes a face sits right in front of the camera at a given scale.
///
/// This projection is dervied from a simple Tweetjam algorithm used to quickly render a 3D model. While this can be
/// used for rendering, it is not considered ideal to do so.
public class TweetjamProjection: Projection3D {
    /// A structure describing the rotation of the face.
    public struct Rotation {
        /// The sine of the rotation.
        public var sine: Float

        /// The cosine of the rotation.
        public var cosine: Float

        public init(sin: Float, cos: Float) {
            self.sine = sin
            self.cosine = cos
        }

        /// The initial rotation.
        public static var initial: Rotation { Rotation(sin: 0, cos: 1) }
    }

    /// The center of the display or camera.
    public var center: Point2D

    /// How large the model will be.
    public var scale: Float = 50

    /// The tilt angle from above the face.
    public var tilt: Float = 0.2

    /// The face's rotation.
    public var rotation: Rotation = .initial

    public init(at center: Point2D, scaledBy scale: Float = 50, tilt: Float = 0.2) {
        self.center = center
        self.scale = scale
        self.tilt = tilt
    }

    public func project(_ point: Point3D) -> Point2D {
        let rotatedPoint = Point3D(
            x: point.x * rotation.cosine - point.y * rotation.sine,
            y: point.x * rotation.sine + point.y * rotation.cosine,
            z: point.z)

        return Point2D(
            x: center.x + rotatedPoint.x * scale,
            y: center.y - rotatedPoint.z * scale - rotatedPoint.y * scale * tilt)
    }
}
