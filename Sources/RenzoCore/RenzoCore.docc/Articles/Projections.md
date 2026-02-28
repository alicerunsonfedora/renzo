# Projections

Learn the fundamentals of projecting Renzo models from object space to
screen space.

## Overview

To display a three-dimensional model in two-dimensional space, it needs to
be _projected_ into screen space. 

Renzo provides two projection types available for use:

- ``TweetjamProjection`` is a simplified projection that is used to
  quickly display 3D models. This projection method is not intended for
  production use, but it provides an example for how to work with the
  ``Projection3D`` protocol.
- ``PerspectiveProjection`` is the standard perspective projection that
  relies on information about the current camera.

## Writing a custom projection

If the default projections are not suitable for your use case, you can
write your own projection. The ``Projection3D`` protocol is used to define
how this projection is performed:

```swift
public protocol Projection3D: AnyObject {
    func project(_ point: Point3D) -> Point2D
}
```

To conform to this protocol, implement the ``Projection3D/project(_:)``
method, which defines how the 3D point is to be projected into 2D space.

> Important: ``Projection3D`` assumes that the point being provided as an
> argument has already been translated into world space.

## Using a projection with the renderer

The `SceneRenderer` allows for setting a custom projection. To do so, use
the `SceneRenderer.init(scene:projection:frame:)` initializer:

```swift
class MyProjection: Projection3D { ... }

let scene: Scene3D = ...
let myProjection = MyProjection()

let renderer = SceneRenderer(scene: scene, projection: myProjection)
```

> Some scene renderer methods such as
> `SceneRenderer/setCameraIfAvailable(_:)` are only applicable to the
> ``PerspectiveProjection`` projection type.

## Topics

### Default projections

- ``PerspectiveProjection``
- ``TweetjamProjection``

### Writing a custom projection

- ``Projection3D``
