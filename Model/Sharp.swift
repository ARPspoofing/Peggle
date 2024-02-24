//
//  Sharp.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

// TODO: Encapsulate top, left, right into a class, make construction of top, left, and right neater
// TODO: Make everything private
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
        // TODO: Fix initial points when center is changed
        initialTop = center.add(vector: Vector(horizontal: 0.0, vertical: -circumradius))
        initialLeft = center.add(vector: Vector(horizontal: -circumradius, vertical: circumradius))
        initialRight = center.add(vector: Vector(horizontal: circumradius, vertical: circumradius))
        initPoints()
        initEdges()
    }

    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        return checkNoIntersection(with: gameObject) && checkBorders()
    }

    /*
    func rotatePoint(point: Point, angleInRadians: Double, centerPoint: Point) -> Point {
        // Calculate sine and cosine of the angle
        let sine = sin(angleInRadians)
        let cosine = cos(angleInRadians)

        // Calculate new coordinates based on rotation formula
        let newX = centerPoint.xCoord + (point.xCoord - centerPoint.xCoord) * cosine - (point.yCoord - centerPoint.yCoord) * sine
        let newY = centerPoint.yCoord + (point.yCoord - centerPoint.yCoord) * cosine + (point.xCoord - centerPoint.xCoord) * sine

        return Point(xCoord: newX, yCoord: newY)
    }
    */

    /*
    func rotatePoint(point: Point, angleInRadians: Double, centerPoint: Point) -> Point {
        // Calculate sine and cosine of the angle
        let sine = sin(angleInRadians)
        let cosine = cos(angleInRadians)

        // Calculate new coordinates based on rotation formula
        let newX = centerPoint.xCoord + (point.xCoord - centerPoint.xCoord) * cosine - (point.yCoord - centerPoint.yCoord) * sine
        let newY = centerPoint.yCoord + (point.yCoord - centerPoint.yCoord) * cosine + (point.xCoord - centerPoint.xCoord) * sine

        return Point(xCoord: newX, yCoord: newY)
    }
    */

    func rotateTopPointOnCircle(initialX: Double, initialY: Double, rotationAngle: Double, radius: Double) -> (Double, Double) {
        let newX = initialX + radius * sin(rotationAngle)
        let newY = initialY + radius * (1 - cos(rotationAngle))
        return (newX, newY)
    }

    func rotateLeftPointOnCircle(initialX: Double, initialY: Double, rotationAngle: Double, radius: Double) -> (Double, Double) {
        var adjustedAngle = rotationAngle - (2 * Double.pi / 3)
        if adjustedAngle > Double.pi {
            adjustedAngle -= 2 * Double.pi
        }
        //var adjustedAngle = rotationAngle
        let newX = initialX + radius * sin(adjustedAngle)
        let newY = initialY + radius * (1 - cos(adjustedAngle))
        return (newX, newY)
    }

    /*
    func calculateLeftPoint(topX: Double, topY: Double, rotationAngle: Double, radius: Double) -> (Double, Double) {
        // Calculate the new coordinates for the left point
        let leftRotationAngle = rotationAngle - (Double.pi / 2) // Rotate clockwise by 90 degrees
        let leftX = topX + radius * sin(leftRotationAngle)
        let leftY = topY - radius * (1 - cos(leftRotationAngle)) // Negative due to inverted y-axis
        return (leftX, leftY)
    }

    func calculateRightPoint(topX: Double, topY: Double, rotationAngle: Double, radius: Double) -> (Double, Double) {
        // Calculate the new coordinates for the right point
        let rightRotationAngle = rotationAngle + (Double.pi / 2) // Rotate counterclockwise by 90 degrees
        let rightX = topX + radius * sin(rightRotationAngle)
        let rightY = topY - radius * (1 - cos(rightRotationAngle)) // Negative due to inverted y-axis
        return (rightX, rightY)
    }

    func rotateRightPointOnCircle(initialX: Double, initialY: Double, rotationAngle: Double, radius: Double) -> (Double, Double) {
        // Calculate the new angle after rotation
        let newAngle = rotationAngle

        // Calculate the new coordinates using trigonometric functions
        /*
        var newX = center.xCoord + radius * cos(newAngle)
        var newY = center.yCoord + radius * sin(newAngle)
        */

        var newX = initialX + radius * sin(newAngle)
        var newY = initialY + radius * (1 - cos(newAngle))

        return (newX, newY)
    }

    func rotateLeftPointOnCircle(initialX: Double, initialY: Double, rotationAngle: Double, radius: Double) -> (Double, Double) {
        // Calculate the new angle after rotation
        let newAngle = rotationAngle

        // Calculate the new coordinates using trigonometric functions
        /*
        var newX = center.xCoord + radius * cos(newAngle)
        var newY = center.yCoord + radius * sin(newAngle)
        */

        var newX = initialX + radius * sin(newAngle)
        var newY = initialY + radius * (1 - cos(newAngle))

        return (newX, newY)
    }
    */

    /*
    func rotateTopPoint(center: Point, top: Point, angleInRadians: Double) -> Point {
        // Calculate the differences between the top point and the center point
        let dx = top.xCoord - center.xCoord
        let dy = top.yCoord - center.yCoord

        // Calculate the new coordinates after rotation using rotation formulas
        let newX = center.xCoord + (dx * cos(angleInRadians)) - (dy * sin(angleInRadians))
        let newY = center.yCoord + (dx * sin(angleInRadians)) + (dy * cos(angleInRadians))

        // Return the new coordinates of the top point after rotation
        return Point(xCoord: newX, yCoord: newY)
    }

    func rotateRightPoint(center: Point, right: Point, angleInRadians: Double) -> Point {
        // Calculate the differences between the right point and the center point
        let dx = right.xCoord - center.xCoord
        let dy = right.yCoord - center.yCoord

        // Calculate the new coordinates after rotation using rotation formulas
        let newX = center.xCoord + (dx * cos(angleInRadians)) - (dy * sin(angleInRadians))
        let newY = center.yCoord + (dx * sin(angleInRadians)) + (dy * cos(angleInRadians))

        // Return the new coordinates of the right point after rotation
        return Point(xCoord: newX, yCoord: newY)
    }

    func rotateLeftPoint(center: Point, left: Point, angleInRadians: Double) -> Point {
        // Calculate the differences between the left point and the center point
        let dx = left.xCoord - center.xCoord
        let dy = left.yCoord - center.yCoord

        // Calculate the new coordinates after rotation using rotation formulas
        let newX = center.xCoord + (dx * cos(angleInRadians)) - (dy * sin(angleInRadians))
        let newY = center.yCoord + (dx * sin(angleInRadians)) + (dy * cos(angleInRadians))

        // Return the new coordinates of the left point after rotation
        return Point(xCoord: newX, yCoord: newY)
    }
    */

    override func changeOrientation(to end: Double) {
        orientation = end
        // Rotate each point
        /*
        let newTop = rotatePoint(point: top, angleInRadians: angle, centerPoint: center)
        let newLeft = rotatePoint(point: left, angleInRadians: angle, centerPoint: center)
        let newRight = rotatePoint(point: right, angleInRadians: angle, centerPoint: center)
        */

        /*
        let newTop = rotatePoint(point: top, angleInRadians: angle, centerPoint: center)
        let newRight = rotatePoint(point: right, angleInRadians: angle, centerPoint: center)
        let newLeft = rotatePoint(point: left, angleInRadians: angle, centerPoint: center)
        */
        //print("New coordinates of the top point after rotation: \(newTop)")

        var newTop = Point(xCoord: 0.0, yCoord: 0.0)
        var newRight = Point(xCoord: 0.0, yCoord: 0.0)
        var newLeft = Point(xCoord: 0.0, yCoord: 0.0)
        var topX, topY, rightX, rightY, leftX, leftY: Double


        (topX, topY) = rotateTopPointOnCircle(initialX: initialTop.xCoord, initialY: initialTop.yCoord, rotationAngle: end, radius: 25)

        newTop.setCartesian(xCoord: topX, yCoord: topY)

        (rightX, rightY) = rotateLeftPointOnCircle(initialX: initialRight.xCoord, initialY: initialRight.yCoord, rotationAngle: end, radius: 25)

        rightX = topX + top.distance(to: right) * cos(end + Double.pi / 3)
        rightY = topY + top.distance(to: right) * sin(end + Double.pi / 3)

        newRight.setCartesian(xCoord: rightX, yCoord: rightY)

        (leftX, leftY) = rotateLeftPointOnCircle(initialX: initialLeft.xCoord, initialY: initialLeft.yCoord, rotationAngle: end, radius: 25)

        leftX = topX + top.distance(to: left) * cos(end + 2 * Double.pi / 3)
        leftY = topY + top.distance(to: left) * sin(end + 2 * Double.pi / 3)

        newLeft.setCartesian(xCoord: leftX, yCoord: leftY)

        /*
        (rightX, rightY) = rotateTopPointOnCircle(initialX: initialRight.xCoord, initialY: initialRight.yCoord, rotationAngle: end - Double.pi / 2, radius: 25)

        newRight.setCartesian(xCoord: rightX, yCoord: rightY)

        (leftX, leftY) = rotateTopPointOnCircle(initialX: initialLeft.xCoord, initialY: initialLeft.yCoord, rotationAngle: end, radius: 25)

        newLeft.setCartesian(xCoord: leftX, yCoord: leftY)
        */

        /*
        (leftX, leftY) = calculateLeftPoint(topX: newTop.xCoord, topY: newTop.yCoord, rotationAngle: end, radius: 25)

        newLeft.setCartesian(xCoord: leftX, yCoord: leftY)

        (rightX, rightY) = calculateRightPoint(topX: newTop.xCoord, topY: newTop.yCoord, rotationAngle: end, radius: 25)

        newRight.setCartesian(xCoord: rightX, yCoord: rightY)
        */

        /*
         let newTop = rotatePoint(point: top, angleInRadians: angle, centerPoint: center)
         let newRight = rotatePoint(point: right, angleInRadians: angle, centerPoint: center)
         let newLeft = rotatePoint(point: left, angleInRadians: angle, centerPoint: center)
        // Update your triangle points with the new rotated positions
        print("top x: ", top.xCoord, "new top x: ", newTop.xCoord)
        print("left x: ", left.xCoord, "new left x: ", newLeft.xCoord)
        print("right x: ", right.xCoord, "new right x: ", newRight.xCoord)
        print("top y: ", top.yCoord, "new top y: ", newTop.yCoord)
        print("left y: ", left.yCoord, "new left y: ", newLeft.yCoord)
        print("right y: ", right.yCoord, "new right y: ", newRight.yCoord)
        */

        top = newTop
        left = newLeft
        right = newRight
        initEdges()
    }

    override func makeDeepCopy() -> Sharp {
        Sharp(center: self.center, name: self.name, circumradius: self.circumradius)
    }
}
