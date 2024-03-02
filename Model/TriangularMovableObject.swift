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
        return line.distanceFromPointToLine(point: point)
    }

     func edgeIsIntersectingWithPeg(edge: Line, peg: CircularMovableObject) -> Bool {
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
        let totalArea = triangleArea(left: left, top: top, right: right)
        let area1 = triangleArea(left: top, top: left, right: point)
        let area2 = triangleArea(left: left, top: right, right: point)
        let area3 = triangleArea(left: right, top: top, right: point)
        return area1 + area2 + area3 == totalArea
    }

    func triangleArea(left: Point, top: Point, right: Point) -> Double {
        return abs((left.xCoord - top.xCoord) * (right.yCoord - top.yCoord)
                   - (right.xCoord - top.xCoord) * (left.yCoord - top.yCoord))
    }

    func isNotIntersecting(with triangle: TriangularMovableObject) -> Bool {
        checkEdgeIntersection(with: triangle) || triangle.checkEdgeIntersection(with: self)
    }

    func checkEdgeIntersection(with triangle: TriangularMovableObject) -> Bool {
        let points: [Point] = [top, left, right]
        for edge in self.edges {
            if let nonParticipatingPoint = points
                .first(where: { $0 != edge.start && $0 != edge.end }) {
                if (edge.pointsLieOnSameSide(triangle.top, triangle.left)
                    && edge.pointsLieOnSameSide(triangle.left, triangle.right))
                    && !(edge.pointsLieOnSameSide(triangle.top, nonParticipatingPoint)) {
                    return true
                }
            }
        }
        return false
    }

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let sharp = gameObject as? TriangularMovableObject {
            return isNotIntersecting(with: sharp)
        } else if let circle = gameObject as? CircularMovableObject {
            return !(isIntersecting(with: circle) || circleInsideTriangle(peg: circle))
        } else if let obstacle = gameObject as? RectangularMovableObject {
            return obstacle.isNotIntersecting(with: self)
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

    func getArea() -> Double {
        0.5 * base * height
    }
}
