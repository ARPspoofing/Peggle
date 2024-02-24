//
//  TriangleMovableObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

// TODO: Abstract out intersection to intersection handler

import Foundation
protocol TriangularMovableObject: MovableObject, Polygon {
    var top: Point { get set }
    var left: Point { get set }
    var right: Point { get set }
    var edges: [Line] { get set }
}

extension TriangularMovableObject {

     func isIntersecting(with peg: CircularMovableObject) -> Bool {
        let squaredRadius = peg.radius * peg.radius
        for edge in edges {
            guard peg.center.squareDistance(to: edge.start) >= squaredRadius else {
                return true
            }
            guard distanceFromPointToLine(point: peg.center, line: edge) >= peg.radius else {
                return true
            }
        }
        return false
    }

    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        let lineVector = Vector(horizontal: line.end.xCoord - line.start.xCoord, vertical: line.end.yCoord - line.start.yCoord)
        let pointVector = Vector(horizontal: point.xCoord - line.start.xCoord, vertical: point.yCoord - line.start.yCoord)

        let lineLength = calculateVectorLength(vector: lineVector)

        guard lineLength != 0 else {
            return handleZeroLineLength()
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
        return -1
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

     func edgeIsIntersectingWithPeg(edge: Line, peg: Peg) -> Bool {
        guard edge.projectionOfPointOntoLineIsOnLine(peg.center) else {
            return false
        }
        let squaredRadius = peg.radius * peg.radius
        let minimumDistanceFromPegToLineSquared = edge.minimumDistanceFromPointSquared(peg.center)
        let edgeIsIntersectingPeg = minimumDistanceFromPegToLineSquared <= squaredRadius
        return edgeIsIntersectingPeg
    }

     func circleInsideTriangle(peg: CircularMovableObject) -> Bool {
        pointIsInsideTriangle(point: peg.center)
            && min(edges[0].squaredLength, edges[1].squaredLength, edges[2].squaredLength)
            > peg.radius * peg.radius
    }

     func pointIsInsideTriangle(point: Point) -> Bool {
        let area0rig = abs((left.xCoord - top.xCoord) * (right.yCoord - top.yCoord)
                           - (right.xCoord - top.xCoord) * (left.yCoord - top.yCoord))
        let area1 = abs((top.xCoord - point.xCoord) * (left.yCoord - point.yCoord)
                        - (left.xCoord - point.xCoord) * (top.yCoord - point.yCoord))
        let area2 = abs((left.xCoord - point.xCoord) * (right.yCoord - point.yCoord)
                        - (right.xCoord - point.xCoord) * (left.yCoord - point.yCoord))
        let area3 = abs((right.xCoord - point.xCoord) * (top.yCoord - point.yCoord)
                        - (top.xCoord - point.xCoord) * (right.yCoord - point.yCoord))
        return area1 + area2 + area3 == area0rig
    }

     func isNotIntersecting(with triangle: TriangularMovableObject) -> Bool {
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
        print("check no intersection within triangle")
        if let sharp = gameObject as? TriangularMovableObject {
            return isNotIntersecting(with: sharp)
        } else if let circle = gameObject as? Peg {
            return !(isIntersecting(with: circle) || circleInsideTriangle(peg: circle))
        } else {
            return true
        }
    }
}

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

    /*
    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        print("triangle check being called")
        return checkNoIntersection(with: gameObject) && checkBorders()
    }
    */

    func getArea() -> Double {
        0.5 * base * height
    }
}
