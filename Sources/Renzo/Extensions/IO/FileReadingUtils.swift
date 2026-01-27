//
//  FileReadingUtils.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit
import RenzoFoundation

enum FileReadingUtils {
    static func expectHeader(_ header: String, in file: inout RFFile) -> Bool {
        expectText(header, bytes: 1, in: &file)
    }

    static func expectText(_ text: String, bytes: Int, in file: inout RFFile) -> Bool {
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
    init(reading file: RFFile) {
        self = .zero
        file.read(as: Point3D.self, into: &self)
    }
}

extension TriFace3D {
    init(reading file: RFFile) {
        self = TriFace3D(a: .zero, b: .zero, c: .zero)
        file.read(as: TriFace3D.self, into: &self)
    }
}

extension Camera3D {
    init(reading file: RFFile) {
        self = Camera3D(position: .zero, rotation: .zero, fieldOfView: 0)
        file.read(as: Camera3D.self, into: &self)
    }
}
