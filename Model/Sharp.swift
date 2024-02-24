//
//  Sharp.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

// TODO: Encapsulate top, left, right into a class, make construction of top, left, and right neater
// TODO: Make everything private
// TODO: Fix two sharp rotated object gap by removing gap, and small overlap
import SwiftUI
import Foundation

@objc(Sharp)
class Sharp: GameObject, TriangularMovableObject {

    var top: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var left: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var right: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var edges: [Line] = []
    var initialLeft: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var initialRight: Point = Point(xCoord: 0.0, yCoord: 0.0)

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

    init(center: Point, name: String, circumradius: Double) {
        super.init(center: center, name: name)
        self.circumradius = circumradius
        initPoints()
        initEdges()
        initialTop = top
        initialLeft = left
        initialRight = right
    }

    override init(name: String) {
        super.init(name: name)
        initPoints()
        initEdges()
        initialTop = top
        initialLeft = left
        initialRight = right
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        initPoints()
        initEdges()
        initialTop = top
        initialLeft = left
        initialRight = right
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    func initPoints() {
        top = center.add(vector: Vector(horizontal: 0.0, vertical: -circumradius))
        initialTop = top
        left = center.add(vector: Vector(horizontal: -circumradius, vertical: circumradius))
        right = center.add(vector: Vector(horizontal: circumradius, vertical: circumradius))
    }

    func initEdges() {
        let topLeftEdge = Line(start: top, end: left)
        let bottomEdge = Line(start: left, end: right)
        let topRightEdge = Line(start: right, end: top)
        edges = [topLeftEdge, bottomEdge, topRightEdge]
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func changeCenter(newCenter: Point) {
        center.setCartesian(xCoord: newCenter.xCoord, yCoord: newCenter.yCoord)
        initPoints()
        changeOrientation(to: orientation)
        initEdges()
    }

    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        return checkNoIntersection(with: gameObject) && checkBorders()
    }

    // TODO: Move to physics engine
    func rotateTopPoint(initialTop: Point, rotationAngle: Double, circumradius: Double) -> Point {
        let newX = initialTop.xCoord + circumradius * sin(rotationAngle)
        let newY = initialTop.yCoord + circumradius * (1 - cos(rotationAngle))
        return Point(xCoord: newX, yCoord: newY)
    }

    func rotateBottomPoint(initialTop: Point, rotationAngle: Double, circumradius: Double) -> Point {
        var adjustedAngle = rotationAngle - (2 * Double.pi / 3)
        if adjustedAngle > Double.pi {
            adjustedAngle -= 2 * Double.pi
        }
        let newX = initialTop.xCoord + circumradius * sin(adjustedAngle)
        let newY = initialTop.yCoord + circumradius * (1 - cos(adjustedAngle))
        return Point(xCoord: newX, yCoord: newY)
    }

    override func changeOrientation(to end: Double) {
        orientation = end

        let newTop = rotateTopPoint(initialTop: initialTop, rotationAngle: end, circumradius: circumradius)

        let rightX = newTop.xCoord + top.distance(to: right) * cos(end + Double.pi / 3)
        let rightY = newTop.yCoord + top.distance(to: right) * sin(end + Double.pi / 3)

        let newRight = Point(xCoord: rightX, yCoord: rightY)

        let leftX = newTop.xCoord + top.distance(to: left) * cos(end + 2 * Double.pi / 3)
        let leftY = newTop.yCoord + top.distance(to: left) * sin(end + 2 * Double.pi / 3)

        let newLeft = Point(xCoord: leftX, yCoord: leftY)

        top = newTop
        left = newLeft
        right = newRight
        initEdges()
    }

    override func makeDeepCopy() -> Sharp {
        Sharp(center: self.center, name: self.name, circumradius: self.circumradius)
    }
}
