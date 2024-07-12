//
//  Sharp.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import SwiftUI
import Foundation

@objc(Sharp)
class Sharp: GameObject, TriangularMovableObject {
    private var isObserverRegistered = false
    var top = Point(xCoord: 0.0, yCoord: 0.0)
    var left = Point(xCoord: 0.0, yCoord: 0.0)
    var right = Point(xCoord: 0.0, yCoord: 0.0)
    var polygon: [Point] = []
    var initialLeft = Point(xCoord: 0.0, yCoord: 0.0)
    var initialRight = Point(xCoord: 0.0, yCoord: 0.0)
    var edges: [Line] = []

    var circumradius: Double {
        get {
            super.halfWidth
        }
        set(newValue) {
            super.halfWidth = newValue
        }
    }

    var base: Double {
        get {
            super.halfWidth * 2
        }
        set(newValue) {
            super.halfWidth = newValue / 2
        }
    }

    var height: Double {
        get {
            super.halfWidth * 2
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(halfWidth) {
            resizePoints()
        }
    }

    func initPoints() {
        top = center.add(vector: Vector(horizontal: 0.0, vertical: -circumradius))
        left = center.add(vector: Vector(horizontal: -circumradius, vertical: circumradius))
        right = center.add(vector: Vector(horizontal: circumradius, vertical: circumradius))
        initialTop = top
        polygon = [top, left, right]
    }

    func initEdges() {
        let topLeftEdge = Line(start: top, end: left)
        let bottomEdge = Line(start: left, end: right)
        let topRightEdge = Line(start: right, end: top)
        edges = [topLeftEdge, bottomEdge, topRightEdge]
        polygon = [top, left, right]
    }

    func initPointsAndEdges() {
        initPoints()
        initEdges()
        initialTop = top
        initialLeft = left
        initialRight = right
        polygon = [top, left, right]
        addObserver(self, forKeyPath: #keyPath(halfWidth), options: [.old, .new], context: nil)
        isObserverRegistered = true
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
        let collisionDetector = CollisionDetector()
        /*
        return collisionDetector.checkSafeToInsert(source: self, with: gameObject)
        && !pointIsInsidePolygon(point: gameObject.center, radius: gameObject.halfWidth)
        //&& !pointIsInsideTriangle(point: gameObject.center)
        */
        return /*collisionDetector.checkSafeToInsert(source: self, with: gameObject) &&*/ checkNoIntersection(with: gameObject) && checkBorders()
    }

    func rotateTopPoint(rotationAngle: Double) -> Point {
        let newX = initialTop.xCoord + circumradius * sin(rotationAngle)
        let newY = initialTop.yCoord + circumradius * (1 - cos(rotationAngle))
        return Point(xCoord: newX, yCoord: newY)
    }

    override func changeOrientation(to end: Double) {
        orientation = end
        let newTop = rotateTopPoint(rotationAngle: end)

        let rightX = newTop.xCoord + top.distance(to: right) * cos(end + Double.pi / 3)
        let rightY = newTop.yCoord + top.distance(to: right) * sin(end + Double.pi / 3)
        let newRight = Point(xCoord: rightX, yCoord: rightY)

        let leftX = newTop.xCoord + top.distance(to: left) * cos(end + 2 * Double.pi / 3)
        let leftY = newTop.yCoord + top.distance(to: left) * sin(end + 2 * Double.pi / 3)
        let newLeft = Point(xCoord: leftX, yCoord: leftY)

        top = newTop
        left = newLeft
        right = newRight
        polygon = [top, left, right]
        initEdges()
    }

    override func makeDeepCopy() -> Sharp {
        Sharp(center: self.center, name: self.name, circumradius: self.circumradius, orientation: self.orientation)
    }
}



/*
func transformTriangleRotation(entityId: String, to angle: Double) {
    guard let entity = manager?.entityMap[entityId] else {
        return
    }
    changeOrientation(entity: entity, angle: angle)
}

func rotateTopPoint(top: Point, circumradius: Double, angle: Double) -> Point {
    let newX = top.xCoord + circumradius * sin(angle)
    let newY = top.yCoord + circumradius * (1 - cos(angle))
    return Point(xCoord: newX, yCoord: newY)
}

func changeOrientation(entity: Entity, angle: Double) {
    guard var vertices = entity.shape.vertices else {
        return
    }
    var top = vertices[0]
    var right = vertices[1]
    var left = vertices[2]

    let newTop = rotateTopPoint(top: top, circumradius: entity.shape.halfLength, angle: angle)

    let rightX = newTop.xCoord + top.distance(to: right) * cos(angle + Double.pi / 3)
    let rightY = newTop.yCoord + top.distance(to: right) * sin(angle + Double.pi / 3)
    let newRight = Point(xCoord: rightX, yCoord: rightY)

    let leftX = newTop.xCoord + top.distance(to: left) * cos(angle + 2 * Double.pi / 3)
    let leftY = newTop.yCoord + top.distance(to: left) * sin(angle + 2 * Double.pi / 3)
    let newLeft = Point(xCoord: leftX, yCoord: leftY)

    vertices[0] = newTop
    vertices[1] = newRight
    vertices[2] = newLeft
    initEdges()
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
*/
