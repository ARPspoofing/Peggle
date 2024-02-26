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
    let paletteObjects: [String] = [Constants.normalObject, Constants.actionObject, Constants.sharpObject]
    let modelMap = ModelMap()

    @Published var gameObjects: [GameObject]
    @Published var motionObjects: [MotionObject]
    @Published var remainingAmmo: [MotionObject] = []
    @Published var captureObjects: [CaptureObject]
    @Published var selectedObject: String?
    @Published var remainingAmmoCount: Int = 10

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
    let capturePosition = Point(xCoord: Constants.screenWidth / 2, yCoord: Constants.gameHeight - 50)
    let motionObject = Constants.motionObject
    let captureObject = Constants.captureObject

    let initialWidth: Double = 25.0
    let maxWidth: Double = 50.0
    let minDistance: Double = 0.0
    let maxDistance: Double = 200.0

    var isDelegated = false
    @Published var gameEngine: GameEngine?
    private(set) var displayLink: CADisplayLink?

    init() {
        self.gameObjects = []
        self.motionObjects = []
        self.captureObjects = []
        initRemainingAmmo()
    }

    init(gameObjects: [GameObject]) {
        self.gameObjects = gameObjects
        self.motionObjects = []
        self.captureObjects = []
        initRemainingAmmo()
    }

    func start() {
        isStartState.toggle()
        initGameEngineAndDelegate()
    }

    func unselectObjects() {
        selectedObject = nil
    }

    func unselectStateButtons() {
        isDeleteState = false
        isRotateState = false
        isResizeState = false
    }

    func untoggleDelete() {
        guard !isDeleteState else {
            isDeleteState.toggle()
            return
        }
    }

    func untoggleResize() {
        guard !isResizeState else {
            isResizeState.toggle()
            return
        }
    }

    func untoggleRotate() {
        guard !isRotateState else {
            isRotateState.toggle()
            return
        }
    }

    func toggleDeleteState() {
        unselectObjects()
        isResizeState = false
        isRotateState = false
        isDeleteState.toggle()
    }

    func toggleResizeState() {
        unselectObjects()
        isDeleteState = false
        isRotateState = false
        isResizeState.toggle()
    }

    func toggleRotateState() {
        unselectObjects()
        isDeleteState = false
        isResizeState = false
        isRotateState.toggle()
    }

    // TODO: Make it neater
    func initRemainingAmmo() {
        for idx in 1...10 {
            // TODO: Place in mapping
            var object = MotionObject(center: Point(xCoord: 50, yCoord: Constants.screenHeight - (Double(idx) * 50)), name: "motion", velocity: Vector(horizontal: 0.0, vertical: 8.0))
            remainingAmmo.append(object)
        }
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
        unselectStateButtons()
        if tappedObject == selectedObject {
            selectedObject = nil
        } else {
            selectedObject = tappedObject
        }
    }

    // TODO: Allow dynamic half width
    func addObject(_ point: Point, _ selectedObject: String) {
        let objectToInsert: GameObject = modelMap.getEntity(center: point, type: selectedObject, halfWidth: Constants.defaultHalfWidth, orientation: 0.0)
            guard checkCanInsert(objectToInsert) else {
                return
            }
            // TODO: Make mapping for selectedObject to powerup
        /*
        if selectedObject == "actionObject" {
            objectToInsert.isBlast = true
        }
        */
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

    func calcDistance(center: Point, point: CGPoint) -> Double {
        let newPoint = Point(xCoord: point.x, yCoord: point.y)
        let deltaX = newPoint.xCoord - center.xCoord
        let deltaY = newPoint.yCoord - center.yCoord
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }

    func scaleWidth(center: Point, point: CGPoint) -> Double {
        let distance = calcDistance(center: center, point: point)
        let distanceRange = maxDistance - minDistance
        let widthRange = maxWidth - initialWidth
        let normalizedDistance = (distance - minDistance) / distanceRange
        let scaledWidth = initialWidth + widthRange * normalizedDistance
        return min(scaledWidth, maxWidth)
    }

    func updateObjectWidth(index: Int, dragLocation: CGPoint) {
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()

        let finalWidth = scaleWidth(center: object.center, point: dragLocation)
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

    func calcAngle(from center: Point, to point: CGPoint) -> Double {
        let newPoint = Point(xCoord: point.x, yCoord: point.y)
        let axisVector = Vector(horizontal: center.xCoord, vertical: center.yCoord)
        let touchVector = Vector(horizontal: newPoint.xCoord - center.xCoord,
                                 vertical: newPoint.yCoord - center.yCoord)
        return axisVector.getAngleInRadians(with: touchVector)
    }

    func updateObjectOrientation(index: Int, dragLocation: CGPoint) {
        untoggleDelete()
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()
        let angleInRadians = calcAngle(from: object.center, to: dragLocation)
        objectDeepCopy.changeOrientation(to: angleInRadians)

        guard checkCanDrag(objectDeepCopy, index) else {
            return
        }
        object.changeOrientation(to: angleInRadians)
        gameObjects[index] = object
    }
}

// TODO: Make this neater (isShooting, isDoneShooting, showingCircle)
extension CanvasViewModel {
    func initGameEngineAndDelegate() {
        self.gameEngine?.stop()
        self.gameEngine = nil
        self.gameEngine = GameEngine(motionObjects: &self.motionObjects,
                                     gameObjects: &self.gameObjects,
                                     captureObjects: &self.captureObjects,
                                     ammo: &self.remainingAmmo)
        self.gameEngine?.gameEngineDelegate = self
        isDelegated = true
    }

    func gameEngineDidUpdate() {
        motionObjects = motionObjects.filter { !$0.isOutOfBounds }
        remainingAmmo = remainingAmmo.filter { !$0.isOutOfBounds }
        isShooting = !motionObjects.isEmpty
        if !isShooting {
            self.gameObjects = self.gameObjects.filter { !$0.isActive }
            isDoneShooting = true
        }
        objectWillChange.send()
    }

    func getBallVector() -> Vector {
        let xComponent = cos(shooterRotation)
        let yComponent = sin(shooterRotation)
        return Vector(horizontal: -yComponent, vertical: xComponent)
    }

    func shootBall() {
        guard !isShooting, !isAnimating, remainingAmmoCount > 0 else {
            return
        }
        isShooting = true
        isDoneShooting = false
        isShowingCircle = true
        let motionObject = MotionObject(center: shooterPosition, name: motionObject, velocity: getBallVector())
        self.motionObjects.append(motionObject)
        initGameEngineAndDelegate()
    }

    func initCaptureObject() {
        let captureObject = CaptureObject(center: capturePosition, name: captureObject)
        self.captureObjects.removeAll()
        self.captureObjects.append(captureObject)
        initGameEngineAndDelegate()
    }
}
