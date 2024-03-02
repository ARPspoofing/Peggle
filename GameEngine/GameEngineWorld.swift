//
//  GameEngineWorld.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 2/3/24.
//

import Foundation

class GameEngineWorld {
    var motionObjects: [MotionObject]
    var gameObjects: [GameObject]
    var captureObjects: [CaptureObject]
    var ammo: [MotionObject]

    internal let ammoResetVel = Vector(horizontal: 0.0, vertical: -10.0)
    internal let ammoShootVel = Vector(horizontal: 0.0, vertical: -20.0)
    internal let ammoStopVel = Vector(horizontal: 0.0, vertical: 0.0)
    internal let blastRadius = 100.0
    internal let gameObjectMass = 100.0

    init(motionObjects: inout [MotionObject], gameObjects: inout [GameObject], captureObjects: inout [CaptureObject], ammo: inout [MotionObject]) {
        self.motionObjects = motionObjects
        self.gameObjects = gameObjects
        self.captureObjects = captureObjects
        self.ammo = ammo
    }

    // MARK: Blast
    func isInBlastRadius(blastObject: GameObject, gameObject: GameObject) -> Bool {
        blastObject.distance(to: gameObject) <= blastRadius
    }

    func getBlastObjects(from object: inout GameObject) -> [GameObject] {
        guard !object.hasBlasted else {
            return []
        }
        object.hasBlasted = true
        var blastObjects: [GameObject] = []
        doRecursiveBlast(from: &object, blastObjects: &blastObjects)
        return blastObjects
    }

    func doRecursiveBlast(from object: inout GameObject, blastObjects: inout [GameObject]) {
        for index in gameObjects.indices {
            let gameObject = gameObjects[index]
            guard isInBlastRadius(blastObject: object, gameObject: gameObject) else {
                continue
            }
            if gameObject.isBlast {
                gameObject.hasBlasted = true
                gameObject.health = 0.0
                blastObjects.append(contentsOf: getBlastObjects(from: &gameObjects[index]))
            }
            blastObjects.append(gameObject)
        }
    }

    // MARK: Ammo
    func stopAndShootAmmo(_ ammo: inout [MotionObject]) {
        for index in ammo.indices {
            let ammoObject: MotionObject = ammo[index]
            if index == ammo.count - 1 {
                ammoObject.velocity = ammoShootVel
            } else {
                ammoObject.velocity = ammoStopVel
            }
        }
    }

    func setAmmoOutOfBounds(_ ammo: inout [MotionObject]) {
        for index in ammo.indices {
            let ammoObject: MotionObject = ammo[index]
            guard ammoObject.center.yCoord == 0 else {
                continue
            }
            ammoObject.isOutOfBounds = true
        }
    }

    internal func handleAmmoBoundaries(_ object: inout MotionObject, _ ammo: inout [MotionObject]) {
        stopAndShootAmmo(&ammo)
        setAmmoOutOfBounds(&ammo)
    }

    // MARK: Bounce
    internal func handleBounce(for captureObject: inout CaptureObject, and object: inout MotionObject) {
        var captureObjectPhysics = PhysicsBody(object: captureObject, position: captureObject.center, mass: gameObjectMass)
        var motionObjectPhysics = PhysicsBody(object: object, position: object.center)

        motionObjectPhysics.velocity = object.velocity
        captureObjectPhysics.doElasticCollision(collider: &motionObjectPhysics, collidee: &captureObjectPhysics)
        object.velocity = motionObjectPhysics.velocity
    }
}
