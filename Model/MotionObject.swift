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
    private(set) var radius: Double = Constants.defaultCircleRadius
    var isOutOfBounds = false

    override init(name: String) {
        super.init(name: name)
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
    }

    init(center: Point, name: String, radius: Double) {
        super.init(center: center, name: name)
        self.radius = radius
    }

    init(center: Point, name: String, velocity: Vector) {
        super.init(center: center, name: name)
        self.velocity = velocity
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: MyCodingKey.self)

        guard let radiusKey = MyCodingKey(stringValue: "radius"),
              let radius = try container.decodeIfPresent(Double.self, forKey: radiusKey) else {
            return
        }
        self.radius = radius

        guard let centerKey = MyCodingKey(stringValue: "center"),
              let center = try container.decodeIfPresent(Point.self, forKey: centerKey) else {
            return
        }
        self.center = center

        guard let nameKey = MyCodingKey(stringValue: "name"),
              let name = try container.decodeIfPresent(String.self, forKey: nameKey) else {
            return
        }
        self.name = name
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: MyCodingKey.self)

        guard let radiusKey = MyCodingKey(stringValue: "radius") else {
            return
        }
        try container.encode(radius, forKey: radiusKey)

        guard let centerKey = MyCodingKey(stringValue: "center") else {
            return
        }
        try container.encode(center, forKey: centerKey)

        guard let nameKey = MyCodingKey(stringValue: "name") else {
            return
        }
        try container.encode(name, forKey: nameKey)
    }

    override func makeDeepCopy() -> MotionObject {
        MotionObject(center: self.center, name: self.name, radius: self.radius)
    }
}
