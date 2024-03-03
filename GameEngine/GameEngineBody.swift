//
//  GameEngineBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 9/2/24.
//

import SwiftUI

class GameEngineBody: GameEngineWorld, CollisionGameEngine, GravityGameEngine {

    private let screenWidth = Constants.screenWidth
    private let screenHeight = Constants.screenHeight
    private let exitThrsh = 10
    private var exitCount = 0
    private let topReappear: CGFloat = 150.0
    private let velMagnitude = 10.0
    internal let gravityVelocity = Vector(horizontal: 0.0, vertical: 0.5)
    internal let intersectThrsh = 10

    var activeIdx = 1

    private func handleSideBoundaries(_ object: inout MotionObject) {
        guard !object.checkLeftBorder() || !object.checkRightBorder() else {
            return
        }
        object.reverseHorizontalVelocity()
    }

    private func handleTopBoundary(_ object: inout MotionObject) {
        guard !object.checkTopBorder() else {
            return
        }
        object.reverseVerticalVelocity()
    }

    private func handleBottomBoundary(_ object: inout MotionObject) {
        guard !object.checkBottomBorderGame() else {
            return
        }
        guard object.isReappear else {
            object.isOutOfBounds = true
            return
        }
        resetToTop(&object)
    }

    private func resetToTop(_ object: inout MotionObject) {
        object.changeCenter(newCenter: Point(xCoord: object.retrieveXCoord(), yCoord: topReappear))
        object.resetVelocity(magnitude: velMagnitude)
    }

    private func handlePlaneBoundaries(_ object: inout MotionObject) {
        handleTopBoundary(&object)
        handleBottomBoundary(&object)
    }

    internal func handleObjectBoundaries(_ object: inout MotionObject) {
        handleSideBoundaries(&object)
        handlePlaneBoundaries(&object)
    }

    internal func handleCaptureObjectBoundaries(_ object: inout CaptureObject) {
        guard !object.checkLeftBorder() || !object.checkRightBorder() else {
            return
        }
        object.reverseHorizontalVelocity()
    }

    private func handleNoIntersection(for gameObject: inout GameObject, and object: inout MotionObject) {
        gameObject.isHandleOverlap = false
        gameObject.handleOverlapCount = 0
        gameObject.isDisappear = false
        object.isHandleOverlap = false
    }

