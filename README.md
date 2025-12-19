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

## License

Renzo is a free and open-source library licensed under the MIT License.
For more information on your rights, refer to LICENSE.txt. 

## Credits

Renzo is made possible thanks to the following open source projects:

- [PlaydateKit](https://github.com/finvoor/PlaydateKit) - MIT License