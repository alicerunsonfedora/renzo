//
//  StringExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

extension String {
    static func == (lhs: String, rhs: String) -> Bool {
        lhs.utf8.elementsEqual(rhs.utf8)
    }

    static func != (lhs: String, rhs: String) -> Bool {
        !lhs.utf8.elementsEqual(rhs.utf8)
    }
}