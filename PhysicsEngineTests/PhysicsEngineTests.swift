//
//  PhysicsEngineTests.swift
//  PeggleTests
//
//  Created by Muhammad Reyaaz on 18/2/24.
//

import XCTest
@testable import Peggle
import SwiftUI

final class PhysicsEngineTests: XCTestCase {
    func test_gameEngineNoShot_isZero() {
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        XCTAssertNil(canvasViewModel.gameEngine)

        XCTAssertEqual(canvasViewModel.motionObjects.count, 0)
    }

    func test_gameEngineBlockShot_isSuccess() {
        let gameObject = Peg(center: Point(xCoord: Constants.screenWidth / 2,
                                           yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        canvasViewModel.shootBall()

        XCTAssertEqual(canvasViewModel.motionObjects.count, 1)
        XCTAssertNotEqual(canvasViewModel.motionObjects
            .first?.center, Point(xCoord: Constants.screenWidth / 2, yCoord: 25.0))
    }

    func test_gameEngineNoRotate_isSuccess() {
        let gameObject = Peg(center: Point(xCoord: Constants.screenWidth / 2,
                                           yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        XCTAssertEqual(canvasViewModel.shooterRotation, .zero)
    }

    func test_gameEngineShot_isNotLightUp() {
        let gameObject = Peg(center: Point(xCoord: Constants.screenWidth / 2,
                                           yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        canvasViewModel.shootBall()

        XCTAssertFalse(gameObject.isActive)
    }

    func test_physicsNoCollision_isNoLightUp() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 30.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 30.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: -10, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertFalse(gameObject.isActive)
        XCTAssertFalse(gameObstacle.isActive)
    }

    func test_ballMovement_noChangeAction() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 30.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 30.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: -10, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertEqual(gameObject.name, "testGameObject")
        XCTAssertEqual(gameObstacle.name, "gameObstacle")
    }

    func test_ballMovement_noDisappear() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 30.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 30.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: -10, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertFalse(gameObject.isDisappear)
        XCTAssertFalse(gameObstacle.isDisappear)
    }

    func test_ballMovement_noHandleOverlap() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 30.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 30.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: -10, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertFalse(gameObject.isHandleOverlap)
        XCTAssertFalse(gameObstacle.isHandleOverlap)
    }

    func test_initGameEngineDelegate_isSuccess() {
        let canvasViewModel = CanvasViewModel()
        XCTAssertNil(canvasViewModel.gameEngine)
        canvasViewModel.initGameEngineAndDelegate()
        XCTAssertNotNil(canvasViewModel.gameEngine)
    }

    func test_initGameEngineDelegateWithObjects_isSuccess() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 0.0, vertical: 0.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")

        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject, gameObstacle]
        var captureObjects: [CaptureObject] = []
        var ammo: [MotionObject] = []

        let gameEngine = GameEngine(motionObjects: &motionObjects,
                                    gameObjects: &gameObjects,
                                    captureObjects: &captureObjects, ammo: &ammo)

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.motionObjects = motionObjects

        XCTAssertNil(canvasViewModel.gameEngine)
        canvasViewModel.initGameEngineAndDelegate()
        XCTAssertNotNil(canvasViewModel.gameEngine)
        XCTAssertEqual(canvasViewModel.gameEngine?.gameObjects, gameEngine.gameObjects)
    }

    func test_motionObjectFilter_isSuccess() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 0.0, vertical: 0.0))
        motionObject.isOutOfBounds = true
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")

        let motionObjects: [MotionObject] = [motionObject]
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.motionObjects = motionObjects
        canvasViewModel.initGameEngineAndDelegate()
        canvasViewModel.gameEngineDidUpdate()

        XCTAssertEqual(canvasViewModel.motionObjects.count, 0)
    }

    func test_gameEngineDefaultShooterPosition_isSuccess() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 0.0, vertical: 0.0))
        motionObject.isOutOfBounds = true
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")

        let motionObjects: [MotionObject] = [motionObject]
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.motionObjects = motionObjects
        canvasViewModel.initGameEngineAndDelegate()

        XCTAssertEqual(canvasViewModel.getBallVector(), Vector(horizontal: -0.0, vertical: 1.0))
    }

    func test_gameEngineShootBall_isSuccess() {
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        XCTAssertNil(canvasViewModel.gameEngine)

        canvasViewModel.shootBall()

        XCTAssertNotNil(canvasViewModel.gameEngine)
        XCTAssertNotNil(canvasViewModel.motionObjects)
        XCTAssertEqual(canvasViewModel.motionObjects.first?.velocity, Vector(horizontal: -0.0, vertical: 10.0))
    }

    func test_gameEngineShootTwice_isUnsuccess() {
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        XCTAssertNil(canvasViewModel.gameEngine)

        canvasViewModel.shootBall()
        canvasViewModel.shootBall()

        XCTAssertNotNil(canvasViewModel.gameEngine)
        XCTAssertNotNil(canvasViewModel.motionObjects)
        XCTAssertEqual(canvasViewModel.motionObjects.count, 1)
    }

    func test_gameEngineShootThrice_isUnsuccess() {
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        let gameObjects: [GameObject] = [gameObject, gameObstacle]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)

        XCTAssertNil(canvasViewModel.gameEngine)

        canvasViewModel.shootBall()
        canvasViewModel.shootBall()
        canvasViewModel.shootBall()

        XCTAssertNotNil(canvasViewModel.gameEngine)
        XCTAssertNotNil(canvasViewModel.motionObjects)
        XCTAssertEqual(canvasViewModel.motionObjects.count, 1)
    }
}
