//
//  Model3DDecoderError.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// An enumeration of the errors that can occur when reading a binary file.
public enum RenzoBinaryFileReadError: Error {
    /// The file is either empty or of an unknown type.
    case readerEmptyOrUnknownFile

    /// The file header didn't match the expected one.
    case readerHeaderMismatch

    /// The file is corrupt and couldn't be read.
    case readerCorruptFile
}
