//
//  CanvasViewModel.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

import SwiftUI

// TODO: Massive tidy up

class CanvasViewModel: ObservableObject, GameEngineDelegate {

    private let constants = CanvasViewModelConstants()

    @Published var gameObjects: [GameObject]
    @Published var motionObjects: [MotionObject]
    @Published var captureObjects: [CaptureObject]
    @Published var selectedObject: String?
    @Published var isDeleteState = false
    @Published var isResizeState = false
    @Published var isRotateState = false
    @Published var isStartState = false
    @Published private(set) var shooterRotation: Double = .zero
    @Published var isShooting = false
    @Published var isDoneShooting = false
    @Published var isShowingCircle = true
    @Published var isAnimating = false
    @Published var ballPosition = Point(xCoord: 0.0, yCoord: 0.0)
    let shooterPosition = Point(xCoord: Constants.screenWidth / 2, yCoord: 75)
    let speedUpFactor = 10.0
    let motionObjectName = Constants.motionObject

    var isDelegated = false

    @Published var gameEngine: GameEngine?
    private(set) var displayLink: CADisplayLink?

    let paletteObjects: [String] = [Constants.normalObject, Constants.actionObject, Constants.sharpObject]
    let modelMap = ModelMap()

    init() {
        self.gameObjects = []
        self.motionObjects = []
        self.captureObjects = []
    }

    init(gameObjects: [GameObject]) {
        self.gameObjects = gameObjects
        self.motionObjects = []
        self.captureObjects = []
    }

    func start() {
        isStartState.toggle()
        initGameEngineAndDelegate()
    }

    func untoggleDelete() {
        guard !isDeleteState else {
            isDeleteState.toggle()
            return
        }
    }

    func toggleDeleteState() {
        selectedObject = nil
        isDeleteState.toggle()
    }

    func untoggleResize() {
        guard !isResizeState else {
            isResizeState.toggle()
            return
        }
    }

    func toggleResizeState() {
        selectedObject = nil
        isResizeState.toggle()
    }

    func untoggleRotate() {
        guard !isRotateState else {
            isRotateState.toggle()
            return
        }
    }

    func toggleRotateState() {
        selectedObject = nil
        isRotateState.toggle()
    }

    func render(_ location: CGPoint, _ selectedObject: String) {
        addObject(Point(xCoord: location.x, yCoord: location.y), selectedObject)
    }

    func removeAndRender(removeObjectIndex index: Int) {
        gameObjects.remove(at: index)
    }

    func removeActiveAndRender() {
        gameObjects = gameObjects.filter { !$0.isActive }
    }

    func checkCanInsert(_ newObject: GameObject) -> Bool {
        guard newObject.checkBorders() else {
            return false
        }
        for object in gameObjects {
            guard newObject.checkSafeToInsert(with: object) else {
                return false
            }
        }
        return true
    }

    func checkCanDrag(_ newObject: GameObject, _ index: Int) -> Bool {
        guard newObject.checkBorders() else {
            return false
        }
        for (currentIndex, object) in gameObjects.enumerated() {
            guard currentIndex != index else {
                continue
            }
            guard newObject.checkSafeToInsert(with: object) else {
                return false
            }
        }
        return true
    }

    func tapObject(_ tappedObject: String) {
        isDeleteState = false
        if tappedObject == selectedObject {
            selectedObject = nil
        } else {
            selectedObject = tappedObject
        }
    }

    // TODO: Allow dynamic half width
    func addObject(_ point: Point, _ selectedObject: String) {
        let objectToInsert: GameObject = modelMap.getEntity(center: point, type: selectedObject, halfWidth: Constants.defaultHalfWidth)
            guard checkCanInsert(objectToInsert) else {
                return
            }
            gameObjects.append(objectToInsert)
    }

    func updateObjectPosition(index: Int, dragLocation: CGPoint) {
        untoggleDelete()
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()
        let newPoint = Point(xCoord: dragLocation.x, yCoord: dragLocation.y)
        objectDeepCopy.changeCenter(newCenter: newPoint)

        guard checkCanDrag(objectDeepCopy, index) else {
            return
        }
        object.changeCenter(newCenter: newPoint)
        gameObjects[index] = object
    }

