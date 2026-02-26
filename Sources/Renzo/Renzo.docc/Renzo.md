# ``Renzo``

@Metadata {
    @PageColor(red)
    @PageImage(purpose: icon, source: "Renzo", alt: "The Renzo framework logo")
    @Available("Playdate", introduced: "3.0.1")
    @Available("macOS", introduced: "14.0")
    @Available("iOS", introduced: "17.0")
    @Available("iPadOS", introduced: "17.0")
}

Create and display 3D content in your Playdate app or game.

## Overview

With Renzo, you can display and interact with three-dimensional
content in your Playdate app or game. Load scenes and models from files or
generated structures, and render them with various projection mechanisms.
Renzo also sports cross-platform capabilities through RenzoCore, letting
you display your models and scenes with other frameworks such as
RealityKit. Renzo also provides a companion extension for Blender that
allows you to create models and scenes designed for Renzo easily.

> Warning: Renzo is in a pre-release state. Features, capabilities, and API
> design are not finalized. Use at your own risk!

### Use cases

Renzo is designed for 3D content that relies on static camera shots,
similar to games such as _Alone in the Dark_, early _Resident Evil_ titles,
and _Lorelei and the Laser Eyes_. However, Renzo is capable of displaying
general 3D models and very basic use cases.
