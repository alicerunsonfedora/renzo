//
//  PlaydateFileExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 27-01-2026.
//

import PlaydateKit

/// A typealias pointing to a Playdate file handle.
public typealias RFFile = File.FileHandle

extension RFFile {
    @discardableResult
    fileprivate func readOrSilentlyFail<T>(buffer: UnsafeMutablePointer<T>, length: CUnsignedInt) -> Int {
        do {
            return try self.read(buffer: buffer, length: length)
        } catch {
            RFReportError("Failed to read bytes as type '\(T.self)': \(error.description).")
            return -1
        }
    }
}

extension File {
    /// Returns whether a file exists at the specified path and has a non-zero amount of bytes.
    public static func fileExists(at path: String) -> Bool {
        do {
            let stat = try File.stat(path: path)
            return stat.size > 0
        } catch {
            return false
        }
    }
}

extension RFFile {
    /// Reads the next set of bytes and casts it to the specified type.
    /// - Parameter decodedType: The type to cast the bytes into.
    /// - Parameter value: The value to write the data into.
    public func read<T>(as decodedType: T.Type, into value: inout T) {
        withUnsafeMutablePointer(to: &value) { ptr in
            _ = self.readOrSilentlyFail(buffer: ptr, length: UInt32(MemoryLayout<T>.size))
        }
    }

    /// Reads the next specified number of bytes as a String.
    /// - Parameter length: The number of bytes to interpret as a string.
    public func readString(ofLength bytes: Int) -> String {
        let strPointer = UnsafeMutableRawPointer.allocate(
            byteCount: bytes, alignment: MemoryLayout<CChar>.alignment)
        do {
            _ = try self.read(buffer: strPointer, length: UInt32(bytes))
        } catch {
            return ""
        }
        let buffer = UnsafeBufferPointer<UInt8>(
            start: strPointer.assumingMemoryBound(to: UInt8.self), count: bytes)
        return String(decoding: buffer, as: Unicode.UTF8.self)
    }
}

extension String {
    public init(reading file: RFFile, ofLength length: Int) {
        self = file.readString(ofLength: length)
    }
}

extension Character {
    public init?(reading file: RFFile) {
        let text = file.readString(ofLength: 1)
        guard let char = text.first else { return nil }
        self = char
    }
}

extension FixedWidthInteger {
    public init(reading file: RFFile) {
        self = .min
        file.read(as: Self.self, into: &self)
    }
}

extension FloatingPoint {
    public init(reading file: RFFile) {
        self = .nan
        file.read(as: Self.self, into: &self)
    }
}

extension Bool {
    public init(reading file: RFFile) {
        self = false
        file.read(as: Bool.self, into: &self)
    }
}
