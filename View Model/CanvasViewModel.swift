//
//  CanvasViewModel.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

import SwiftUI

class CanvasViewModel: ObservableObject, GameEngineDelegate {

    private let constants = CanvasViewModelConstants()
    let paletteObjects: [String] = Constants.paletteObjects
    let modelMap = ModelMap()

    @Published var gameObjects: [GameObject]
    @Published var motionObjects: [MotionObject]
    @Published var remainingAmmo: [MotionObject] = []
    @Published var captureObjects: [CaptureObject]
    @Published var selectedObject: String?

    @Published var isDeleteState = false
    @Published var isResizeState = false
    @Published var isRotateState = false
    @Published var isStartState = false
    @Published var isGameOver = false
    @Published var isWin = false

    @Published private(set) var shooterRotation: Double = .zero
    @Published var isShooting = false
    @Published var isDoneShooting = false
    @Published var isShowingCircle = true
    @Published var isAnimating = false
    @Published var isReload = false
    @Published var lineDistance: Double = 0.0
    @Published var ballPosition = Point(xCoord: 0.0, yCoord: 0.0)
    @Published var score = 0.0
    @Published var pathEndPointX = 0.0
    @Published var pathEndPointY = 0.0
    @Published var distanceDots = 15.0
    @Published var pathCount = 0
    @Published var isNavigationActive = false

    let maxAmmo = 10
    let shooterPosition = Point(xCoord: Constants.screenWidth / 2, yCoord: 75)
    let capturePosition = Point(xCoord: Constants.screenWidth / 2, yCoord: Constants.gameHeight - 100)
    let motionObject = Constants.motionObject
    let captureObject = Constants.captureObject

    var isDelegated = false
    @Published var gameEngine: GameEngine?
    private(set) var displayLink: CADisplayLink?

    @Published var elapsedTime: TimeInterval = 0
    let timerDuration: TimeInterval = 60
    var timer: Timer?

    init() {
        gameObjects = []
        motionObjects = []
        captureObjects = []
        initRemainingAmmo()
    }

    init(gameObjects: [GameObject]) {
        self.gameObjects = gameObjects
        motionObjects = []
        captureObjects = []
        initRemainingAmmo()
    }

    func start() {
        isStartState.toggle()
        initGameEngineAndDelegate()
        startTimer()
        AudioManager.shared.playGameAudio()
    }

    func initRemainingAmmo() {
        remainingAmmo = modelMap.createAmmoObject(maxAmmo: maxAmmo)
    }

