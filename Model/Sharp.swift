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

    var top: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var left: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var right: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var edges: [Line] = []

    var circumradius: Double {
        get {
            return super.halfWidth
        }
        set(newValue) {
            super.halfWidth = newValue
        }
    }

    var base: Double {
        get {
            return super.halfWidth * 2
        }
        set(newValue) {
            super.halfWidth = newValue / 2
        }
    }

    var height: Double {
        get {
            return super.halfWidth * 2
        }
        set(newValue) {
            super.halfWidth = newValue / 2
        }
    }

    func initPoints() {
        top = center.add(vector: Vector(horizontal: 0.0, vertical: -circumradius))
        left = center.add(vector: Vector(horizontal: -circumradius, vertical: circumradius))
        right = center.add(vector: Vector(horizontal: circumradius, vertical: circumradius))
    }

    func initEdges() {
        var topLeftEdge = Line(start: top, end: left)
        var bottomEdge = Line(start: left, end: right)
        var topRightEdge = Line(start: right, end: top)
        edges = [topLeftEdge, bottomEdge, topRightEdge]
    }

    override init(name: String) {
        super.init(name: name)
        initPoints()
        initEdges()
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        initPoints()
        initEdges()
    }

    init(center: Point, name: String, circumradius: Double) {
        super.init(center: center, name: name)
        self.circumradius = circumradius
        initPoints()
        initEdges()
    }

    override func changeCenter(newCenter: Point) {
        center.setCartesian(xCoord: newCenter.xCoord, yCoord: newCenter.yCoord)
        initPoints()
        initEdges()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func makeDeepCopy() -> Sharp {
        Sharp(center: self.center, name: self.name, circumradius: self.circumradius)
    }
}
