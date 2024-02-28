//
//  GameEngineBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 9/2/24.
//

import SwiftUI

// TODO: When blast, objects still not transparent. Need to set to disappear
// TODO: Fix bug when animating, should not be able to shoot
// TODO: When hit the last orange gameObject, should zoom in
class GameEngineBody: CollisionGameEngine, GravityGameEngine {

    private let screenWidth = Constants.screenWidth
    private let screenHeight = Constants.screenHeight
    private let exitThrsh = 10
    private var exitCount = 0
    internal let gravityVelocity = Vector(horizontal: 0.0, vertical: 0.5)
    internal let gameObjectMass = 100.0
    internal let intersectThrsh = 10
    internal let blastRadius = 100.0
    internal let ammoBoundary = Constants.gameHeight - 200
    internal let ammoResetVel = Vector(horizontal: 0.0, vertical: -10.0)
    internal let ammoShootVel = Vector(horizontal: 0.0, vertical: -20.0)
    internal let ammoStopVel = Vector(horizontal: 0.0, vertical: 0.0)

    var motionObjects: [MotionObject]
    var gameObjects: [GameObject]
    var captureObjects: [CaptureObject]
    var ammo: [MotionObject]

    var isUpdating = false
    var isReload = false

    // TODO: Abstract this
    var activeIdx = 1

    init(motionObjects: inout [MotionObject], gameObjects: inout [GameObject], captureObjects: inout [CaptureObject], ammo: inout [MotionObject]) {
        self.motionObjects = motionObjects
        self.gameObjects = gameObjects
        self.captureObjects = captureObjects
        self.ammo = ammo
    }

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

    // TODO: Abstract out reset and change center
    private func handleBottomBoundary(_ object: inout MotionObject) {
        guard !object.checkBottomBorderGame() else {
            return
        }
        guard object.isReappear else {
            object.isOutOfBounds = true
            return
        }
        object.changeCenter(newCenter: Point(xCoord: object.retrieveXCoord(), yCoord: 50.0))
        object.resetVelocity(magnitude: 10.0)
    }

    private func handlePlaneBoundaries(_ object: inout MotionObject) {
        handleTopBoundary(&object)
        handleBottomBoundary(&object)
    }

    internal func handleObjectBoundaries(_ object: inout MotionObject) {
        handleSideBoundaries(&object)
        handlePlaneBoundaries(&object)
    }

    internal func handleCaptureObjectBoundaries(_ object: inout MotionObject) {
        handleSideBoundaries(&object)
    }

    func handleAmmoBottomBoundary(_ object: inout MotionObject, _ ammo: inout [MotionObject]) {
        for ammoObject in ammo {
            guard object.retrieveYCoord() >= ammoBoundary else {
                continue
            }
            ammoObject.velocity = ammoResetVel
        }
    }

    func stopAndShootAmmo(_ ammo: inout [MotionObject]) {
        for index in ammo.indices {
            let ammoObject: MotionObject = ammo[index]
            if (ammoObject.center.yCoord < ammoObject.startPoint.yCoord) {
                if index == ammo.count - 1 {
                    ammoObject.velocity = ammoShootVel
                } else {
                    ammoObject.velocity = ammoStopVel
                }
            }
        }
    }

    func setAmmoOutOfBounds(_ ammo: inout [MotionObject]) {
        for index in ammo.indices {
            let ammoObject: MotionObject = ammo[index]
            if ammoObject.center.yCoord == 0 {
                ammoObject.isOutOfBounds = true
            }
        }
    }

