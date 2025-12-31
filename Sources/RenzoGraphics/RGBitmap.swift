///
//  RGBitmap.swift
//  Renzo
//
//  Created by Marquis Kurt on 29-12-2025.
//

/// A typealias representing a pattern of bits.
typealias BitPattern = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)

/// Retrieves the row for a specified 8x8 bit pattern.
/// - Parameter bitmap: The bit pattern to retrieve the current row for.
/// - Parameter row: The row to retrieve. Row should be between 0..<8.
func RGGetBitPatternRow(_ bitmap: BitPattern, row: Int) -> UInt8 {
    return switch row {
    case 1: bitmap.1
    case 2: bitmap.2
    case 3: bitmap.3
    case 4: bitmap.4
    case 5: bitmap.5
    case 6: bitmap.6
    case 7: bitmap.7
    default: bitmap.0
    }
}
