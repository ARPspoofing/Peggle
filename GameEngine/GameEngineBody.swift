//
//  GameEngineBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 9/2/24.
//

import SwiftUI

class GameEngineBody: CollisionGameEngine, GravityGameEngine {

    private let screenWidth = Constants.screenWidth
    private let screenHeight = Constants.screenHeight
    private let exitThrsh = 10
    private var exitCount = 0
    internal let gravityVelocity = Vector(horizontal: 0.0, vertical: 0.5)
    internal let gameObjectMass = 100.0
    internal let intersectThrsh = 10

    var motionObjects: [MotionObject]
    var gameObjects: [GameObject]
    var captureObjects: [CaptureObject]

    var isUpdating = false

    init(motionObjects: inout [MotionObject], gameObjects: inout [GameObject], captureObjects: inout [CaptureObject]) {
        self.motionObjects = motionObjects
        self.gameObjects = gameObjects
        self.captureObjects = captureObjects
    }

    private func handleVerticalBoundaries(_ object: inout MotionObject) {
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
        object.isOutOfBounds = true
    }

    private func handleHorizontalBoundaries(_ object: inout MotionObject) {
        handleTopBoundary(&object)
        handleBottomBoundary(&object)
    }

    internal func handleObjectBoundaries(_ object: inout MotionObject) {
        handleVerticalBoundaries(&object)
        handleHorizontalBoundaries(&object)
    }

    private func handleNoIntersection(for peg: inout Peg, and object: inout MotionObject) {
        peg.isHandleOverlap = false
        peg.handleOverlapCount = 0
        peg.isDisappear = false
        object.isHandleOverlap = false
    }

    private func handleFirstIntersection(for peg: inout Peg, and object: inout MotionObject) {
        handleCollision(motionObject: &object, gameObject: peg)
        peg.isHandleOverlap = true
        object.isHandleOverlap = true
    }

    private func subsequentIntersection(for peg: inout Peg) {
        peg.handleOverlapCount += 1
        peg.isDisappear = false
    }

    private func thresholdIntersection(for peg: inout Peg) {
        peg.isDisappear = true
    }

    internal func handleIntersection(for peg: inout Peg, and object: inout MotionObject) {
        peg.isActive = true
        if peg.handleOverlapCount < intersectThrsh {
            if !peg.isHandleOverlap {
                handleFirstIntersection(for: &peg, and: &object)
            }
            subsequentIntersection(for: &peg)
        } else if peg.handleOverlapCount == intersectThrsh {
            thresholdIntersection(for: &peg)
        }
    }

    private func isHandleOverlapObjects(motionObject object: inout MotionObject, isIntersect: inout Bool) {
        for gameObject in gameObjects {
            guard var peg = gameObject as? Peg else {
                continue
            }
            guard !object.checkNoIntersection(with: peg) else {
                handleNoIntersection(for: &peg, and: &object)
                continue
            }
            handleIntersection(for: &peg, and: &object)
        }
    }

    private func checkAndResetOverlap(isIntersect: inout Bool) {
        for innerObject in gameObjects {
            guard let peg = innerObject as? Peg else {
                continue
            }
            peg.isHandleOverlap = false
        }
    }

    internal func handleObjectCollisions(_ object: inout MotionObject) {
        var isIntersect = false
        isHandleOverlapObjects(motionObject: &object, isIntersect: &isIntersect)
    }

    internal func handleCollision(motionObject: inout MotionObject, gameObject: Peg) {
        var gameObjectPhysics = PhysicsBody(object: gameObject, position: gameObject.center, mass: gameObjectMass)
        var motionObjectPhysics = PhysicsBody(object: motionObject, position: motionObject.center)

        motionObjectPhysics.velocity = motionObject.velocity
        gameObjectPhysics.doElasticCollision(collider: &motionObjectPhysics, collidee: &gameObjectPhysics)
        motionObject.velocity = motionObjectPhysics.velocity
    }

    /*
    internal func updateObjectPosition(_ object: inout MotionObject) {
        object.center = object.center.add(vector: object.velocity)
    }
    */

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

    // TODO: Rename to updateGamePosition and have updateBall and updateCapture inside
    @objc func updateBallPosition() {
        //print("motion object length: ", motionObjects.count, "capture object length: ", captureObjects.count)
        incrementExitCount()
        motionObjects = motionObjects.filter { !$0.isOutOfBounds }
        for index in motionObjects.indices {
            var object = motionObjects[index]
            updateObjectPosition(&object)
            handleObjectBoundaries(&object)
            handleObjectCollisions(&object)
            motionObjects[index] = object
            addGravity(to: &object)
        }
        for index in captureObjects.indices {
            var object: MotionObject = captureObjects[index]
            object.center = object.center.add(vector: object.velocity)
            handleObjectBoundaries(&object)
        }
    }
}
