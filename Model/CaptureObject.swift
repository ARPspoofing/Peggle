//
//  CaptureObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

import Foundation
import SwiftUI

@objc(CaptureObject)
class CaptureObject: MotionObject {
    
    var width: Double = Constants.defaultCircleDiameter * 4.0
    var height: Double = Constants.defaultCircleDiameter * 2.0
    var topLine: Line = Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))
    var leftLine: Line = Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))
    var rightLine: Line = Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))
    var topLeft = Point(xCoord: 0.0, yCoord: 0.0)
    var topRight = Point(xCoord: 0.0, yCoord: 0.0)
    var bottomLeft = Point(xCoord: 0.0, yCoord: 0.0)
    var bottomRight = Point(xCoord: 0.0, yCoord: 0.0)

    var edges: [Line] = []

    override init(name: String) {
        super.init(name: name)
        self.velocity = Vector(horizontal: 3.0, vertical: 0)
        self.radius = width / 2
    }
    
    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        self.velocity = Vector(horizontal: 3.0, vertical: 0)
        self.radius = width / 2
        calcTopLine()
    }
    
    override init(center: Point, name: String, velocity: Vector) {
        super.init(center: center, name: name, velocity: velocity)
        self.radius = width / 2
        calcTopLine()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    // TODO: Tidy Up
    func calcTopLine() {
        let top: Point = center.subtract(vector: Vector(horizontal: 0.0, vertical: Constants.defaultCircleDiameter))
        let topLeft: Point = top.subtract(vector: Vector(horizontal: Constants.defaultCircleDiameter * 2, vertical: 0.0))
        let topRight: Point = top.add(vector: Vector(horizontal: Constants.defaultCircleDiameter * 2, vertical: 0.0))
        topLine = Line(start: topLeft, end: topRight)

        self.bottomLeft = topLeft.add(vector: Vector(horizontal: 0.0, vertical: Constants.defaultCircleDiameter))
        self.bottomRight = topRight.add(vector: Vector(horizontal: 0.0, vertical: Constants.defaultCircleDiameter))
        self.topLeft = topLeft
        self.topRight = topRight

        edges = [topLine, leftLine, rightLine]
    }

    /*
    // TODO: Tidy Up
    func isIntersecting(with object: CircularMovableObject) -> Bool {

        /*
        guard object.center.squareDistance(to: topLine.start) >= (object.radius * object.radius) else {
            return true
        }
        guard topLine.distanceFromPointToLine(point: object.center) >= object.radius else {
            return true
        }
        return false
        */

        let squaredRadius = object.radius * object.radius
        for edge in edges {
            guard object.center.squareDistance(to: edge.start) >= squaredRadius else {
                return true
            }
            guard edge.distanceFromPointToLine(point: object.center) >= object.radius else {
                return true
            }

            var vectorA = topLeft.subtract(point: object.center)
            var vectorB = topLeft.subtract(point: topRight)
            var dotA = vectorA.dotProduct(with: vectorB)
            var dotB = vectorB.dotProduct(with: vectorB)
            var vectorC = topLeft.subtract(point: bottomLeft)
            var dotC = vectorA.dotProduct(with: vectorC)
            var dotD = vectorC.dotProduct(with: vectorC)

            if 0 <= dotA && dotA <= dotB && 0 <= dotC && dotC <= dotD {
                return true
            }
            /*
            else {
                return false
            }

            vectorA = topRight.subtract(point: object.center)
            vectorB = topRight.subtract(point: topLeft)
            dotA = vectorA.dotProduct(with: vectorB)
            dotB = vectorB.dotProduct(with: vectorB)
            vectorC = topRight.subtract(point: bottomRight)
            dotC = vectorA.dotProduct(with: vectorC)
            dotD = vectorC.dotProduct(with: vectorC)

            if 0 <= dotA && dotA <= dotB && 0 <= dotC && dotC <= dotD {
                return true
            } else {
                return false
            }
            */
        }
        return false
    }
    */
    
    override func makeDeepCopy() -> CaptureObject {
        CaptureObject(center: self.center, name: self.name, velocity: self.velocity)
    }
}
