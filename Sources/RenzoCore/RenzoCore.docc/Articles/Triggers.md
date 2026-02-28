# Add interactivity with triggers

Use scene triggers to provide interactive experiences in scenes.

## Overview

@Row(numberOfColumns: 5) {
    @Column(size: 3) {
        Scene triggers allow for interactivity in an environment. Triggers
        are represented as invisible axis-aligned bounding boxes that,
        based on conditions you set, perform a set of pre-defined actions.
        For example, you can set a trigger that changes the active camera
        in a scene when a player enters the region.
    }
    @Column(size: 2) {
        @Image(source: "TriggersShowcase", alt: "A demonstration of a camera trigger")
        A demonstration of a camera trigger.
    }
}

A scene trigger can be constructed with the
``SceneTrigger/init(_:on:in:perform:)`` initializer:

```swift
let myRegion: Box3D = ...

let myTrigger = SceneTrigger(
    on: .playerEnter,
    in: myRegion,
    perform: [.debug])
```

Triggers can also be read from a scene file, and they are stored in the
``Scene3D/triggers`` property.

### Types of triggers

Triggers can be executed on a specified condition:

- When a player enters the trigger region
- When a player is actively in the trigger region and interacts
- When a player leaves the trigger region

Likewise, some triggers can be _retriggered_ based on a specified
condition or always retriggers. By default, triggers are assumed to be
one-offs and only executes once. Refer to the ``TriggerFrequency``
enumeration for all the cases in which a trigger can be retriggered.

Triggers typically execute one or more actions, in which each action is
defined in the ``TriggerAction`` enumeration. Implementation of some
actions may vary (see <doc:Triggers#Listening-to-handler-events>).

## Handling scene triggers

The ``SceneTriggerHandler`` class allows you to easily handle all the
triggers in a scene, checking state management and delegating operations
for you, including checking player collisions with the trigger's bounding
regions.

```swift
class TriggerResponder: TriggerHandlerDelegate { ... }

let player: ScenePlayer = ...
let myScene: Scene3D = ...
let myResponder = TriggerResponder()

let handler = SceneTriggerHandler(triggers: myScene.triggers)
handler.delegate = myResponder
handler.player = player

// In game loop
handler.processTriggers()
```

> Important: To ensure that triggers are processed in your game loop, call
> ``SceneTriggerHandler/processTriggers()`` in your update cycle.

When ``SceneTriggerHandler/processTriggers()`` is called, it will scan
through all the triggers, perform any collision checks, update internal
states for trigger conditions, and execute the specified actions based on
the condition and frequency of a trigger.

### Listening to handler events

To listen for events from the handler, provide a class that conforms to
the ``TriggerHandlerDelegate`` protocol as the
``SceneTriggerHandler/delegate``:

```swift
class MyResponder: TriggerHandlerDelegate {
    func triggerHasReceivedInteraction() -> Bool {
        let (_, _, released) = System.buttonState
        return released.contains(.a)
    }

    func trigger(invoke action: TriggerAction) {
        switch action { ... }
    }
}
```

- ``TriggerHandlerDelegate/triggerHasReceivedInteraction()`` determines
  whether the player has performed some interaction, typically by pressing
  a button on the Playdate. This method is used to check for the
  ``SceneTrigger/Condition/playerInteract`` condition.
- ``TriggerHandlerDelegate/trigger(invoke:)`` provides the implementation
  for a trigger action. When the handler attempts to perform the actions
  in a trigger, it calls this method.
  
> Important: If you intend to handle player-based trigger conditions such
> as when a player enter or exits a trigger, be sure to set the
> ``SceneTriggerHandler/player`` property on the trigger handler.  

## Topics

### Reading triggers

- ``SceneTrigger``
- ``TriggerAction``
- ``TriggerCondition``
- ``TriggerFrequency``

### Handling triggers

- ``SceneTriggerHandler``
- ``TriggerHandlerDelegate``