    func addExtraAmmo() {
        remainingAmmo = modelMap.createAmmoObject(maxAmmo: remainingAmmo.count + 1)
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

    func addObject(_ point: Point, _ selectedObject: String) {
        let objectToInsert: GameObject = modelMap.getEntity(center: point,type: selectedObject,
                                                            halfWidth: Constants.defaultHalfWidth,
                                                            orientation: 0.0)
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

    func updateObjectWidth(index: Int, dragLocation: CGPoint) {
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()

        let finalWidth = object.scaleWidth(point: dragLocation)
        objectDeepCopy.changeHalfWidth(newHalfWidth: finalWidth)

        guard checkCanDrag(objectDeepCopy, index) else {
            return
        }
        object.changeHalfWidth(newHalfWidth: finalWidth)
        gameObjects[index] = object
    }

    func updateObjectOrientation(index: Int, dragLocation: CGPoint) {
        untoggleDelete()
        let object = gameObjects[index]
        let objectDeepCopy = object.makeDeepCopy()
        let angleInRadians = object.calcAngle(to: dragLocation)
        objectDeepCopy.changeOrientation(to: angleInRadians)

        guard checkCanDrag(objectDeepCopy, index) else {
            return
        }
        object.changeOrientation(to: angleInRadians)
        gameObjects[index] = object
    }

    func updatePathEndPoints() {
        pathEndPointX = shooterPosition.xCoord + getBallVector().horizontal * lineDistance
        pathEndPointY = shooterPosition.yCoord + getBallVector().vertical * lineDistance
    }

    func calcPathDots() {
        let deltaX = pathEndPointX - shooterPosition.xCoord
        let deltaY = pathEndPointY - shooterPosition.yCoord
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        let distanceBetweenDots = distanceDots
        pathCount = Int(distance / distanceBetweenDots)
    }

    func backgroundOnDragGesture(point: Point) {
        let axisVector = Vector(horizontal: 0, vertical: 1)
        let touchVector = Vector(horizontal: point.xCoord - Constants.screenWidth / 2, vertical: point.yCoord)
        let angleInRadians = axisVector.getAngleInRadians(with: touchVector)
        shooterRotation = angleInRadians
        firstObjectInSightDistance()
        updatePathEndPoints()
        calcPathDots()
    }
}

extension CanvasViewModel {
    func initGameEngineAndDelegate() {
        gameEngine?.stop()
        gameEngine = nil
        gameEngine = GameEngine(motionObjects: &motionObjects,
                                gameObjects: &gameObjects,
                                captureObjects: &captureObjects,
                                ammo: &remainingAmmo)
        gameEngine?.gameEngineDelegate = self
        isDelegated = true
    }

    func gameEngineDidUpdate() {
        filterMotionObjects()
        isShooting = !motionObjects.isEmpty
        filterCondition()
        calcScore()
        displayFinalStatus()
        objectWillChange.send()
    }

    func filterMotionObjects() {
        motionObjects = motionObjects.filter { !$0.isOutOfBounds }
        let containsAddObject = motionObjects.contains { $0.isAdd }
        remainingAmmo = remainingAmmo.filter { !$0.isOutOfBounds }
        motionObjects = motionObjects.filter { !$0.isAdd }
        guard containsAddObject else {
            return
        }
        isReload = true
        addExtraAmmo()
    }

    func filterCondition() {
        guard !isShooting else {
            return
        }
        gameObjects = gameObjects.filter { gameObject in
            if checkObstacle(gameObject) {
                return true
            } else {
                return gameObject.health > 0
            }
        }
        isDoneShooting = true
    }

    func checkObstacle(_ gameObject: GameObject) -> Bool {
        gameObject.name.contains(Constants.sharp) ||
        gameObject.name.contains(Constants.obstacle) ||
        gameObject.name.contains(Constants.pointed)
    }

    func isEmptyAmmo() -> Bool {
        remainingAmmo.isEmpty
    }

    func checkActiveObjects() -> Bool {
        gameObjects.contains { $0.name == Constants.actionObject }
    }

    func countActiveObjects() -> Int {
        gameObjects.filter { $0.name == Constants.actionObject }.count
    }

    func countObjects() -> Int {
        gameObjects.count
    }

    func countAmmo() -> Int {
        remainingAmmo.count
    }

    func displayFinalStatus() {
        guard isEmptyAmmo() || elapsedTime == 60 || !checkActiveObjects() else {
            return
        }
        stopTimer()
        toggleWinConditions()
        isGameOver = true
    }

    func toggleWinConditions() {
        isWin = !checkActiveObjects()
    }

    func getBallVector() -> Vector {
        let xComponent = cos(shooterRotation)
        let yComponent = sin(shooterRotation)
        return Vector(horizontal: -yComponent, vertical: xComponent)
    }

    func shootBall() {
        guard !isShooting, !isAnimating, !remainingAmmo.isEmpty else {
            return
        }
        isShooting = true
        isDoneShooting = false
        isShowingCircle = true
        let motionObject = MotionObject(center: shooterPosition, name: motionObject, velocity: getBallVector())
        motionObjects.append(motionObject)
        initGameEngineAndDelegate()
    }

    func initCaptureObject() {
        let captureObject = CaptureObject(center: capturePosition, name: captureObject)
        captureObjects.removeAll()
        captureObjects.append(captureObject)
        initGameEngineAndDelegate()
    }

    func removeAllObjects() {
        gameObjects.removeAll()
        motionObjects.removeAll()
        remainingAmmo.removeAll()
        captureObjects.removeAll()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            if self.elapsedTime < self.timerDuration {
                self.elapsedTime += 1
            } else {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isGameOver = true
    }

    func isGameObjectInLineOfSight(_ gameObject: GameObject) -> Bool {
        let range = gameObject.halfWidth
        let vector: Vector = getBallVector()
        let line = Line(start: shooterPosition, vector: vector)
        return line.isPointNearLine(point: gameObject.center, range: range * range)
    }

    func firstObjectInSightDistance() {
        var minDistance = Constants.screenHeight
        let origin: Point = shooterPosition
        for gameObject in gameObjects where isGameObjectInLineOfSight(gameObject) {
            let distance = sqrt(pow(gameObject.center.xCoord - origin.xCoord, 2) + pow(gameObject.center.yCoord - origin.yCoord, 2))
            if distance < minDistance {
                minDistance = distance
            }
        }
        lineDistance = minDistance
    }

    func calcScore() {
        score += modelMap.getTotalScore(for: gameObjects)
    }
}

extension CanvasViewModel {
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
}
