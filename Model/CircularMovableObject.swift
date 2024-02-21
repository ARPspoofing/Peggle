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

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let peg = gameObject as? CircularMovableObject {
            let distanceBetweenMotionObjectSquared: Double = center.squareDistance(to: peg.center)
            let sumMotionObjectsRadiusSquared: Double = (radius + peg.radius) * (radius + peg.radius)
            return distanceBetweenMotionObjectSquared > sumMotionObjectsRadiusSquared
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
        self.center.yCoord - self.radius > 0
    }

    func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        checkNoIntersection(with: gameObject) && checkBorders()
    }

    func getArea() -> Double {
        Double.pi * radius * radius
    }

    func isOutOfBounds(point: Point) -> Bool {
        let newArea = Double.pi * center.squareDistance(to: point)
        return newArea > getArea()
    }

}
