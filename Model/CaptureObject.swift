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
    var topLine = Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))
    var leftLine = Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))
    var rightLine = Line(start: Point(xCoord: 0.0, yCoord: 0.0), end: Point(xCoord: 0.0, yCoord: 0.0))
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
    
    func calcTopLine() {
        let top: Point = center.subtract(vector: Vector(horizontal: 0.0, vertical: Constants.defaultCircleDiameter))
        let topLeft: Point = top.subtract(vector:
                                            Vector(horizontal: Constants.defaultCircleDiameter * 2,
                                                   vertical: 0.0))
        let topRight: Point = top.add(vector: Vector(horizontal: Constants.defaultCircleDiameter * 2, vertical: 0.0))
        topLine = Line(start: topLeft, end: topRight)

        self.bottomLeft = topLeft.add(vector: Vector(horizontal: 0.0, vertical: Constants.defaultCircleDiameter))
        self.bottomRight = topRight.add(vector: Vector(horizontal: 0.0, vertical: Constants.defaultCircleDiameter))
        self.topLeft = topLeft
        self.topRight = topRight

        edges = [topLine, leftLine, rightLine]
    }

    override func makeDeepCopy() -> CaptureObject {
        CaptureObject(center: self.center, name: self.name, velocity: self.velocity)
    }
}
