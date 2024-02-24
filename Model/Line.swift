//
//  Line.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation

import Foundation

struct Line: Codable {

    static private(set) var zero = Line(start: Point(xCoord: 0.0, yCoord: 0.0),
                                        end: Point(xCoord: 0.0, yCoord: 0.0))

    private(set) var start: Point
    private(set) var end: Point

    init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }

    var squaredLength: Double {
        start.squareDistance(to: end)
    }

    func minimumDistanceFromPointSquared(_ point: Point) -> Double {
        let firstVector = start.subtract(point: point)
        let secondVector = end.subtract(point: point)
        let crossProduct = firstVector.crossProduct(with: secondVector)
        let minimumDistanceFromCircleToLineSquared = (crossProduct * crossProduct) / squaredLength
        return minimumDistanceFromCircleToLineSquared
    }

    func projectionOfPointOntoLineIsOnLine(_ point: Point) -> Bool {
        let startVector = start.subtract(point: point)
        let endVector = end.subtract(point: point)
        let startToEnd = end.subtract(point: start)

        let startDotProduct = startVector.dotProduct(with: startToEnd)
        let endDotProduct = endVector.dotProduct(with: startToEnd)

        return startDotProduct < 0 && endDotProduct < 0
    }


    func pointsLieOnSameSide(_ start: Point, _ end: Point) -> Bool {
        let firstCrossProduct = self.end.subtract(point: self.start)
            .crossProduct(with: start.subtract(point: self.start))

        let secondCrossProduct = self.end.subtract(point: self.start)
            .crossProduct(with: end.subtract(point: self.start))

        return firstCrossProduct * secondCrossProduct >= 0
    }
}
