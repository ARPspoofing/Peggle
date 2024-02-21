//
//  GameEngineTests.swift
//  PeggleTests
//
//  Created by Muhammad Reyaaz on 16/2/24.
//

import XCTest
@testable import Peggle
import SwiftUI

final class GameEngineTests: XCTestCase {
    func test_updatePosition_noCollision() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 2.0, vertical: 2.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject]
        let gameEngine = GameEngine(motionObjects: &motionObjects, gameObjects: &gameObjects)
        gameEngine.updateBallPosition()
        XCTAssertEqual(motionObject.center, Point(xCoord: 52.0, yCoord: 52.0))
    }

    func test_updatePosition_horizontalCollision() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 2.0, vertical: 0.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 50.0), name: "gameObstacle")
        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject, gameObstacle]

        let gameEngine = GameEngine(motionObjects: &motionObjects, gameObjects: &gameObjects)
        gameEngine.updateBallPosition()
        gameEngine.updateBallPosition()

        XCTAssertLessThan(motionObject.center.xCoord, 54.0)
    }

    func test_updatePosition_verticalCollision() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 0.0, vertical: 2.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 50.0, yCoord: 52.0), name: "gameObstacle")
        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject, gameObstacle]

        let gameEngine = GameEngine(motionObjects: &motionObjects, gameObjects: &gameObjects)
        gameEngine.updateBallPosition()
        gameEngine.updateBallPosition()

        XCTAssertLessThan(motionObject.center.yCoord, 54.0)
    }

    func test_updatePosition_diagonalCollision() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 2.0, vertical: 2.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject, gameObstacle]

        let gameEngine = GameEngine(motionObjects: &motionObjects, gameObjects: &gameObjects)
        gameEngine.updateBallPosition()
        gameEngine.updateBallPosition()

        XCTAssertLessThan(motionObject.center.xCoord, 54.0)
        XCTAssertLessThan(motionObject.center.yCoord, 54.0)
    }

    func test_gamePosition_diagonalCollision() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 2.0, vertical: 2.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")
        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject, gameObstacle]

        let gameEngine = GameEngine(motionObjects: &motionObjects, gameObjects: &gameObjects)
        gameEngine.updateBallPosition()
        gameEngine.updateBallPosition()

        XCTAssertEqual(gameObject.center.xCoord, 25.0)
        XCTAssertEqual(gameObject.center.yCoord, 25.0)

        XCTAssertEqual(gameObstacle.center.xCoord, 52.0)
        XCTAssertEqual(gameObstacle.center.yCoord, 52.0)
    }

    func test_gravity_motionObject() {
        let motionObject = MotionObject(center: Point(xCoord: 50.0, yCoord: 50.0),
                                        name: "testMotionObject",
                                        velocity: Vector(horizontal: 0.0, vertical: 0.0))
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 52.0, yCoord: 52.0), name: "gameObstacle")

        var motionObjects: [MotionObject] = [motionObject]
        var gameObjects: [GameObject] = [gameObject, gameObstacle]

        let gameEngine = GameEngine(motionObjects: &motionObjects, gameObjects: &gameObjects)

        for _ in 0..<20 {
            motionObject.isHandleOverlap = false
            gameEngine.updateBallPosition()
        }
        XCTAssertGreaterThan(motionObject.center.yCoord, 50.0)
    }

    func test_elasticCollision_noMass() {
        let gameObject = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 25.0, yCoord: 25.0), name: "gameObstacle")
        let position = Vector(horizontal: 10.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: position, mass: 0.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: position, mass: 0.0)

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertEqual(physicsBodyA.position, position)
    }

    func test_elasticCollision_withMass() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 15.0, yCoord: 15.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 15.0, vertical: 15.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: positionA, mass: 5.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: -10, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertNotEqual(physicsBodyA.velocity, physicsBodyVelA)
        XCTAssertNotEqual(physicsBodyB.position, physicsBodyVelB)
    }

    func test_elasticCollision_movingStationary() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 60.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 60.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: 0, vertical: 0)
        let zeroVel = Vector(horizontal: 0, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertEqual(physicsBodyA.velocity, zeroVel)
    }

    func test_elasticCollision_bothStationary() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 60.0, yCoord: 10.0), name: "gameObstacle")

        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 60.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 0, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: 0, vertical: 0)
        let zeroVel = Vector(horizontal: 0, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertEqual(physicsBodyA.velocity, zeroVel)
        XCTAssertEqual(physicsBodyB.velocity, zeroVel)
    }

    func test_elasticCollision_tangentMoving() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 60.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 60.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 0, vertical: 10)
        let physicsBodyVelB = Vector(horizontal: 0, vertical: -10)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertEqual(physicsBodyA.velocity, physicsBodyVelA)
        XCTAssertEqual(physicsBodyB.velocity, physicsBodyVelB)
    }

    func test_elasticCollision_tangentTouchingMoving() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 30.0, yCoord: 10.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 30.0, vertical: 10.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 10, vertical: 0)
        let physicsBodyVelB = Vector(horizontal: -10, vertical: 0)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)

        XCTAssertEqual(physicsBodyA.velocity, physicsBodyVelB)
    }

    func test_elasticCollision_diagonalTouchingMoving() {
        let gameObject = Peg(center: Point(xCoord: 10.0, yCoord: 10.0), name: "testGameObject")
        let gameObstacle = Peg(center: Point(xCoord: 15.0, yCoord: 15.0), name: "gameObstacle")
        let positionA = Vector(horizontal: 10.0, vertical: 10.0)
        let positionB = Vector(horizontal: 15.0, vertical: 15.0)

        var physicsBodyA = PhysicsBody(object: gameObject, position: positionA, mass: 10.0)
        var physicsBodyB = PhysicsBody(object: gameObstacle, position: positionB, mass: 10.0)

        let physicsBodyVelA = Vector(horizontal: 5, vertical: 5)
        let physicsBodyVelB = Vector(horizontal: -5, vertical: -5)

        physicsBodyA.velocity = physicsBodyVelA
        physicsBodyB.velocity = physicsBodyVelB

        physicsBodyA.doElasticCollision(collider: &physicsBodyA, collidee: &physicsBodyB)
        XCTAssertEqual(physicsBodyB.velocity, physicsBodyVelB)
    }
}
