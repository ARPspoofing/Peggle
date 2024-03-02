//
//  ObstacleObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 28/2/24.
//

import SwiftUI
import Foundation

@objc(ObstacleObject)
class ObstacleObject: GameObject, RectangularMovableObject {
    private var isObserverRegistered = false
    var top: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var topLeft: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var topRight: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var bottomLeft: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var bottomRight: Point = Point(xCoord: 0.0, yCoord: 0.0)

    var initialTopLeft: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var initialTopRight: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var initialBottomLeft: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var initialBottomRight: Point = Point(xCoord: 0.0, yCoord: 0.0)
    var edges: [Line] = []

    var prev = 0.0
    
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

    init(center: Point, name: String, circumradius: Double, orientation: Double) {
        super.init(center: center, name: name)
        self.circumradius = circumradius
        self.orientation = orientation
        initPointsAndEdges()
    }

    override init(name: String) {
        super.init(name: name)
        initPointsAndEdges()
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        initPointsAndEdges()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    deinit {
        if isObserverRegistered {
            removeObserver(self, forKeyPath: #keyPath(halfWidth))
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(halfWidth) {
            resizePoints()
        }
    }

    func initInitials() {
        initialTop = top
        initialTopLeft = topLeft
        initialTopRight = topRight
        initialBottomLeft = bottomLeft
        initialBottomRight = bottomRight
    }

    func initPoints() {
        top = center.add(vector: Vector(horizontal: 0.0, vertical: -circumradius))
        topLeft = center.add(vector: Vector(horizontal: -circumradius / 2, vertical: -circumradius))
        topRight = center.add(vector: Vector(horizontal: circumradius / 2, vertical: -circumradius))
        bottomLeft = center.add(vector: Vector(horizontal: -circumradius / 2, vertical: circumradius))
        bottomRight = center.add(vector: Vector(horizontal: circumradius / 2, vertical: circumradius))
        initInitials()
    }

    func initEdges() {
        let leftEdge = Line(start: bottomLeft, end: topLeft)
        let rightEdge = Line(start: bottomRight, end: topRight)
        let topEdge = Line(start: topLeft, end: topRight)
        let bottomEdge = Line(start: bottomLeft, end: bottomRight)
        edges = [leftEdge, rightEdge, topEdge, bottomEdge]
    }

    func initPointsAndEdges() {
        initPoints()
        initEdges()
        initInitials()
        addObserver(self, forKeyPath: #keyPath(halfWidth), options: [.old, .new], context: nil)
        isObserverRegistered = true
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

    func resizePoints() {
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

    func rotateTopPoint(rotationAngle: Double) -> Point {
        let newX = initialTop.xCoord + circumradius * sin(rotationAngle)
        let newY = (initialTop.yCoord + circumradius * (1 - cos(rotationAngle)))
        return Point(xCoord: newX, yCoord: newY)
    }

    func getTopLine() -> Line {
        let line = Line(start: center, end: top)
        let perpendicularVector = line.getPerpendicularVector()
        return Line(vector: perpendicularVector, distance: circumradius, middle: top)
    }

    func setBottomCornerPoints() {
        let line = Line(start: center, end: top)
        let leftLine = Line(end: topLeft, vector: line.getLineVector(), maxDistance: circumradius * 2)
        let rightLine = Line(end: topRight, vector: line.getLineVector(), maxDistance: circumradius * 2)
        bottomLeft = leftLine.start
        bottomRight = rightLine.start
    }

    func setTopCornerPoints() {
        let topLine = getTopLine()
        topLeft = topLine.start
        topRight = topLine.end
    }

    override func changeOrientation(to end: Double) {
        orientation = end
        let newTop = rotateTopPoint(rotationAngle: end)
        top = newTop
        setTopCornerPoints()
        setBottomCornerPoints()
        initEdges()
    }

    override func makeDeepCopy() -> ObstacleObject {
        ObstacleObject(center: self.center, name: self.name, circumradius: self.circumradius, orientation: self.orientation)
    }
}
