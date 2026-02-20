//
//  FileReadingUtils.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDFoundation
import PlaydateKit
import RenzoCore

enum FileReadingUtils {
    static func expectHeader(_ header: String, in file: inout PDFile) -> Bool {
        expectText(header, bytes: 1, in: &file)
    }

    static func expectText(_ text: String, bytes: Int, in file: inout PDFile) -> Bool {
        guard let currentPos = try? file.currentSeekPosition() else { return false }
        let magicHeader = UnsafeMutableRawPointer.allocate(
            byteCount: bytes, alignment: MemoryLayout<CChar>.alignment)
        do {
            _ = try file.read(buffer: magicHeader, length: UInt32(bytes))
        } catch {
            try? file.seek(to: currentPos)
            return false
        }

        let buffer = UnsafeBufferPointer<UInt8>(
            start: magicHeader.assumingMemoryBound(to: UInt8.self), count: bytes)
        let headerString = String(decoding: buffer, as: Unicode.UTF8.self)

        let isMatching = headerString.utf8.elementsEqual(text.utf8)
        if !isMatching { try? file.seek(to: currentPos) }
        return isMatching
    }
}

// MARK: - Convenience Reading

extension Point3D {
    init(reading file: PDFile) {
        self = .zero
        file.read(as: Point3D.self, into: &self)
    }
}

extension TriFace3D {
    init(reading file: PDFile) {
        self = TriFace3D(a: .zero, b: .zero, c: .zero)
        file.read(as: TriFace3D.self, into: &self)
    }
}

extension Camera3D {
    init(reading file: PDFile) {
        self = Camera3D(position: .zero, rotation: .zero, fieldOfView: 0)
        file.read(as: Camera3D.self, into: &self)
    }
}

extension Light3D {
    init(reading file: PDFile) {
        self = Light3D(position: .zero, power: 0, falloff: 0)
        file.read(as: Light3D.self, into: &self)
    }
}

extension Box3D {
    init(reading file: PDFile) {
        self = .zero
        file.read(as: Box3D.self, into: &self)
    }
}

extension SceneTrigger {
    init(reading file: PDFile) {
        self = SceneTrigger(on: .never, in: .zero, perform: [])
        self.region = Box3D(reading: file)

        let conditionValue = UInt32(reading: file)
        if let condition = SceneTrigger.Condition(rawValue: conditionValue) {
            self.condition = condition
        }

        let frequencyValue = UInt32(reading: file)
        if let frequency = SceneTrigger.Frequency(rawValue: frequencyValue) {
            self.frequency = frequency
        }

        let actionCount = UInt32(reading: file)
        if actionCount <= 0 { return }

        for _ in 1...actionCount {
            parseAction(from: file)
        }
    }

    private mutating func parseAction(from file: PDFile) {
        guard let kvSeparator = "=".utf8.first else { return }
        let strBytes = UInt32(reading: file)
        let stringValue = String(reading: file, ofLength: Int(strBytes))

        switch stringValue {
        case "Debug":
            self.actions.append(.debugging)
        case "Autosave":
            self.actions.append(.autosave)

        // NOTE(marquiskurt): Some actions might be represented as a key-value pair, which must be decoded accordingly.
        case stringValue where stringValue.utf8.contains(kvSeparator):
            let kvPair = stringValue.utf8.split(separator: kvSeparator, maxSplits: 1)
            guard let keyUTF8 = kvPair.first, let valueUTF8 = kvPair.last else { return }

            switch (String(decoding: keyUTF8, as: UTF8.self), String(decoding: valueUTF8, as: UTF8.self)) {
            case ("SetCamera", let cameraValue):
                guard let camera = Int(cameraValue) else { return }
                self.actions.append(.cameraSelect(camera))
            default:
                break
            }

        default:
            break
        }
    }
}
