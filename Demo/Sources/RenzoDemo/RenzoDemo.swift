import PlaydateKit
import Renzo

/// Boilerplate entry code
nonisolated(unsafe) var game: Game!
@_cdecl("eventHandler") func eventHandler(
    pointer: UnsafeMutablePointer<PlaydateAPI>,
    event: System.Event,
    arg _: CUnsignedInt
) -> CInt {
    switch event {
    case .initialize:
        Playdate.initialize(with: pointer)
        game = Game()
        System.updateCallback = game.update
    default: game.handle(event)
    }
    return 0
}

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
        do {
            let image = try Graphics.Bitmap(path: "Resources/Background")
            Graphics.drawBitmap(image, at: .zero)
        } catch {
            print("Failed to load background image.")
        }
        renderer.render()
        return true
    }
}
