//
//  SceneTriggerHandler.swift
//  Renzo
//
//  Created by Marquis Kurt on 21-02-2026.
//

private struct TriggerState {
    enum PlayerPosition {
        case entered, inside, exited
    }

    var playerPosition: PlayerPosition?
    var hasActivatedOnce = false
}

/// An object responsible for handling triggers in a scene.
public final class SceneTriggerHandler {
    /// The scene player that the trigger handler will track.
    public var player: ScenePlayer?

    /// The delegate communicating with the trigger handler.
    public var delegate: (any TriggerHandlerDelegate)?

    /// The triggers the handler will govern.
    public var triggers: [SceneTrigger] {
        didSet { states.removeAll() }
    }

    private var states = [SceneTrigger: TriggerState]()

    public init(triggers: [SceneTrigger]) {
        self.triggers = triggers
    }

    /// Processes all the triggers in the current handler.
    public func processTriggers() {
        for trigger in triggers {
            process(trigger)
        }
    }

    func process(_ trigger: SceneTrigger) {
        guard var state = states[trigger] else { return }
        updateState(&state, playerInRegion: trigger.region.contains(point: player?.position ?? .zero))
        guard triggerCanExecute(trigger, with: &state) else {
            states[trigger] = state
            return
        }

        for action in trigger.actions {
            self.delegate?.trigger(invoke: action)
        }
        states[trigger] = state
    }

    private func updateState(_ state: inout TriggerState, playerInRegion: Bool) {
        switch state.playerPosition {
        case .entered:
            state.playerPosition = playerInRegion ? .inside : .exited
        case .inside:
            if !playerInRegion {
                state.playerPosition = .exited
            }
        default:
            if playerInRegion {
                state.playerPosition = .entered
            }
        }
    }

    private func triggerCanExecute(_ trigger: SceneTrigger, with state: inout TriggerState) -> Bool {
        switch trigger.condition {
        case .never:
            return false
        case .playerEnter:
            return state.playerPosition == .entered
        case .playerInteract:
            if state.playerPosition != .inside { return false }
            if trigger.frequency == .once, state.hasActivatedOnce { return false }
            if delegate?.triggerHasReceivedInteraction() != true { return false }
            state.hasActivatedOnce = true
            return true
        case .playerExit:
            return state.playerPosition == .exited
        }
    }

    deinit {
        delegate = nil
    }
}
