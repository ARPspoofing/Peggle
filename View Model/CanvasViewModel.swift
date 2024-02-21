//
//  CanvasViewModel.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

import SwiftUI

class CanvasViewModel: ObservableObject, GameEngineDelegate {

    private let constants = CanvasViewModelConstants()

    @Published var gameObjects: [GameObject]
    @Published var motionObjects: [MotionObject]
    @Published var captureObjects: [CaptureObject]
    @Published var selectedObject: String?
    @Published var isDeleteState = false
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

    let paletteObjects: [String] = [Constants.normalObject, Constants.actionObject]

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

    func render(_ location: CGPoint, _ selectedObject: String) {
        addObject(Point(xCoord: location.x, yCoord: location.y), selectedObject)
    }

    func removeAndRender(removeObjectIndex index: Int) {
        gameObjects.remove(at: index)
    }

    func removeActiveAndRender() {
        gameObjects = gameObjects.filter { !$0.isActive }
    }

    func checkIndexPeg(index: Int) -> Peg? {
        guard index >= 0, index < gameObjects.count else {
            return nil
        }
        guard let peg = gameObjects[index] as? Peg else {
            return nil
        }
        return peg
    }

    func checkCanInsert(_ newObject: GameObject) -> Bool {
        guard let newPeg = newObject as? Peg, newPeg.checkBorders() else {
            return false
        }
        for object in gameObjects {
            guard let pegObject = object as? Peg else {
                continue
            }
            guard newPeg.checkSafeToInsert(with: pegObject) else {
                return false
            }
        }
        return true
    }

    func checkCanDrag(_ newObject: GameObject, _ index: Int) -> Bool {
        guard let newPeg = newObject as? Peg, newPeg.checkBorders() else {
            return false
        }
        for (currentIndex, object) in gameObjects.enumerated() {
            guard currentIndex != index, let existingPeg = object as? Peg else {
                continue
            }
            guard newPeg.checkSafeToInsert(with: existingPeg) else {
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

    func addObject(_ point: Point, _ selectedObject: String) {
        let objectToInsert: GameObject = Peg(center: point, name: selectedObject)
        guard checkCanInsert(objectToInsert) else {
            return
        }
        gameObjects.append(objectToInsert)
    }

    func updateObjectPosition(index: Int, dragLocation: CGPoint) {
        untoggleDelete()
        guard let peg = checkIndexPeg(index: index) else {
            return
        }
        let pegDeepCopy: Peg = peg.makeDeepCopy()
        let newPoint = Point(xCoord: dragLocation.x, yCoord: dragLocation.y)
        pegDeepCopy.changeCenter(newCenter: newPoint)

        guard checkCanDrag(pegDeepCopy, index) else {
            return
        }
        peg.changeCenter(newCenter: newPoint)
        gameObjects[index] = peg
    }

    func backgroundOnDragGesture(point: Point) {
        let axisVector = Vector(horizontal: 0, vertical: 1)
        let touchVector = Vector(horizontal: point.xCoord - Constants.screenWidth / 2, vertical: point.yCoord)
        let angleInRadians = axisVector.getAngleInRadians(with: touchVector)
        shooterRotation = angleInRadians
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
        var captureObject = captureObjects.first
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
        /*
        isShooting = true
        isDoneShooting = false
        isShowingCircle = true
        let center = shooterPosition
        let velocity = speedUpVelocity(factor: speedUpFactor, vector: getBallVector())
        let motionObject = MotionObject(center: center, name: motionObjectName, velocity: velocity)
        self.motionObjects.append(motionObject)
        */
        initGameEngineAndDelegate()
    }

    func initCaptureObject() {
        let velocity = Vector(horizontal: 3, vertical: 0)
        let captureObject = CaptureObject(center:
                                            Point(xCoord: Constants.screenWidth / 2,
                                                        yCoord: Constants.screenHeight - 100), name: "capture object", velocity: velocity)
        self.captureObjects.removeAll()
        self.captureObjects.append(captureObject)
        //initGameEngineAndDelegate()
    }
}
