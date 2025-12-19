//
//  DefaultStringInterpolation.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

#if swift(<6.3)
    extension DefaultStringInterpolation {
        public mutating func appendInterpolation(_ value: Float, precision: Int = 2) {
            if value.isNaN {
                appendLiteral("NaN")
                return
            }

            if value.isInfinite {
                appendLiteral(value.sign == .minus ? "-infinity" : "infinity")
                return
            }

            let sign = value < 0 ? "-" : ""
            let absVal = Swift.abs(value)
            let integerPart = Int(absVal)
            var multiplier: Float = 1
            for _ in 0..<precision { multiplier *= 10 }
            let fracPart = Int((absVal - Float(integerPart)) * multiplier + 0.5)
            let fracString = String(fracPart)
            let paddedFrac =
                String(repeating: "0", count: max(0, precision - fracString.utf8.count))
                + fracString
            appendLiteral("\(sign)\(integerPart).\(paddedFrac)")
        }
    }
#endif