    // TODO: Break up into smaller functions
    func updateObjectWidth(index: Int, dragLocation: CGPoint) {
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()
        let newPoint = Point(xCoord: dragLocation.x, yCoord: dragLocation.y)

        let deltaX = newPoint.xCoord - object.center.xCoord
        let deltaY = newPoint.yCoord - object.center.yCoord
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)

        let initialWidth: Double = 25.0
        let maxWidth: Double = 50.0

        let minDistance: Double = 0.0
        let maxDistance: Double = 200.0

        let scaledWidth = initialWidth + (maxWidth - initialWidth) * (distance - minDistance) / (maxDistance - minDistance)

        let finalWidth = min(scaledWidth, maxWidth)

        print("Scaled width:", finalWidth)

        objectDeepCopy.changeHalfWidth(newHalfWidth: finalWidth)

        guard checkCanDrag(objectDeepCopy, index) else {
            return
        }
        object.changeHalfWidth(newHalfWidth: finalWidth)
        gameObjects[index] = object
    }

    func backgroundOnDragGesture(point: Point) {
        let axisVector = Vector(horizontal: 0, vertical: 1)
        let touchVector = Vector(horizontal: point.xCoord - Constants.screenWidth / 2, vertical: point.yCoord)
        let angleInRadians = axisVector.getAngleInRadians(with: touchVector)
        shooterRotation = angleInRadians
    }

    func updateObjectOrientation(index: Int, dragLocation: CGPoint) {
        untoggleDelete()
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()
        let newPoint = Point(xCoord: dragLocation.x, yCoord: dragLocation.y)

        let axisVector = Vector(horizontal: object.retrieveXCoord(), vertical: object.retrieveYCoord())
        let touchVector = Vector(horizontal: newPoint.xCoord - object.retrieveXCoord(), vertical: newPoint.yCoord - object.retrieveYCoord())
        let angleInRadians = axisVector.getAngleInRadians(with: touchVector)

        objectDeepCopy.changeOrientation(to: angleInRadians)
        guard checkCanDrag(objectDeepCopy, index) else {
            return
        }
        object.changeOrientation(to: angleInRadians)
        gameObjects[index] = object
    }
}

extension CanvasViewModel {
    func initGameEngineAndDelegate() {
        self.gameEngine?.stop()
        self.gameEngine = nil
        self.gameEngine = GameEngine(motionObjects: &self.motionObjects,
                                         gameObjects: &self.gameObjects,
                                         captureObjects: &self.captureObjects)

            self.gameEngine?.gameEngineDelegate = self
            isDelegated = true
    }

    func gameEngineDidUpdate() {
        motionObjects = motionObjects.filter { !$0.isOutOfBounds }
        isShooting = !motionObjects.isEmpty
        if !isShooting {
            self.gameObjects = self.gameObjects.filter { !$0.isActive }
            isDoneShooting = true
        }
        let captureObject = captureObjects.first
        captureObjects.removeAll()
        guard let toAppend = captureObject else {
            return
        }
        captureObjects.append(toAppend)
        objectWillChange.send()
    }

    func getBallVector() -> Vector {
        let xComponent = cos(shooterRotation)
        let yComponent = sin(shooterRotation)
        return Vector(horizontal: -yComponent, vertical: xComponent)
    }

    func speedUpVelocity(factor: Double, vector: Vector) -> Vector {
        vector.scale(factor)
    }

    func shootBall() {
        guard !isShooting, !isAnimating else {
            return
        }
        isShooting = true
        isDoneShooting = false
        isShowingCircle = true
        let center = shooterPosition
        let velocity = speedUpVelocity(factor: speedUpFactor, vector: getBallVector())
        let motionObject = MotionObject(center: center, name: motionObjectName, velocity: velocity)
        self.motionObjects.append(motionObject)
        initGameEngineAndDelegate()
    }

    func initCaptureObject() {
        let velocity = Vector(horizontal: 5, vertical: 0)
        let captureObject = CaptureObject(center:
                                            Point(xCoord: Constants.screenWidth / 2,
                                                        yCoord: Constants.screenHeight - 100), name: "capture object", velocity: velocity)
        self.captureObjects.removeAll()
        self.captureObjects.append(captureObject)
        initGameEngineAndDelegate()
    }
}
