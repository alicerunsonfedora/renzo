//
//  DemoScene.swift
//  Renzo
//
//  Created by Marquis Kurt on 24-01-2026.
//

import PlaydateKit
import Renzo
import RenzoFoundation

class DemoScene {
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

    func update() {
        do {
            let image = try Graphics.Bitmap(path: "Resources/Background")
            Graphics.drawBitmap(image, at: .zero)
        } catch {
            print("Failed to load background image.")
        }
        renderer.render()
    }
}
