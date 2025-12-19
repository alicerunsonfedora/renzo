//
//  FileReadingUtils.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

enum FileReadingUtils {
    static func expectHeader(_ header: String, in file: inout File.FileHandle) -> Bool {
        expectText(header, bytes: 1, in: &file)
    }

    static func expectText(_ text: String, bytes: Int, in file: inout File.FileHandle) -> Bool {
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

    static func readString(bytes: Int, from file: inout File.FileHandle) -> String {
        let strPointer = UnsafeMutableRawPointer.allocate(
            byteCount: bytes, alignment: MemoryLayout<CChar>.alignment)
        do {
            _ = try file.read(buffer: strPointer, length: UInt32(bytes))
        } catch {
            return ""
        }

        let buffer = UnsafeBufferPointer<UInt8>(
            start: strPointer.assumingMemoryBound(to: UInt8.self), count: bytes)
        return String(decoding: buffer, as: Unicode.UTF8.self)
    }

    static func readPoint3D(from file: inout File.FileHandle) -> Point3D {
        var point = Point3D.zero
        _ = withUnsafeMutablePointer(to: &point) { ptr in
            try? file.read(buffer: ptr, length: UInt32(MemoryLayout<Point3D>.size))
        }
        return point
    }

    static func readUInt32(from file: inout File.FileHandle) -> UInt32 {
        var value = UInt32(0)
        _ = withUnsafeMutablePointer(to: &value) { ptr in
            try? file.read(buffer: ptr, length: UInt32(MemoryLayout<UInt32>.size))
        }
        return value
    }
}

// MARK: - Convenience Reading

extension UInt32 {
    init(reading file: inout File.FileHandle) {
        self = FileReadingUtils.readUInt32(from: &file)
    }
}

extension String {
    init(reading file: inout File.FileHandle, bytes: Int) {
        self = FileReadingUtils.readString(bytes: bytes, from: &file)
    }
}

extension Point3D {
    init(reading file: inout File.FileHandle) {
        self = FileReadingUtils.readPoint3D(from: &file)
    }
}
