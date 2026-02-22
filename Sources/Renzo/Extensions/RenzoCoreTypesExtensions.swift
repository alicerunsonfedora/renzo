//
//  RenzoCoreTypesExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDGraphics
import PlaydateKit

extension Point2D {
    public init(_ pdkPoint: PlaydateKit.Point) {
        self.init(x: pdkPoint.x, y: pdkPoint.y)
    }
}

extension PlaydateKit.Point {
    public init(_ point2D: Point2D) {
        self.init(x: point2D.x, y: point2D.y)
    }
}

extension PGTriangle {
    public init(_ triFace2D: TriFace2D) {
        self.init(a: Point(triFace2D.pointA), b: Point(triFace2D.pointB), c: Point(triFace2D.pointC))
    }
}

extension TriFace2D {
    public init(_ pgTriangle: PGTriangle) {
        self.init(a: Point2D(pgTriangle.pointA), b: Point2D(pgTriangle.pointB), c: Point2D(pgTriangle.pointC))
    }
}

extension Rect {
    public init(_ box2D: Box2D) {
        self.init(origin: Point(box2D.origin), width: box2D.size.width, height: box2D.size.height)
    }
}

extension Box2D {
    public init(_ rect: Rect) {
        self.init(origin: Point2D(rect.origin), size: Size2D(width: rect.width, height: rect.height))
    }
}
