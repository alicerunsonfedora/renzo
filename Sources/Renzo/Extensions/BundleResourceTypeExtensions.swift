//
//  BundleResourceTypeExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 05-02-2026.
//

import PDFoundation

/// A resource type that handles Renzo model files (`.pdmodel`).
public struct ModelResourceType: BundleResourceType {
    public var requiresFileExtension: Bool { true }
    public func subpath(name: String) -> String {
        "/Models/\(name).pdmodel"
    }
}

/// A resource type that handles Renzo scene files (`.pdscene`).
public struct SceneResourceType: BundleResourceType {
    public var requiresFileExtension: Bool { true }
    public func subpath(name: String) -> String {
        "/Scenes/\(name).pdscene"
    }
}

extension BundleResourceType where Self == ModelResourceType {
    /// The resource type associated with Renzo model files.
    public static var model: ModelResourceType { ModelResourceType() }
}

extension BundleResourceType where Self == SceneResourceType {
    /// The resource type associated with Renzo scene files.
    public static var scene: SceneResourceType { SceneResourceType() }
}
