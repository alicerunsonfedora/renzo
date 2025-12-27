//
//  RectExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

extension Rect {
    public static var display: Rect {
        Rect(origin: .zero, width: Float(Display.width), height: Float(Display.height))
    }
}
