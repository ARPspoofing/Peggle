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
        let firstVector = start.subtract(vector: point.convertToVector()).convertToVector()
        let secondVector = end.subtract(vector: point.convertToVector()).convertToVector()
        let crossProduct = firstVector.crossProduct(with: secondVector)
        let minimumDistanceFromCircleToLineSquared = (crossProduct * crossProduct) / squaredLength
        return minimumDistanceFromCircleToLineSquared
    }

    func projectionOfPointOntoLineIsOnLine(_ point: Point) -> Bool {
        let startVector = start.subtract(vector: point.convertToVector()).convertToVector()
        let endVector = end.subtract(vector: point.convertToVector()).convertToVector()
        let startToEnd = end.subtract(vector: start.convertToVector()).convertToVector()

        let dotProduct1 = startVector.dotProduct(with: startToEnd)
        let dotProduct2 = endVector.dotProduct(with: startToEnd)

        return dotProduct1 < 0 && dotProduct2 < 0
    }


    func pointsLieOnSameSide(_ start: Point, _ end: Point) -> Bool {
        let firstCrossProduct = self.end.convertToVector().subtract(vector: self.start.convertToVector())
            .crossProduct(with: start.convertToVector().subtract(vector: self.start.convertToVector()))

        let secondCrossProduct = self.end.convertToVector().subtract(vector: self.start.convertToVector())
            .crossProduct(with: end.convertToVector().subtract(vector: self.start.convertToVector()))

        return firstCrossProduct * secondCrossProduct >= 0
    }
}
