//
//  Sharp.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

// TODO: Encapsulate top, left, right into a class, make construction of top, left, and right neater
import SwiftUI

@objc(Sharp)
class Sharp: GameObject, TriangularMovableObject {

    private(set) var radius: Double = Constants.defaultCircleRadius
    // TODO: Rename variable names
    var top: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var left: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var right: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var edges: [Line] = [Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))]

    override init(name: String) {
        super.init(name: name)
        self.top = self.center.add(vector: Vector(horizontal: 0.0, vertical: -radius))
        self.left = self.center.add(vector: Vector(horizontal: -radius, vertical: radius))
        self.right = self.center.add(vector: Vector(horizontal: radius, vertical: radius))
        self.edges = [Line(start: top, end: left), Line(start: left, end: right), Line(start: right, end: top)]
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        self.top = self.center.add(vector: Vector(horizontal: 0.0, vertical: -radius))
        self.left = self.center.add(vector: Vector(horizontal: -radius, vertical: radius))
        self.right = self.center.add(vector: Vector(horizontal: radius, vertical: radius))
        self.edges = [Line(start: top, end: left), Line(start: left, end: right), Line(start: right, end: top)]
    }

    init(center: Point, name: String, radius: Double) {
        super.init(center: center, name: name)
        self.radius = radius
        self.top = self.center.add(vector: Vector(horizontal: 0.0, vertical: -radius))
        self.left = self.center.add(vector: Vector(horizontal: -radius, vertical: radius))
        self.right = self.center.add(vector: Vector(horizontal: radius, vertical: radius))
        self.edges = [Line(start: top, end: left), Line(start: left, end: right), Line(start: right, end: top)]
    }

    override func changeCenter(newCenter: Point) {
        center.setCartesian(xCoord: newCenter.xCoord, yCoord: newCenter.yCoord)
        self.top = self.center.add(vector: Vector(horizontal: 0.0, vertical: -radius))
        self.left = self.center.add(vector: Vector(horizontal: -radius, vertical: radius))
        self.right = self.center.add(vector: Vector(horizontal: radius, vertical: radius))
        self.edges = [Line(start: top, end: left), Line(start: left, end: right), Line(start: right, end: top)]
    }

    // TODO: Reduce bloat
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

        guard let topKey = MyCodingKey(stringValue: "top"),
              let top = try container.decodeIfPresent(Point.self, forKey: topKey) else {
            return
        }
        self.top = top

        guard let leftKey = MyCodingKey(stringValue: "left"),
              let left = try container.decodeIfPresent(Point.self, forKey: leftKey) else {
            return
        }
        self.left = left

        guard let rightKey = MyCodingKey(stringValue: "right"),
              let right = try container.decodeIfPresent(Point.self, forKey: rightKey) else {
            return
        }
        self.right = right
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

        guard let topKey = MyCodingKey(stringValue: "top") else {
            return
        }
        try container.encode(top, forKey: topKey)

        guard let leftKey = MyCodingKey(stringValue: "left") else {
            return
        }
        try container.encode(left, forKey: leftKey)

        guard let rightKey = MyCodingKey(stringValue: "right") else {
            return
        }
        try container.encode(right, forKey: rightKey)
    }

    override func makeDeepCopy() -> Sharp {
        Sharp(center: self.center, name: self.name, radius: self.radius)
    }
}
