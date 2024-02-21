//
//  Point.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

/*
 Import foundation for sin, cos and tan, since it was mentioned in
 Lecture 3.1-Objects and Data Structure Page 2 that Polar coordinates
 have to be implemented to not force rectangular coordinates
*/
import Foundation

struct Point: Codable {

    private var originX = 0.0
    private var originY = 0.0
    private var lowerBound: CGFloat = -Double.pi
    private var upperBound: CGFloat = Double.pi

    private(set) var xCoord: Double
    private(set) var yCoord: Double

    private(set) var radial: Double
    private(set) var theta: Double

    init(xCoord: Double, yCoord: Double) {

        if xCoord >= 0 && yCoord >= 0 {
            self.xCoord = xCoord
            self.yCoord = yCoord
        } else {
            self.xCoord = originX
            self.yCoord = originY
        }

        (self.radial, self.theta) = Point.calculatePolarFromCartesian(xCoord: xCoord, yCoord: yCoord)
        assert(checkRepresentation())
    }

    init(radial: Double, theta: Double) {
        self.radial = radial
        self.theta = theta
        (self.xCoord, self.yCoord) = Point.calculateCartesianFromPolar(radial: radial, theta: theta)
        assert(checkRepresentation())
    }

    mutating func setCartesian(xCoord: Double, yCoord: Double) {
        assert(checkRepresentation())
        self.xCoord = xCoord
        self.yCoord = yCoord
        (self.radial, self.theta) = Point.calculatePolarFromCartesian(xCoord: xCoord, yCoord: yCoord)
        assert(checkRepresentation())
    }

    mutating func setPolar(radial: Double, theta: Double) {
        assert(checkRepresentation())
        self.radial = radial
        self.theta = theta
        (self.xCoord, self.yCoord) = Point.calculateCartesianFromPolar(radial: radial, theta: theta)
        assert(checkRepresentation())
    }

    private static func calculatePolarFromCartesian(xCoord: Double, yCoord: Double) -> (Double, Double) {
        let radial = sqrt(xCoord * xCoord + yCoord * yCoord)
        let theta = atan2(yCoord, xCoord)
        return (radial, theta)
    }

    private static func calculateCartesianFromPolar(radial: Double, theta: Double) -> (Double, Double) {
        let xCoord = radial * cos(theta)
        let yCoord = radial * sin(theta)
        return (xCoord, yCoord)
    }

    func convertToVector() -> Vector {
        Vector(horizontal: xCoord, vertical: yCoord)
    }

    func add(vector: Vector) -> Point {
        assert(checkRepresentation())
        return Point(xCoord: self.xCoord + vector.horizontal, yCoord: self.yCoord + vector.vertical)
    }

    func subtract(vector: Vector) -> Point {
        assert(checkRepresentation())
        return Point(xCoord: self.xCoord - vector.horizontal, yCoord: self.yCoord - vector.vertical)
    }

    func squareDistance(to point: Point) -> Double {
        assert(checkRepresentation())
        let horizontalDistance = self.xCoord - point.xCoord
        let verticalDistance = self.yCoord - point.yCoord
        assert(checkRepresentation())
        return horizontalDistance * horizontalDistance + verticalDistance * verticalDistance
    }
}

extension Point: Equatable {
static func == (lhs: Point, rhs: Point) -> Bool {
    lhs.xCoord == rhs.xCoord && lhs.yCoord == rhs.yCoord
    && lhs.radial == rhs.radial && lhs.theta == rhs.theta
    }
}

extension Point {
    private func checkValidCartersianCenter() -> Bool {
        guard xCoord >= 0 && yCoord >= 0 else {
            return false
        }
        return true
    }

    private func checkValidPolarCenter() -> Bool {
        guard radial >= 0 && lowerBound <= theta
                && theta <= upperBound else {
            return false
        }
        return true
    }

    private func checkRepresentation() -> Bool {
        checkValidPolarCenter() && checkValidCartersianCenter()
    }
}

extension Point: Hashable {
}
