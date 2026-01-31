//
//  SceneRenderer.swift
//  Renzo
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PDFoundation
import PDGraphics
import PlaydateKit

/// A renderer capable of rendering three-dimensional scenes.
///
/// When a scene is rendered, it will take the frame dimensions into account, using the projection you specify. Any
/// model references that already have a data counterpart are displayed with backfaces culled, adding them as scene
/// objects. If a scene has any point lights present, models will be lit using a basic diffuse lighting algorithm.
///
/// ### Sorting
/// When the scene uses a ``PerspectiveProjection``, objects and faces can be sorted to ensure their Z order appears
/// correctly relative to the current camera in use. Scene objects and their model faces are sorted by distance from
/// the camera. By default, the scene will re-sort objects and faces whenever the ``currentCameraIndex`` changes; call
/// ``setNeedsFaceSorting()`` and/or ``setNeedsObjectSorting()``, respectively, to notify the scene to sort again. For
/// example, you may need to call ``setNeedsObjectSorting()`` if one of the scene objects continuously moves, like a
/// player model.
open class SceneRenderer {
    /// Whether the scene renderer should cull backfaces.
    public var allowsBackfaceCulling: Bool = true

    /// The frame to draw the contents of the scene into.
    public var frame: Rect {
        didSet { didChangeFrame() }
    }

    /// Whether the renderer needs to sort the model's faces relative to the current camera position.
    ///
    /// This can be enabled whenever the projection is a ``PerspectiveProjection`` through ``setNeedsFaceSorting()``.
    public private(set) var needsFaceSorting = false

    /// Whether the renderer needs to sort the objects in the scene relative to the current camera position.
    ///
    /// This can be enabled whenever the projection is a ``PerspectiveProjection`` through ``setNeedsObjectSorting()``.
    public private(set) var needsObjectSorting = false

    /// The projection used to project scene objects to screen space.
    public private(set) var projection: any Projection3D

    /// The three-dimensional scene that will be rendered.
    public var scene: Scene3D {
        didSet { didChangeScene() }
    }

    /// The current scene objects in the world.
    public internal(set) var sceneObjects: [SceneObject]

    /// Create a renderer for a scene with a given projection and frame.
    /// - Parameter scene: The scene the renderer will display.
    /// - Parameter projection: The projection that the renderer will use.
    /// - Parameter frame: The frame that the scene will be rendered in.
    public init(scene: Scene3D, projection: Projection3D, frame: Rect = .display) {
        self.scene = scene
        self.projection = projection
        self.frame = frame
        self.sceneObjects = []
        loadSceneObjectsFromScene()
    }

    /// Create a renderer for a scene in a given frame, relying on perspective projection.
    /// - Parameter scene: The scene the renderer will display.
    /// - Parameter frame: The frame that the scene will be rendered in.
    public init(scene: Scene3D, frame: Rect = .display) {
        self.scene = scene
        self.projection = PerspectiveProjection(camera: scene.cameras[0], rect: frame)
        self.frame = frame

        self.sceneObjects = []
        loadSceneObjectsFromScene()

        needsFaceSorting = true
        needsObjectSorting = true
    }

    /// Adds a child scene object to the scene.
    /// - Parameter sceneObject: The child to add to the current scene.
    /// - Parameter requiresSorting: Whether the scene should re-sort the objects when this object is added.
    public func addChild(_ sceneObject: SceneObject, requiresSorting: Bool = false) {
        sceneObjects.append(sceneObject)
        if requiresSorting {
            setNeedsObjectSorting()
        }
    }

    /// Draws a given model onto the screen using the specified transformation.
    ///
    /// In most cases, you won't need to override this behavior. However, this may be necessary under certain
    /// circumstances, such as to measure performance.
    ///
    /// - Parameter model: The model to render on the screen.
    /// - Parameter transform: The transformation to apply to the model before rendering it.
    /// - parameter frameBuffer: The frame buffer to draw the model's faces into.
    open func drawModel(_ model: Model3D, transformedBy transform: Transform3D, into frameBuffer: inout PGBuffer) {
        for face in model {
            let worldFace = face.transformedBy(transform)
            let projectedFace = projection.project(worldFace)
            if allowsBackfaceCulling, projectedFace.signedArea >= 0 {
                continue
            }

            let brightness = getBrightness(of: worldFace)
            let color = PGColor.dithered(by: brightness)
            PGFillTriangle(projectedFace, color: color, into: &frameBuffer)
        }
    }

