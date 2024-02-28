//
//  Line.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation

struct Line: Codable {

    static private(set) var zero = Line(start: Point(xCoord: 0.0, yCoord: 0.0),
                                        end: Point(xCoord: 0.0, yCoord: 0.0))

    private(set) var start: Point = Point(xCoord: 0.0, yCoord: 0.0)
    private(set) var end: Point = Point(xCoord: 0.0, yCoord: 0.0)
    private(set) var vector = Vector(horizontal: 0.0, vertical: 0.0)

    init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }

    init(start: Point, vector: Vector) {
        self.start = start
        self.vector = vector
        self.end = calculateEndPoint()
    }

    var squaredLength: Double {
        start.squareDistance(to: end)
    }

    var length: Double {
        sqrt(squaredLength)
    }

    func squaredDistance(_ distance: Double) -> Double {
        distance * distance
    }

    func calculateEndPoint() -> Point {
        let normalizedVector = vector.normalize()
        let maxDistance = Constants.screenHeight
        var endPointX = start.xCoord + normalizedVector.horizontal * maxDistance
        var endPointY = start.yCoord + normalizedVector.vertical * maxDistance
        if endPointX < 0 {
            endPointX = 0
            endPointY = recalculateEndPoint(normalizedVector)
        }
        return Point(xCoord: endPointX, yCoord: endPointY)
    }

    func recalculateEndPoint(_ vector: Vector) -> Double {
        return start.yCoord - (start.xCoord / vector.horizontal) * vector.vertical
    }

    func squaredDistanceFromPointToLine(point: Point) -> Double {
        let yDistance = end.yCoord - start.yCoord
        let xDistance = end.xCoord - start.xCoord
        let endStartDistanceX = end.xCoord * start.yCoord
        let endStartDistanceY = end.yCoord * start.xCoord
        let numerator = yDistance * point.xCoord - xDistance * point.yCoord + endStartDistanceX - endStartDistanceY
        let squaredNumerator = squaredDistance(numerator)
        let squaredLength = squaredDistance(xDistance) + squaredDistance(yDistance)
        return squaredNumerator / squaredLength
    }

    func getLineVector() -> Vector {
        end.subtract(point: start)
    }

    func getLinePointVector(point: Point) -> Vector {
        point.subtract(point: start)
    }

    func distanceFromPointToLine(point: Point) -> Double {
        let lineVector = getLineVector()
        let pointVector = getLinePointVector(point: point)

        guard length != 0 else {
            return handleZeroLineLength()
        }
        let projection = calculateProjection(pointVector: pointVector, lineVector: lineVector)
        if projection < 0 {
            return distanceToPoint(point: point, from: start)
        } else if projection > length {
            return distanceToPoint(point: point, from: end)
        }
        return calculatePerpendicularDistance(pointVector: pointVector, lineVector: lineVector)
    }

    func calculateVectorLength(vector: Vector) -> Double {
        return sqrt((vector.horizontal * vector.horizontal) + (vector.vertical * vector.vertical))
    }

    func handleZeroLineLength() -> Double {
        return -1
    }

    func calculateProjection(pointVector: Vector, lineVector: Vector) -> Double {
        return ((pointVector.horizontal * lineVector.horizontal) + (pointVector.vertical * lineVector.vertical)) / length
    }

    func distanceToPoint(point: Point, from start: Point) -> Double {
        return sqrt((point.xCoord - start.xCoord) * (point.xCoord - start.xCoord) + (point.yCoord - start.yCoord) * (point.yCoord - start.yCoord))
    }

    func calculatePerpendicularDistance(pointVector: Vector, lineVector: Vector) -> Double {
        return abs((pointVector.horizontal * lineVector.vertical - pointVector.vertical * lineVector.horizontal) / length)
    }

    func isPointNearLine(point: Point, range: Double) -> Bool {
        let squaredDistanceToLine = squaredDistanceFromPointToLine(point: point)
        print(squaredDistanceToLine, range)
        return squaredDistanceToLine <= range
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
