//
//  CanvasViewModelObserver.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 2/3/24.
//

import Foundation

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
        AudioManager.shared.playCannonAudio()
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
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
            let distance = sqrt(pow(gameObject.center.xCoord -
                                    origin.xCoord, 2) +
                                pow(gameObject.center.yCoord - origin.yCoord, 2))
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
