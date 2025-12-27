//
//  Bundle.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

/// An object that represents a game's bundle.
public class Bundle {
    public enum ResourceType {
        case model
        case scene
    }

    var resourcesBase: String

    /// Create a game bundle relative to a given path.
    /// - Parameter path: The relative path of the bundle.
    public init(path: String? = nil) {
        if let path {
            resourcesBase = "\(path)/Resources"
        } else {
            resourcesBase = "Resources"
        }
    }

    /// Retrieve the file system path for a given resource.
    /// - Parameter resource: The name of the resource to locate.
    /// - Parameter resourceType: The type of resource to locate.
    public func path(forResource resource: String, ofType resourceType: ResourceType) -> String? {
        switch resourceType {
        case .model:
            let resPath = resourcesBase + "/Models/\(resource).model"
            guard let stat = try? File.stat(path: resPath), stat.size > 0 else {
                return nil
            }
            return resPath
        case .scene:
            let resPath = resourcesBase + "/Scenes/\(resource).pdscene"
            guard let stat = try? File.stat(path: resPath), stat.size > 0 else {
                return nil
            }
            return resPath
        }
    }
}

extension Bundle {
    public static var main: Bundle { Bundle() }
}
