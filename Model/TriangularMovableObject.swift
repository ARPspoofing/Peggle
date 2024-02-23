//
//  TriangleMovableObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

import Foundation
protocol TriangularMovableObject: MovableObject, Polygon {
    var top: Point { get set }
    var left: Point { get set }
    var right: Point { get set }
    var edges: [Line] { get set }
}

// TODO: Reduce bloat, rename cross
extension TriangularMovableObject {

    private func isIntersecting(with peg: Peg) -> Bool {
        let squaredRadius = peg.radius * peg.radius

        for edge in edges {

            if peg.center.squareDistance(to: edge.start) < squaredRadius {
                return true
            }

            if distanceFromPointToLine(point: peg.center, line: edge) < 25 {
                print(distanceFromPointToLine(point: peg.center, line: edge))
            }


            if distanceFromPointToLine(point: peg.center, line: edge) < 25 {
                return true
            }


            /*
            if edgeIsIntersectingWithPeg(edge: edge, peg: peg) {
                return true
            }
            */
        }
        return false
    }

    /*
    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        let numerator = abs((line.end.xCoord - line.start.xCoord) * (line.start.yCoord - point.yCoord) - (line.start.xCoord - point.xCoord) * (line.end.yCoord - line.start.yCoord))
        let denominator = sqrt(pow(line.end.xCoord - line.start.xCoord, 2) + pow(line.end.yCoord - line.start.yCoord, 2))
        return numerator / denominator
    }
    */

    /*
    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        let lineVector = Vector(xCoord: line.end.xCoord - line.start.xCoord, yCoord: line.end.yCoord - line.start.yCoord)
        let pointVector = Vector(xCoord: point.xCoord - line.start.xCoord, yCoord: point.yCoord - line.start.yCoord)

        let lineLength = sqrt((lineVector.xCoord * lineVector.xCoord) + (lineVector.yCoord * lineVector.yCoord))

        // Ensure the line length is not zero to avoid division by zero
        guard lineLength != 0 else {
            return -1 // Handle this case according to your requirements
        }

        // Compute the projection of the point onto the line
        let projection = ((pointVector.xCoord * lineVector.xCoord) + (pointVector.yCoord * lineVector.yCoord)) / lineLength

        // If the projection is outside the line segment, return the distance to the closest endpoint
        if projection < 0 {
            return sqrt((point.xCoord - line.start.xCoord) * (point.xCoord - line.start.xCoord) + (point.yCoord - line.start.yCoord) * (point.yCoord - line.start.yCoord))
        } else if projection > lineLength {
            return sqrt((point.xCoord - line.end.xCoord) * (point.xCoord - line.end.xCoord) + (point.yCoord - line.end.yCoord) * (point.yCoord - line.end.yCoord))
        }

        // Compute and return the perpendicular distance from the point to the line
        let perpendicularDistance = abs((pointVector.xCoord * lineVector.yCoord - pointVector.yCoord * lineVector.xCoord) / lineLength)
        return perpendicularDistance
    }
    */

    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        let lineVector = Vector(horizontal: line.end.xCoord - line.start.xCoord, vertical: line.end.yCoord - line.start.yCoord)
        let pointVector = Vector(horizontal: point.xCoord - line.start.xCoord, vertical: point.yCoord - line.start.yCoord)

        let lineLength = calculateVectorLength(vector: lineVector)

        guard lineLength != 0 else {
            return handleZeroLineLength() // Handle this case according to your requirements
        }

        let projection = calculateProjection(pointVector: pointVector, lineVector: lineVector, lineLength: lineLength)

        if projection < 0 {
            return distanceToPoint(point: point, from: line.start)
        } else if projection > lineLength {
            return distanceToPoint(point: point, from: line.end)
        }

