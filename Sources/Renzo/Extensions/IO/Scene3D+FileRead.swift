//
//  Scene3D+FileRead.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDFoundation
import PlaydateKit

extension Scene3D {
    /// Create a scene by reading a scene file from the game's resources.
    /// - Parameter name: The name of the scene to load.
    public init(named name: String) throws(Model3DDecoderError) {
        guard let path = Bundle.main.path(forResource: name, ofType: .scene) else {
            throw .readerEmptyOrUnknownFile
        }
        self = try Scene3D(reading: path)
    }

    /// Create a scene by reading a `.pdscene` file from the game's resources.
    /// - Parameter path: The path to the scene file to read.
    public init(reading path: String) throws(Model3DDecoderError) {
        var cameras = [Camera3D]()
        var modelRefs = [ModelReference]()
        var lights = [Point3D]()

        guard File.fileExists(at: path) else {
            throw .readerEmptyOrUnknownFile
        }

        guard var file = try? File.open(path: path, mode: .read) else {
            throw .readerEmptyOrUnknownFile
        }

        let magicHeader = String(reading: file, ofLength: 7)
        guard magicHeader == "PDSCENE" else {
            throw .readerHeaderMismatch
        }

        cameras = try Self.loadCameras(from: &file)

        if FileReadingUtils.expectText("refs", bytes: 4, in: &file) {
            modelRefs = try Self.loadReferences(from: &file)
        }

        if FileReadingUtils.expectText("lights", bytes: 6, in: &file) {
            let lightsCount = UInt32(reading: file)
            if lightsCount > 0 {
                for _ in 1...lightsCount {
                    let source = Point3D(reading: file)
                    lights.append(source)
                }
                guard lights.count == lightsCount else { throw .readerCorruptFile }
            }
        }

        do {
            try file.close()
        } catch {
            throw .readerCorruptFile
        }

        self.cameras = cameras
        self.models = modelRefs
        self.lights = lights
    }

    private static func loadReferences(
        from file: inout File.FileHandle
    ) throws(Model3DDecoderError) -> [ModelReference] {
        let refModelsCount = UInt32(reading: file)
        if refModelsCount <= 0 { return [] }

        var modelRefs = [ModelReference]()
        for _ in 1...refModelsCount {
            let strlen = UInt32(reading: file)
            guard strlen > 0 else { throw .readerCorruptFile }

            let name = String(reading: file, ofLength: Int(strlen))
            let position = Point3D(reading: file)
            let rotation = Point3D(reading: file)
            let scale = Point3D(reading: file)

            let refModel = ModelReference(
                name: name, position: position, rotation: rotation, scale: scale)
            modelRefs.append(refModel)
        }
        guard modelRefs.count == refModelsCount else { throw .readerCorruptFile }
        return modelRefs
    }

    private static func loadCameras(from file: inout File.FileHandle) throws(Model3DDecoderError) -> [Camera3D] {
        guard FileReadingUtils.expectText("cam", bytes: 3, in: &file) else {
            throw .readerCorruptFile
        }

        let cameraCount = UInt32(reading: file)
        guard cameraCount > 0 else {
            throw .readerCorruptFile
        }
        var cameras = [Camera3D]()

        for _ in 1...cameraCount {
            let camera = Camera3D(reading: file)
            cameras.append(camera)
        }
        guard cameras.count == cameraCount else { throw .readerCorruptFile }
        return cameras
    }
}
