//
//  OscillateObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import Foundation

@objc(OscillateObject)
class OscillateObject: GameObject, StateChangeObject, CircularMovableObject {

    var velocity = Vector(horizontal: 0.0, vertical: 0.0)
    var isOutOfBounds = false
    var startPoint: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var oscillateCount: Int = 0
    var oscillateThrsh: Int = 10
    var oscillateDistance: Double = 30.0

    var radius: Double {
        get {
            return super.halfWidth
        }
        set(newValue) {
            super.halfWidth = newValue
        }
    }

    override init(name: String) {
        super.init(name: name)
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        self.startPoint = center.deepCopy()
    }

    init(center: Point, name: String, radius: Double) {
        super.init(center: center, name: name)
        self.radius = radius
        self.startPoint = center.deepCopy()
    }

    init(center: Point, name: String, velocity: Vector) {
        super.init(center: center, name: name)
        let speedUpFactor = 10.0
        self.startPoint = center.deepCopy()
        self.velocity = speedUpVelocity(factor: speedUpFactor, vector: velocity)
    }

    init(center: Point, name: String, radius: Double, orientation: Double) {
        super.init(center: center, name: name)
        self.radius = radius
        self.orientation = orientation
        self.startPoint = center.deepCopy()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        return checkNoIntersection(with: gameObject) && checkBorders()
    }

    override func makeDeepCopy() -> OscillateObject {
        OscillateObject(center: self.center, name: self.name, radius: self.radius)
    }
}
