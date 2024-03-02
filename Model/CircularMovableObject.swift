//
//  MovableObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

protocol CircularMovableObject: MovableObject {
    var radius: Double { get }
}

extension CircularMovableObject {
    // TODO: Clean up
    // TODO: Abstract to intersection handler
    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let peg = gameObject as? CircularMovableObject {
            let distanceBetweenMotionObjectSquared: Double = center.squareDistance(to: peg.center)
            let sumMotionObjectsRadiusSquared: Double = (radius + peg.radius) * (radius + peg.radius)
            return distanceBetweenMotionObjectSquared > sumMotionObjectsRadiusSquared
        } else if let sharp = gameObject as? TriangularMovableObject {
            return !(sharp.isIntersecting(with: self) || sharp.circleInsideTriangle(peg: self))
        } else if let obstacle = gameObject as? RectangularMovableObject {
            return !obstacle.isIntersecting(with: self)
        } else {
            return false
        }
    }

    func checkRightBorder() -> Bool {
        self.center.xCoord + self.radius < Constants.screenWidth
    }

    func checkLeftBorder() -> Bool {
        self.center.xCoord - self.radius > 0
    }

    func checkBottomBorder() -> Bool {
        self.center.yCoord + self.radius < Constants.screenHeight
    }

    func checkBottomBorderGame() -> Bool {
        self.center.yCoord + self.radius < Constants.gameHeight
    }

    func checkTopBorder() -> Bool {
        self.center.yCoord - self.radius > Constants.topWidth
    }

    func getArea() -> Double {
        Double.pi * radius * radius
    }
}
