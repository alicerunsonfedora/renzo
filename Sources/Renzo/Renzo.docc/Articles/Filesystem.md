# Load scenes and models from files

Load Renzo models and scenes from the Playdate file system using bundles.

## Overview

Models and scenes can be created by reading binary data from the Playdate
file system. The easiest approach is to provide the path to the file in
the game's bundle through ``RenzoCore/Model3D/init(reading:)`` or
``RenzoCore/Scene3D/init(reading:)``, respectively:

```swift
let suzie = try Model3D(reading: "assets/models/suzie.model")
```

### Reading from Playdate bundles

Renzo also provides interfaces for reading models and scenes from Playdate
bundles (`.pdbundle`), as defined by PDFoundation from PDKUtils. If your
models or scenes live in the game's main bundle, use the
``RenzoCore/Model3D/init(named:)`` or ``RenzoCore/Scene3D/init(named:)``
initializers, respectively.

```swift
// Suzie located at: MyGame.pdx/Resources/Models/Suzie.pdmodel
let suzie = try Model3D(named: "Suzie")
```

If you are loading a model or scene from another bundle, you can use the
standard bundle methods to get the path and read it:

```swift
if let path = myBundle.path(forResource: "Suzie", ofType: .model) {
    let suzie = try Model3D(reading: path)
}
```

## Topics

### Reading models

- ``RenzoCore/Model3D/init(named:)``
- ``RenzoCore/Model3D/init(reading:)``
- ``ModelResourceType``

### Reading scenes

- ``RenzoCore/Scene3D/init(named:)``
- ``RenzoCore/Scene3D/init(reading:)``
- ``SceneResourceType``

### Reading facilities

- ``PDFoundation/BundleResourceType/model``
- ``PDFoundation/BundleResourceType/scene``
- ``RenzoBinaryFileReadError``
