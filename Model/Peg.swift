//
//  Peg.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

@objc(Peg)
class Peg: GameObject {

    var radius: Double {
        get {
            super.halfWidth
        }
        set(newValue) {
            super.halfWidth = newValue
        }
    }

    override init(name: String) {
        super.init(name: name)
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
    }

    init(center: Point, name: String, radius: Double, orientation: Double) {
        super.init(center: center, name: name)
        self.radius = radius
        self.orientation = orientation
    }

    init(center: Point, name: String, radius: Double, orientation: Double, isBlast: Bool) {
        super.init(center: center, name: name)
        self.radius = radius
        self.orientation = orientation
        self.isBlast = isBlast
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        let collisionDetector = CollisionDetector()
        //return collisionDetector.checkSafeToInsert(source: self, with: gameObject)
        return checkNoIntersection(with: gameObject) && checkBorders()
    }

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let peg = gameObject as? CircularMovableObject {
            let distanceBetweenMotionObjectSquared: Double = center.squareDistance(to: peg.center)
            let sumMotionObjectsRadiusSquared: Double = (radius + peg.radius) * (radius + peg.radius)
            return distanceBetweenMotionObjectSquared > sumMotionObjectsRadiusSquared
        } else if let sharp = gameObject as? TriangularMovableObject {
            return /*!(sharp.isIntersecting(with: self)
                    || /*sharp.circleInsideTriangle(peg: self)*/sharp.pointInPolygon(point: center))*/
            //!(sharp.isIntersecting(with: self) || sharp.contains(circle: self))
            //sharp.checkNoIntersection(with: self)

            //!(sharp.isIntersecting(with: self) || sharp.contains(circle: self))
            sharp.checkSafeToInsert(with: self)

        } else if let obstacle = gameObject as? RectangularMovableObject {
            return !obstacle.isIntersecting(with: self)
        } else {
            return false
        }
    }

    override func makeDeepCopy() -> Peg {
        Peg(center: self.center, name: self.name, radius: self.radius, orientation: self.orientation)
    }
}

extension Peg: CircularMovableObject {

    func getArea() -> Double {
        Double.pi * radius * radius
    }
}
