# Renzo

With **Renzo**, you can display and interact with 3D content in your
Playdate app or game through PlaydateKit. Load three-dimensional scenes
and models from files or generated structures, and render them with
various projection mechanisms.

**Renzo** also has a companion extension for Blender that lets you export
models and scenes into the `.model` and `.pdscene` file formats that Renzo
can use to render 3D content.

> **Important** 
> Renzo is a pre-release library and is not production ready. Use at your
> own risk!

## What's included?

Renzo provides three libraries that can be leveraged:

- `Renzo`, the main package, provides all the facilities for displaying
  and interacting with 3D content.
- `RenzoGraphics` provides facilities for more performant graphics
  rendering. This includes drawing scanlines, triangles, and rectangles.
- `RenzoFoundation` provides fundamental functions and systems used by
  `Renzo` and `RenzoGraphics`, such as logging, measurements, and file
  system loading.

## Getting started

Start by adding `Renzo` to your package dependencies with the Swift
Package Manager:

```swift
dependencies: [
    .package(url: "https://source.marquiskurt.net/PDUniverse/Renzo.git", branch: "main")
]
```

Then, in your PlaydateKit target, add the dependency:

```swift
targets: [
    .target(
        name: "MyGame",
        dependencies: [
            .product(name: "Renzo", package: "Renzo")
        ]
    )
]
```

### Rendering a basic scene

To render a scene, simply create a 3D scene and renderer:

```swift
@PlaydateMain
final class Game: PlaydateGame {
    let renderer: SceneRenderer

    init() {
        do {
            let sampleScene = try Scene3D(named: "Sample")
            self.renderer = SceneRenderer(scene: sampleScene, frame: .display)
        } catch {
            let scene = Scene3D(cameras: [
                Camera3D(position: .zero, rotation: .zero, fieldOfView: 0.5)
            ])
            self.renderer = SceneRenderer(scene: scene, frame: .display)
        }
    }

    func update() -> Bool {
        renderer.render()
        return true
    }
}
```

## Performance considerations

While Renzo tries to be as performant as reasonably possible under
Embedded Swift, the default parameters and configurations may not be
enough, depending on your use case. You may want to consider some of the
following options to improve performance:

- By default, Renzo handles all Playdate color types, including XOR. If
  you don't use the XOR color in your game and want to skip over these
  checks, you can remove the `AllowXOR` Swift package trait from your
  dependency definition:
  
  ```swift
  dependencies: [
      .package(
          url: "https://source.marquiskurt.net/PDUniverse/Renzo.git",
          branch: "main",
          traits: [])
  ]
  ```
  
  Doing so will skip compiling any checks for XOR and handling XOR cases
  when drawing triangles.
- If you are writing your own scene renderer, consider using the tools
  provided in `RenzoGraphics`. While the default SDK functions for drawing
  shapes such as triangles and rectangles generally suffice, they tend to
  be less performant. `RenzoGraphics` provides more performant versions of
  these functions; the `SceneRenderer`, for example, uses `RGFillTriangle`
  instead of `Graphics.fillTriangle` to draw model faces.

## License

Renzo is a free and open-source library licensed under the MIT License.
For more information on your rights, refer to LICENSE.txt. 

## Credits

Renzo is made possible thanks to the following open source projects:

- [PlaydateKit](https://github.com/finvoor/PlaydateKit) - MIT License