# ``RenzoCore/AlignedBox``

## Overview

Axis-aligned bounding boxes (AABBs) are typically used in collision
checks. For example, you can verify whether a player is colliding with
another scene object:

```swift
let player: ScenePlayer = ...
let otherObject: SceneObject = ...

let boundingBox = AlignedBox(axisAlignedFor: otherObject.model)

if boundingBox.contains(player.position, includeHeight: false) {
    // The player is colliding with this object!
}
```

Scene triggers are also considered as axis-aligned bounding boxes, and
such checks can also be used:

```swift
let myTrigger: SceneTrigger = ...

if myTrigger.region.contains(player) {
    // The player is in the trigger's activating region!
}
```

## Topics

### Creating an AABB for models

- ``Box3D/init(axisAlignedFor:safeMargin:)``