    /// Gets the total brightness factor of a face based on the current scene's lighting.
    public func getBrightness(of face: TriFace3D) -> Float {
        var brightness: Float = 0
        for light in scene.lights {
            let lightOffset = (light - face.centroid).normalized()
            brightness += max(0, face.normal.normalized().dotProduct(with: lightOffset))
        }
        return brightness
    }

    /// Removes the child from the current scene.
    /// - Parameter sceneObject: The child to remove from the scene.
    public func removeChild(_ sceneObject: SceneObject) {
        sceneObjects.removeAll(where: { $0 == sceneObject })
    }

    /// Renders the scene as a 2D image.
    public func render() {
        guard var frameBuffer = Graphics.getFrame() else {
            PDReportError("Failed to get the frame buffer.")
            return
        }

        if needsObjectSorting {
            sortObjects()
        }

        for object in sceneObjects {
            if needsFaceSorting {
                sortFaces(of: &object.model)
            }
            drawModel(object.model, transformedBy: object.transformation, into: &frameBuffer)
        }
        needsFaceSorting = false
    }

    /// Sets the renderer's camera to a specified index in the scene's camera list.
    ///
    /// > Note: This method is only applicable to scene renderers whose ``projection`` property is a
    /// > ``PerspectiveProjection``.
    ///
    /// - Parameter index: The index of the camera to use.
    public func setCameraIfAvailable(_ index: [Camera3D].Index) {
        guard let projection = projection as? PerspectiveProjection,
            scene.cameras.indices.contains(index)
        else { return }
        projection.camera = scene.cameras[index]
        setNeedsFaceSorting()
        setNeedsObjectSorting()
    }

    /// Notify the scene view that the model's faces need to be sorted.
    public func setNeedsFaceSorting() {
        needsFaceSorting = true
    }

    /// Notify the scene view that the scene objects need to be sorted.
    public func setNeedsObjectSorting() {
        needsObjectSorting = true
    }

    // MARK: - Internal Mechanisms

    private func loadSceneObjectsFromScene() {
        for model in scene.models {
            do {
                let modelData = try Model3D(named: model.name)
                let child = SceneObject(
                    model: modelData,
                    worldPosition: model.position,
                    worldRotation: model.rotation,
                    worldScale: model.scale)
                sceneObjects.append(child)
            } catch {
                PDReportError("Failed to load model named '\(model.name)'.")
            }
        }
    }

    private func sortFaces(of model: inout Model3D) {
        guard let projection = projection as? PerspectiveProjection else {
            needsObjectSorting = false
            return
        }

        model.sort { [projection] faceA, faceB in
            let cameraPos = projection.camera.position
            let faceADist = faceA.centroid.squaredDistance(to: cameraPos)
            let faceBDist = faceB.centroid.squaredDistance(to: cameraPos)
            return faceADist > faceBDist
        }
        needsObjectSorting = false
    }

    private func sortObjects() {
        guard let projection = projection as? PerspectiveProjection else {
            return
        }

        sceneObjects.sort { modelA, modelB in
            let cameraPos = projection.camera.position
            let modelADist = modelA.worldPosition.squaredDistance(to: cameraPos)
            let modelBDist = modelB.worldPosition.squaredDistance(to: cameraPos)
            return modelADist > modelBDist
        }
    }

    // MARK: - Post Setters

    private func didChangeScene() {
        sceneObjects.removeAll()
        loadSceneObjectsFromScene()
        if let projection = projection as? PerspectiveProjection {
            projection.camera = scene.cameras[0]
        }
    }

    private func didChangeFrame() {
        if let projection = projection as? PerspectiveProjection {
            projection.frame = self.frame
        }
    }
}
