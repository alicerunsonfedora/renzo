//
//  SceneTrigger.swift
//  Renzo
//
//  Created by Marquis Kurt on 16-02-2026.
//

/// An enumeration of the frequencies at which a trigger can be executed.
///
/// This type alias is provided as a convenience to ``SceneTrigger/Frequency``.
public typealias TriggerFrequency = SceneTrigger.Frequency

/// An enumeration of the conditions in which a trigger can be executed.
///
/// This type alias is provided as a convenience to ``SceneTrigger/Condition``.
public typealias TriggerCondition = SceneTrigger.Condition

/// An enumeration of the actions that a trigger can perform.
///
/// This type alias is provided as a convenience to ``SceneTrigger/Action``.
public typealias TriggerAction = SceneTrigger.Action

/// A structure representing a trigger in a scene.
///
/// Triggers are used to perform actions within the world whenever an object interacts with it, such as by entering or
/// leaving it. Triggers are typically not drawn by scene renderers and use bounding boxes to define regions for
/// interactivity.
public struct SceneTrigger: Hashable, Sendable {
    /// An enumeration of the conditions in which a trigger can be executed.
    public enum Condition: UInt32, Sendable {
        /// The trigger will never execute.
        case never

        /// Execute the trigger when the player has entered the trigger.
        case playerEnter

        /// Execute the trigger when the player invokes the interact action inside a trigger.
        case playerInteract

        /// Execute the trigger then the player has exited the trigger.
        case playerExit
    }

    /// An enumeration of the frequencies at which a trigger can be executed.
    public enum Frequency: UInt32, Sendable {
        /// The trigger only executes a single time.
        case once

        /// The trigger will always execute.
        case always
    }

    /// An enumeration of the actions that a trigger can perform.
    public enum Action: Hashable, Sendable, Equatable {
        /// The trigger performs an internal debugging action.
        case debugging

        /// The trigger requests to save the game's current state to disk.
        case autosave

        /// The trigger changes the active camera in the scene.
        case cameraSelect(Int)
    }

    public var region: Box3D
    public var actions: [Action]
    public var condition: Condition
    public var frequency: Frequency = .once

    public init(
        _ frequency: Frequency = .once,
        on condition: Condition,
        in region: Box3D,
        perform actions: [Action]
    ) {
        self.condition = condition
        self.region = region
        self.frequency = frequency
        self.actions = actions
    }
}
