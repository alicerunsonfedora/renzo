# Create models and scenes using Blender

Export your Blender models and scenes to Renzo-compatible file types with
the Renzo Utilities Blender add-on.

@Metadata {
    @CallToAction(
      url: "https://source.marquiskurt.net/PDUniverse/renzoutils/archive/main.zip",
      purpose: download,
      label: "Download add-on")
}

## Overview

@Row(numberOfColumns: 5) {
    @Column(size: 3) {
        Renzo offers a companion add-on for [Blender](https://blender.org)
        that allows developers to export their models and scenes to
        Playdate model and Playdate scene files more easily.
        
        This add-on supports Blender 4.2 LTS and later.
        
        > Important: The Renzo Utilities add-on is currently a work in
        > progress and is not considered production-ready. Use at your own
        > risk!
    }

    @Column(size: 2) {
        @Image(source: "BlenderAddon", alt: "A screenshot of Blender")
    }
}

### Installing the add-on

To install the Renzo Utilities add-on, do the following:
1. Download the [latest release from SkyVault](https://source.marquiskurt.net/PDUniverse/renzoutils).
2. In Blender, drag the ZIP file into the editor and follow the prompts to
   install the add-on.

## Exporting content

To export a model, do the following:

1. Select the model you'd like to export in the view layer.
2. In the viewport's menu bar, Go to
   **Renzo Utilities &rsaquo; Export Model for Playdate**.
3. Select the location where you'd like to export the model to. In this
   view, you can also select options for triangulating the faces ahead of
   time and deleting any temporary copies.

### Exporting scenes

To export a scene, do the following:

1. In Blender's menu bar, go to **File &rsaquo; Export &rsaquo; Playdate Scene (.pdscene)**.
2. Select the location where you'd like to export the scene to.