    private func handleFirstIntersection(for gameObject: inout GameObject, and object: inout MotionObject) {
        handleCollision(motionObject: &object, gameObject: &gameObject)
        gameObject.isHandleOverlap = true
        object.isHandleOverlap = true
        guard gameObject is ReappearObject else {
            return
        }
        object.isReappear = true
        let capturedObject = object
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            capturedObject.isReappear = false
        }
    }

    private func subsequentIntersection(for gameObject: inout GameObject) {
        gameObject.handleOverlapCount += 1
        gameObject.isDisappear = false
    }

    private func thresholdIntersection(for gameObject: inout GameObject) {
        gameObject.isDisappear = true
    }

    func toggleActiveAndDisappear(for gameObject: inout GameObject) {
        gameObject.isActive = true
        guard gameObject.hasBlasted else {
            return
        }
        gameObject.isDisappear = true
        gameObject.handleOverlapCount = 10
    }

    internal func handleIntersection(for gameObject: inout GameObject, and object: inout MotionObject) {
        toggleActiveAndDisappear(for: &gameObject)
        if gameObject.handleOverlapCount < intersectThrsh {
            if !gameObject.isHandleOverlap {
                handleFirstIntersection(for: &gameObject, and: &object)
            }
            subsequentIntersection(for: &gameObject)
        } else if gameObject.handleOverlapCount == intersectThrsh {
            thresholdIntersection(for: &gameObject)
        }
    }

    private func handleOverlapGameObjects(motionObject object: inout MotionObject) {
        for gameObject in gameObjects {
            var mutatableGameObject = gameObject
            guard !object.checkNoIntersection(with: mutatableGameObject) else {
                handleNoIntersection(for: &mutatableGameObject, and: &object)
                continue
            }
            handleIntersection(for: &mutatableGameObject, and: &object)
        }
    }

    private func handleOverlapCaptureObjects(motionObject object: inout MotionObject) {
        for captureObject in captureObjects {
            var mutatableCaptureObject = captureObject
            guard !object.checkNoIntersection(with: mutatableCaptureObject) else {
                continue
            }
            if object.isReappear {
                AudioManager.shared.playSpookyAudio()
                handleBounce(for: &mutatableCaptureObject, and: &object)
            } else {
                object.isAdd = true
                AudioManager.shared.playAngelAudio()
            }
        }
    }

    private func isHandleOverlapObjects(motionObject object: inout MotionObject, isIntersect: inout Bool) {
        handleOverlapGameObjects(motionObject: &object)
        handleOverlapCaptureObjects(motionObject: &object)
    }

    private func checkAndResetOverlap(isIntersect: inout Bool) {
        for gameObject in gameObjects {
            gameObject.isHandleOverlap = false
        }
    }

    internal func handleObjectCollisions(_ object: inout MotionObject) {
        var isIntersect = false
        isHandleOverlapObjects(motionObject: &object, isIntersect: &isIntersect)
    }

    internal func toggleBlast(for gameObject: inout GameObject) {
        if gameObject.isBlast && !gameObject.hasBlasted {
            AudioManager.shared.playBlastAudio()
            var blastObjects: [GameObject] = getBlastObjects(from: &gameObject)
            setObjectsActive(gameObjects: &blastObjects)
        }
    }

    internal func assignCollisionVel(motionObject: inout MotionObject, gameObject: inout GameObject) {
        var gameObjectPhysics = PhysicsBody(position: gameObject.center,
                                            mass: gameObjectMass,
                                            isBlast: gameObject.isBlast)
        var motionObjectPhysics = PhysicsBody(position: motionObject.center,
                                              isBlast: motionObject.isBlast,
                                              velocity: motionObject.velocity)

        motionObjectPhysics.velocity = motionObject.velocity
        gameObjectPhysics.doElasticCollision(collider: &motionObjectPhysics, collidee: &gameObjectPhysics)
        motionObject.velocity = motionObjectPhysics.velocity

        guard let oscillateObject = gameObject as? OscillateObject else {
            return
        }
        oscillateObject.velocity = gameObjectPhysics.velocity
    }

    internal func adjustHealth(for gameObject: inout GameObject) {
        if !gameObject.hasBlasted && gameObject.health > 0.0 {
            gameObject.health -= 50.0
        }
    }

    internal func handleCollision(motionObject: inout MotionObject, gameObject: inout GameObject) {
        toggleBlast(for: &gameObject)
        assignCollisionVel(motionObject: &motionObject, gameObject: &gameObject)
        adjustHealth(for: &gameObject)
    }

    internal func updateObjectPosition(_ object: inout MotionObject) {
        object.center = object.center.add(vector: object.velocity)
    }

    internal func updateCaptureObjectPosition(_ object: inout CaptureObject) {
        object.center = object.center.add(vector: object.velocity)
        object.calcTopLine()
    }

    private func incrementExitCount() {
        guard exitCount < exitThrsh else {
            return
        }
        exitCount += 1
    }

    internal func addGravity(to object: inout MotionObject) {
        guard exitCount == exitThrsh && !object.isHandleOverlap else {
            return
        }
        object.velocity = object.velocity.add(vector: gravityVelocity)
    }

    func setObjectsActive(gameObjects: inout [GameObject]) {
        for object in gameObjects {
            object.isActive = true
            object.activeIdx = activeIdx
            activeIdx += 1
        }
    }

    @objc func updateMotionObjects() {
        for index in motionObjects.indices {
            var object = motionObjects[index]
            updateObjectPosition(&object)
            handleObjectBoundaries(&object)
            handleObjectCollisions(&object)
            motionObjects[index] = object
            addGravity(to: &object)
        }
    }

    @objc func updateCaptureObjects() {
        for index in captureObjects.indices {
            var object: CaptureObject = captureObjects[index]
            updateCaptureObjectPosition(&object)
            handleCaptureObjectBoundaries(&object)
        }
    }

    @objc func updateAmmo() {
        for index in ammo.indices {
            var object: MotionObject = ammo[index]
            updateObjectPosition(&object)
            handleAmmoBoundaries(&object, &ammo)
        }
    }

    @objc func updateOscillateObject() {
        for gameObject in gameObjects {
            guard let object = gameObject as? OscillateObject else {
                continue
            }
            object.center = object.center.add(vector: object.velocity)
            if object.center.distance(to: object.startPoint) > object.oscillateDistance {
                object.velocity = object.velocity.getComplement()
                object.oscillateCount += 1
                if object.oscillateCount == object.oscillateThrsh {
                    object.velocity = Vector(horizontal: 0.0, vertical: 0.0)
                    object.center = object.startPoint
                }

            }
        }
    }

    @objc func updateBallPosition() {
        incrementExitCount()
        updateMotionObjects()
        updateCaptureObjects()
        updateOscillateObject()
        updateAmmo()
    }
}
