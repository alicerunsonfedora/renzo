//
//  Model3D+FileRead.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

extension Model3D {
    /// Create a 3D model by reading a file from the game's resources.
    /// - Parameter name: The name of the model to load from the game's resources.
    public init(named name: String) throws(Model3DDecoderError) {
        guard let path = Bundle.main.path(forResource: name, ofType: .model) else {
            throw .readerEmptyOrUnknownFile
        }
        self = try Model3D(reading: path)
    }
    /// Create a 3D model by loading an MDL3D file (`.model`).
    /// - Parameter path: The file path of the model on the Playdate's disk.
    public init(reading path: String) throws(Model3DDecoderError) {
        var faces = [TriFace3D]()

        guard let stat = try? File.stat(path: path), stat.size > 0 else {
            throw .readerEmptyOrUnknownFile
        }

        guard var file = try? File.open(path: path, mode: .read) else {
            throw .readerEmptyOrUnknownFile
        }

        let magicHeader = String(reading: &file, bytes: 5)
        guard magicHeader == "MDL3D" else {
            throw .readerHeaderMismatch
        }

        while FileReadingUtils.expectHeader("f", in: &file) {
            let face = Self.makeFace(reading: &file)
            faces.append(face)
        }

        do {
            try file.close()
        } catch {
            throw .readerCorruptFile
        }

        self.faces = faces
    }

    private static func makeFace(reading file: inout File.FileHandle) -> TriFace3D {
        var face = TriFace3D(a: .zero, b: .zero, c: .zero)
        _ = withUnsafeMutablePointer(to: &face) { ptr in
            try? file.read(buffer: ptr, length: UInt32(MemoryLayout<TriFace3D>.size))
        }
        return face
    }
}
