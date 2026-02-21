//
//  TriggerHandleDelegate.swift
//  Renzo
//
//  Created by Marquis Kurt on 21-02-2026.
//

/// A delegate that communicates with a trigger handler.
public protocol TriggerHandlerDelegate: AnyObject {
    /// Informs the trigger handler that the interaction key has been received.
    func triggerHasReceivedInteraction() -> Bool

    /// Tells the delegate to perform the action requested.
    func trigger(invoke action: TriggerAction)
}
