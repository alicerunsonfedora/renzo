//
//  BenchmarkingScene.swift
//  Renzo
//
//  Created by Marquis Kurt on 24-01-2026.
//

import PDFoundation
import PDGraphics
import PlaydateKit
import Renzo

private let BENCHMARK_END_FRAME = 700

final class BenchmarkingRenderer: SceneRenderer {
    let suzieMeasure: Measurement
    let tableMeasure: Measurement
    var suzieCount = 0

    init(scene: Scene3D, frame: Rect = .display, sMeasure: Measurement, tMeasure: Measurement) {
        self.suzieMeasure = sMeasure
        self.tableMeasure = tMeasure
        super.init(scene: scene, frame: frame)
    }

    override func drawModel(_ model: Model3D, transformedBy transform: Transform3D, into frameBuffer: inout PGBuffer) {
        let measurement = model.count == suzieCount ? suzieMeasure : tableMeasure
        measurement.reset()
        super.drawModel(model, transformedBy: transform, into: &frameBuffer)
        measurement.checkpoint()
    }
}

class BenchmarkingScene {
    var sceneRenderer: BenchmarkingRenderer?
    var failedToLoad: Bool = false
    var currentBenchmarkFrame: Int = 0
    var currentSceneObject: SceneObject

    let suzieMeasure = Measurement("Draw Suzie", in: .milliseconds)
    let tableMeasure = Measurement("Draw Table", in: .milliseconds)

    let background: Graphics.Bitmap!

    init() {
        do {
            let scene = try Scene3D(named: "Benchmark")
            let renderer = BenchmarkingRenderer(scene: scene, sMeasure: suzieMeasure, tMeasure: tableMeasure)

            let suzie = try Model3D(named: "Suzanne")
            renderer.suzieCount = suzie.count

            let sceneObject = SceneObject(model: suzie, worldPosition: .zero, worldRotation: .zero)
            self.currentSceneObject = sceneObject
            renderer.addChild(sceneObject)

            sceneRenderer = renderer
        } catch {
            PDReportError("The benchmark couldn't be loaded.")
            failedToLoad = true
            let sceneObject = SceneObject(model: Model3D(faces: []), worldPosition: .zero, worldRotation: .zero)
            self.currentSceneObject = sceneObject
            sceneRenderer = nil

        }
        do {
            background = try Graphics.Bitmap(path: "Resources/Background")
        } catch {
            failedToLoad = true
            background = nil
        }
    }

    func update() {
        if failedToLoad {
            Graphics.drawText("Benchmark could not be loaded", at: Point(x: 16, y: 16))
            return
        }

        if currentBenchmarkFrame >= BENCHMARK_END_FRAME { return }
        processBenchmark()
        guard let sceneRenderer else { return }
        Graphics.drawBitmap(background, at: .zero)
        sceneRenderer.render()
        System.drawFPS()

        currentBenchmarkFrame += 1
        if currentBenchmarkFrame == BENCHMARK_END_FRAME {
            print("=== BENCHMARK ENDED ===")
            suzieMeasure.record(displayTimesAsAverages: true)
            tableMeasure.record(displayTimesAsAverages: true)
        }
    }

    private func processBenchmark() {
        if currentBenchmarkFrame == 0 {
            print(
                """
                === BENCHMARK STARTED ===
                Note: The benchmark may run slower than expected on device.
                """
            )
        }
        guard (500...BENCHMARK_END_FRAME).contains(currentBenchmarkFrame) else { return }
        if currentBenchmarkFrame == 500 {
            print("Starting to move Suzie.")
        }
        currentSceneObject.worldPosition.x -= 0.05
    }
}
