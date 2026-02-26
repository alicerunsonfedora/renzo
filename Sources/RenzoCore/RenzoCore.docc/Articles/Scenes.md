# Display 3D scenes

Display a collection of models with basic lighting conditions from various
camera angles.

## Overview

A **scene** is a collection of models, cameras, and lights used to display
a 3D environment. They are often paired with background images and their
view is often projected using a projection such as
``PerspectiveProjection``.

Scenes can be constructed using the ``Scene3D`` structure:

```swift
let myScene = Scene3D(
    cameras: [
        Camera3D(...)
    ])
```

> Note: A basic scene only requires a camera in the environment.

The most typical case for creating scenes is through scene files in the
Playdate Scene file format (`.pdscene`). Renzo, for example, provides
facilities from reading scene files generated from
the **Renzo Utilities** add-on for Blender:

```swift
import Renzo

// Load a scene named "MyScene.pdscene"
let myScene = try Scene3D(named: "MyScene")
```

### Model references

To reduce the file size and prevent duplicates of 3D models, scenes
provide _references_ to models through the ``ModelReference`` type. A
reference consists of the model's name as it appears in the game's bundle
and its world-space transformation data:

```swift
let myModel = ModelReference(
    name: "Cube",
    position: .zero,
    rotation: .identity,
    scale: .one)
```

> Tip: When loading the contents of the scene, consider also loading the
> model alongside it. The ``SceneObject`` type allows you to preserve the
> model data alongside the model reference's transformation data, so that
> you can display the models without manipulating the model data directly:
>
> ```swift
> let objects = [SceneObject]()
>
> for modelReference in myScene.models {
>    let model = try Model3D(
>        named: modelReference.name)
>    let object = SceneObject(
>         model: model,
>         worldPosition: modelReference.position,
>         worldRotation: modelReference.rotation,
>         worldScale: modelReference.scale)
>     objects.append(object)
> }
> ```

### Interactive elements

Scenes can also contain interactive elements, such as triggers, to let
players interact with the environment.

> SeeAlso: For more information on interactive elements and how they can be
> used to enhance the player's experience, refer to the
> <doc:Using-Renzo-as-a-game-engine> section of the RenzoCore
> documentation.

## Topics

### The scene format

- ``Scene3D``
- ``Camera3D``
- ``Light3D``
- ``ModelReference``

### Working with scene objects

- ``SceneObject``
