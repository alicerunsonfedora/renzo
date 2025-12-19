//
//  Model3D.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

/// A representation of a model in three-dimensional space.
///
/// A model typically contains one or more faces that can be drawn onto the screen. They can be generated via code or
/// loaded from a MDL3D file.
///
/// To work with the model's faces, simply treat the model as a collection:
/// ```swift
/// for face in model {
///    drawFace(face)
/// }
/// ```
public struct Model3D {
    @usableFromInline
    var faces: [TriFace3D]

    /// Create a 3D model by listing its faces.
    /// - Parameter faces: The faces that make up the model.
    public init(faces: [TriFace3D]) {
        self.faces = faces
    }
}

extension Model3D: Transformable3D {
    public func transformedBy(_ transform: Transform3D) -> Self {
        Model3D(faces: faces.map({ $0.transformedBy(transform) }))
    }

    public mutating func transformBy(_ transform: Transform3D) {
        for index in faces.indices {
            faces[index].transformBy(transform)
        }
    }
}

extension Model3D: Equatable {
    public static func == (lhs: Model3D, rhs: Model3D) -> Bool {
        lhs.faces == rhs.faces
    }
}

extension Model3D: Collection {
    public typealias Element = TriFace3D
    public typealias Index = Array<TriFace3D>.Index

    public var startIndex: Index { faces.startIndex }
    public var endIndex: Index { faces.endIndex }

    public func index(after idx: Index) -> Index {
        faces.index(after: idx)
    }

    public subscript(position: Index) -> TriFace3D {
        return faces[position]
    }

    public var isEmpty: Bool {
        return faces.isEmpty
    }

    @inlinable
    public mutating func sort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        self.faces.sort(by: areInIncreasingOrder)
    }
}

public enum Model3DDecoderError: Error {
    case readerEmptyOrUnknownFile
    case readerHeaderMismatch
    case readerCorruptFile
}