    // TODO: Move everything to physics engine
    internal func handleAmmoBoundaries(_ object: inout MotionObject, _ ammo: inout [MotionObject]) {
        handleAmmoBottomBoundary(&object, &ammo)
        stopAndShootAmmo(&ammo)
        setAmmoOutOfBounds(&ammo)
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
        if gameObject is ReappearObject {
            object.isReappear = true
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
        if gameObject.hasBlasted {
            gameObject.isDisappear = true
            gameObject.handleOverlapCount = 10
            return
        }
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

    private func isHandleOverlapObjects(motionObject object: inout MotionObject, isIntersect: inout Bool) {
        for gameObject in gameObjects {
            var mutatableGameObject = gameObject
            guard !object.checkNoIntersection(with: mutatableGameObject) else {
                handleNoIntersection(for: &mutatableGameObject, and: &object)
                continue
            }
            handleIntersection(for: &mutatableGameObject, and: &object)
        }
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

    internal func handleCollision(motionObject: inout MotionObject, gameObject: inout GameObject) {
        if gameObject.isBlast && !gameObject.hasBlasted {
            var blastObjects: [GameObject] = getBlastObjects(from: &gameObject)
            setObjectsActive(gameObjects: &blastObjects)
        }
        // TODO: Do not make physics body update the object position. Update at game engine
        var gameObjectPhysics = PhysicsBody(object: gameObject, position: gameObject.center, mass: gameObjectMass)
        var motionObjectPhysics = PhysicsBody(object: motionObject, position: motionObject.center)

        motionObjectPhysics.velocity = motionObject.velocity
        gameObjectPhysics.doElasticCollision(collider: &motionObjectPhysics, collidee: &gameObjectPhysics)
        motionObject.velocity = motionObjectPhysics.velocity

        guard let oscillateObject = gameObject as? OscillateObject else {
            return
        }
        oscillateObject.velocity = gameObjectPhysics.velocity
        //oscillateObject.velocity = motionObject.velocity.getComplement()
    }


    internal func updateObjectPosition(_ object: inout MotionObject) {
        object.center = object.center.add(vector: object.velocity)
    }

    private func incrementExitCount() {
        if exitCount < exitThrsh {
            exitCount += 1
        }
    }

    internal func addGravity(to object: inout MotionObject) {
        if exitCount == exitThrsh && !object.isHandleOverlap {
            object.velocity = object.velocity.add(vector: gravityVelocity)
        }
    }

    func isInBlastRadius(blastObject: GameObject, gameObject: GameObject) -> Bool {
        blastObject.distance(to: gameObject) <= blastRadius
    }

    func doRecursiveBlast(from object: inout GameObject, blastObjects: inout [GameObject]) {
        for index in gameObjects.indices {
            let gameObject = gameObjects[index]
            if isInBlastRadius(blastObject: object, gameObject: gameObject) {
                if gameObject.isBlast {
                    gameObject.hasBlasted = true
                    blastObjects.append(contentsOf: getBlastObjects(from: &gameObjects[index]))
                }
                blastObjects.append(gameObject)
            }
        }
    }

    // TODO: Set chain effect for other blasts, and make neater. Not workint
    func getBlastObjects(from object: inout GameObject) -> [GameObject] {
        guard !object.hasBlasted else {
            return []
        }
        object.hasBlasted = true
        var blastObjects: [GameObject] = []
        doRecursiveBlast(from: &object, blastObjects: &blastObjects)
        return blastObjects
    }

    func setObjectsActive(gameObjects: inout [GameObject]) {
        for object in gameObjects {
            object.isActive = true
            object.activeIdx = activeIdx
            activeIdx += 1
        }
    }

    @objc func updateMotionObjects() {
        motionObjects = motionObjects.filter { !$0.isOutOfBounds }
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
        // TODO: Add multiple frozen capture objects (vel = 0) when all gameObjects are eliminated
        for index in captureObjects.indices {
            var object: MotionObject = captureObjects[index]
            updateObjectPosition(&object)
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
            guard var object = gameObject as? OscillateObject else {
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

    // TODO: Rename to updateGamePosition and have updateBall and updateCapture inside
    @objc func updateBallPosition() {
        incrementExitCount()
        updateMotionObjects()
        updateCaptureObjects()
        updateOscillateObject()
        updateAmmo()
    }
}
