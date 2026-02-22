//
//  PerspectiveProjectionExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-02-2026.
//

import PlaydateKit

extension PerspectiveProjection {
    /// Create a projection from a camera in a given frame.
    /// - Parameter camera: The camera from which points will be projected.
    /// - Parameter rect: The camera's frame.
    public convenience init(camera: Camera3D, rect: Rect) {
        self.init(camera: camera, in: Box2D(rect))
    }
}
