//
//  RenzoDemo.swift
//  Renzo
//
//  Created by Marquis Kurt on 24-01-2026.
//

import PlaydateKit
import Renzo

@PlaydateMain
final class Game: PlaydateGame {
    #if Benchmarking
        let scene: BenchmarkingScene
    #else
        let scene: DemoScene
    #endif

    init() {
        #if Benchmarking
            scene = BenchmarkingScene()
        #else
            scene = DemoScene()
        #endif
    }

    func update() -> Bool {
        scene.update()
        return true
    }
}
