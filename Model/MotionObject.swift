//
//  MotionObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 7/2/24.
//

import Foundation
import SwiftUI

@objc(MotionObject)
class MotionObject: GameObject, StateChangeObject, CircularMovableObject {

    var velocity = Vector(horizontal: 0.0, vertical: 0.0)
    var radius: Double = Constants.defaultCircleRadius
    var isOutOfBounds = false
    var startPoint: Point = Point(xCoord: 0.0, yCoord: 0.0)

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

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func makeDeepCopy() -> MotionObject {
        MotionObject(center: self.center, name: self.name, radius: self.radius)
    }
}
