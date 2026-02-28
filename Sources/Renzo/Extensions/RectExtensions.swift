//
//  RectExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit
import RenzoCore

let displayWidth = Float(Display.width)
let displayHeight = Float(Display.height)

extension Rect {
    public static var display: Rect {
        Rect(origin: .zero, width: displayWidth, height: displayHeight)
    }
}

extension Box2D {
    public static var display: Box2D {
        Box2D(origin: .zero, size: Size2D(width: displayWidth, height: displayHeight))
    }
}
