//
//  Model3DDecoderError.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

public enum Model3DDecoderError: Error {
    case readerEmptyOrUnknownFile
    case readerHeaderMismatch
    case readerCorruptFile
}
