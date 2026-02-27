# ``Renzo/SceneRenderer``

### Sorting faces and objects

When the scene uses a ``PerspectiveProjection``, objects and faces can be
sorted to ensure their Z order appears correctly relative to the current
camera in use. Scene objects and their model faces are sorted by distance
from the camera. By default, the scene will re-sort objects and faces
whenever the camera changes; call ``setNeedsFaceSorting()`` and/or
``setNeedsObjectSorting()``, respectively, to notify the scene to sort
again.

For example, you may need to call ``setNeedsObjectSorting()`` if one of the
scene objects continuously moves, like a player model:

```swift
class MyPlayer {
    let renderer: SceneRenderer
    let player: ScenePlayer

    func process() {
        player.position.x += 30
        setNeedsObjectSorting()
    }
}
```

> Important: Sorting model faces is an expensive operation and should only
> be called when it is absolutely necessary to do so.

## Topics

### Initializers

- ``init(scene:frame:)``
- ``init(scene:projection:frame:)``

### Instance Properties

- ``frame``
- ``scene``

### Rendering scene data

- ``allowsBackfaceCulling``
- ``projection``
- ``drawModel(_:transformedBy:into:)``
- ``render()``

### Working with cameras and lighting

- ``getBrightness(of:)``
- ``setCameraIfAvailable(_:)``

### Sorting objects and faces

- ``needsFaceSorting``
- ``needsObjectSorting``
- ``setNeedsFaceSorting()``
- ``setNeedsObjectSorting()``

### Working with scene objects

- ``sceneObjects``
- ``addChild(_:requiresSorting:)``
- ``removeChild(_:)``
