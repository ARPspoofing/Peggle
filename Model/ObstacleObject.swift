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
        removeObserver(self, forKeyPath: #keyPath(halfWidth))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(halfWidth) {
            resizePoints()
        }
    }

    func initPoints() {
        top = center.add(vector: Vector(horizontal: 0.0, vertical: -circumradius))
        topLeft = center.add(vector: Vector(horizontal: -circumradius, vertical: -circumradius))
        topRight = center.add(vector: Vector(horizontal: circumradius, vertical: -circumradius))
        bottomLeft = center.add(vector: Vector(horizontal: -circumradius, vertical: circumradius))
        bottomRight = center.add(vector: Vector(horizontal: circumradius, vertical: circumradius))
        initialTop = top
        initialTopLeft = topLeft
        initialTopRight = topRight
        initialBottomLeft = bottomLeft
        initialBottomRight = bottomRight
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
        initialTop = top
        initialTopLeft = topLeft
        initialTopRight = topRight
        initialBottomLeft = bottomLeft
        initialBottomRight = bottomRight
        addObserver(self, forKeyPath: #keyPath(halfWidth), options: [.old, .new], context: nil)
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

    // TODO: Move to physics engine
    func rotateTopPoint(rotationAngle: Double) -> Point {
        let newX = initialTop.xCoord + circumradius * sin(rotationAngle)
        let newY = (initialTop.yCoord + circumradius * (1 - cos(rotationAngle)))
        return Point(xCoord: newX, yCoord: newY)
    }

    func rotatePoint(initialPoint: Point, rotationAngle: Double) -> Point {
        let newX = initialPoint.xCoord + circumradius * sin(rotationAngle)
        let newY = (initialPoint.yCoord + circumradius * (1 - cos(rotationAngle)))
        return Point(xCoord: newX, yCoord: newY)
    }

    func rotatePointReverse(initialPoint: Point, rotationAngle: Double) -> Point {
        let newX = initialPoint.xCoord + circumradius * (1 - sin(rotationAngle))
        let newY = (initialPoint.yCoord + circumradius * (cos(rotationAngle)))
        return Point(xCoord: newX, yCoord: newY)
    }

    /*
    func rotatePoint(point: Point, rotationAngle: Double) -> Point {
        let newX = point.xCoord + circumradius * sin(rotationAngle)
        let newY = point.yCoord + circumradius * (1 - cos(rotationAngle))
        return Point(xCoord: newX, yCoord: newY)
    }
    */

    /*
    private func rotatePoint(point: Point, rotationAngle: Double) -> Point {
        let rotationAngle = rotationAngle * Double.pi / 180.0 + Double.pi / 4
        let relativeX = point.xCoord - center.xCoord
        let relativeY = point.yCoord - center.yCoord

        let rotatedX = relativeX * cos(rotationAngle) - relativeY * sin(rotationAngle)
        let rotatedY = relativeX * sin(rotationAngle) + relativeY * cos(rotationAngle)

        let newX = rotatedX + center.xCoord
        let newY = rotatedY + center.yCoord

        return Point(xCoord: newX, yCoord: newY)
    }
    */

    override func changeOrientation(to end: Double) {
        orientation = end
        /*
        let newX = initialTop.xCoord + circumradius * sin(end)
        let newY = initialTop.yCoord + circumradius * (1 - cos(end))
        top = Point(xCoord: newX, yCoord: newY)
        */

        let newTop = rotateTopPoint(rotationAngle: end)


        var rightX = newTop.xCoord + top.distance(to: bottomRight) * cos(end + Double.pi / 3)
        var rightY = newTop.yCoord + top.distance(to: bottomRight) * sin(end + Double.pi / 3)

        let newBottomRight = Point(xCoord: rightX, yCoord: rightY)

        var leftX = newTop.xCoord + top.distance(to: bottomLeft) * cos(end + 2 * Double.pi / 3)
        var leftY = newTop.yCoord + top.distance(to: bottomLeft) * sin(end + 2 * Double.pi / 3)

        let newBottomLeft = Point(xCoord: leftX, yCoord: leftY)


        let bottomLine = Line(start: newBottomRight, end: newBottomLeft)

        let perpendicularVector = bottomLine.getLineVector().getPerpendicularVector()

        let verticalDistance = bottomLine.distanceFromPointToLine(point: top)

        let verticalLineLeft = Line(start: bottomLeft, vector: perpendicularVector, maxDistance: verticalDistance)

        let verticalLineRight = Line(start: bottomRight, vector: perpendicularVector, maxDistance: verticalDistance)





        //let verticalLine = Line(start: <#T##Point#>, vector: <#T##Vector#>)

        top = newTop
        topLeft = verticalLineLeft.end
        topRight = verticalLineRight.end
        //topLeft = rotatePointReverse(initialPoint: initialTopLeft, rotationAngle: end)
        //topRight = rotatePointReverse(initialPoint: initialTopRight, rotationAngle: end)
        //bottomLeft = rotatePoint(initialPoint: initialBottomLeft, rotationAngle: end)
        //bottomRight = rotatePoint(initialPoint: initialBottomRight, rotationAngle: end)
        bottomLeft = newBottomLeft
        bottomRight = newBottomRight
        initEdges()
    }

    override func makeDeepCopy() -> ObstacleObject {
        ObstacleObject(center: self.center, name: self.name, circumradius: self.circumradius, orientation: self.orientation)
    }
}