        return calculatePerpendicularDistance(pointVector: pointVector, lineVector: lineVector, lineLength: lineLength)
    }

    func calculateVectorLength(vector: Vector) -> Double {
        return sqrt((vector.horizontal * vector.horizontal) + (vector.vertical * vector.vertical))
    }

    func handleZeroLineLength() -> Double {
        return -1 // Handle this case according to your requirements
    }

    func calculateProjection(pointVector: Vector, lineVector: Vector, lineLength: Double) -> Double {
        return ((pointVector.horizontal * lineVector.horizontal) + (pointVector.vertical * lineVector.vertical)) / lineLength
    }

    func distanceToPoint(point: Point, from start: Point) -> Double {
        return sqrt((point.xCoord - start.xCoord) * (point.xCoord - start.xCoord) + (point.yCoord - start.yCoord) * (point.yCoord - start.yCoord))
    }

    func calculatePerpendicularDistance(pointVector: Vector, lineVector: Vector, lineLength: Double) -> Double {
        return abs((pointVector.horizontal * lineVector.vertical - pointVector.vertical * lineVector.horizontal) / lineLength)
    }




    private func edgeIsIntersectingWithPeg(edge: Line, peg: Peg) -> Bool {
        guard edge.projectionOfPointOntoLineIsOnLine(peg.center) else {
            print("edge not intersecting")
            return false
        }
        print("edge is intersecting!!!")
        let squaredRadius = peg.radius * peg.radius
        let minimumDistanceFromPegToLineSquared = edge.minimumDistanceFromPointSquared(peg.center)
        let edgeIsIntersectingPeg = minimumDistanceFromPegToLineSquared <= squaredRadius
        return edgeIsIntersectingPeg
    }

    private func pegIsInsideTriangle(peg: Peg) -> Bool {
        pointIsInsideTriangle(point: peg.center)
            && min(edges[0].squaredLength, edges[1].squaredLength, edges[2].squaredLength)
            > peg.radius * peg.radius
    }

    private func pointIsInsideTriangle(point: Point) -> Bool {
        // Check if point in polygon formula adapted from:
        // http://www.jeffreythompson.org/collision-detection/tri-point.php
        let area0rig = abs((left.xCoord - top.xCoord) * (right.yCoord - top.yCoord)
                           - (right.xCoord - top.xCoord) * (left.yCoord - top.yCoord))
        let area1 = abs((top.xCoord - point.xCoord) * (left.yCoord - point.yCoord)
                        - (left.xCoord - point.xCoord) * (top.yCoord - point.yCoord))
        let area2 = abs((left.xCoord - point.xCoord) * (right.yCoord - point.yCoord)
                        - (right.xCoord - point.xCoord) * (left.yCoord - point.yCoord))
        let area3 = abs((right.xCoord - point.xCoord) * (top.yCoord - point.yCoord)
                        - (top.xCoord - point.xCoord) * (right.yCoord - point.yCoord))
        print("point inside status: ", area1 + area2 + area3 == area0rig)
        return area1 + area2 + area3 == area0rig
    }

    private func isNotIntersecting(with triangle: TriangularMovableObject) -> Bool {
        let selfPoints = [top, left, right]
        let trianglePoints = [triangle.top, triangle.left, triangle.right]
        for edge in self.edges {
            if let nonParticipatingPoint = selfPoints
                .first(where: { $0 != edge.start && $0 != edge.end }) {
                if (edge.pointsLieOnSameSide(triangle.top, triangle.left)
                     && edge.pointsLieOnSameSide(triangle.left, triangle.right))
                    && !(edge.pointsLieOnSameSide(triangle.top, nonParticipatingPoint)) {
                    return true
                }
            }
        }
        for edge in triangle.edges {
            if let nonParticipatingPoint = trianglePoints
                .first(where: { $0 != edge.start && $0 != edge.end }) {
                if (edge.pointsLieOnSameSide(self.top, self.left)
                      && edge.pointsLieOnSameSide(self.left, self.right))
                    && !(edge.pointsLieOnSameSide(self.top, nonParticipatingPoint)) {
                    return true
                }
            }
        }
        return false
    }

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let sharp = gameObject as? TriangularMovableObject {
            return isNotIntersecting(with: sharp)
        } else if let circle = gameObject as? Peg {
            print("test peg intersection")
            //return !checkIntersectTriangle(with: circle)
            return !(isIntersecting(with: circle) || pegIsInsideTriangle(peg: circle))
        } else {
            print("elseeee")
            return true
        }
    }
}

// TODO: Change to be for triangles
extension TriangularMovableObject {

    func checkRightBorder() -> Bool {
        self.center.xCoord + self.circumradius < Constants.screenWidth
    }

    func checkLeftBorder() -> Bool {
        self.center.xCoord - self.circumradius > 0
    }

    func checkBottomBorder() -> Bool {
        self.center.yCoord + self.circumradius < Constants.screenHeight
    }

    func checkBottomBorderGame() -> Bool {
        self.center.yCoord + self.circumradius < Constants.gameHeight
    }

    func checkTopBorder() -> Bool {
        self.center.yCoord - self.circumradius > 0
    }

    func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        checkNoIntersection(with: gameObject) && checkBorders()
    }

    func getArea() -> Double {
        0.5 * base * height
    }
}
