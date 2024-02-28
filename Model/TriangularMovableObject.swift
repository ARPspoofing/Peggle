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
        /*
        let area0rig = abs((left.xCoord - top.xCoord) * (right.yCoord - top.yCoord)
                           - (right.xCoord - top.xCoord) * (left.yCoord - top.yCoord))
        let area1 = abs((top.xCoord - point.xCoord) * (left.yCoord - point.yCoord)
                        - (left.xCoord - point.xCoord) * (top.yCoord - point.yCoord))
        let area2 = abs((left.xCoord - point.xCoord) * (right.yCoord - point.yCoord)
                        - (right.xCoord - point.xCoord) * (left.yCoord - point.yCoord))
        let area3 = abs((right.xCoord - point.xCoord) * (top.yCoord - point.yCoord)
                        - (top.xCoord - point.xCoord) * (right.yCoord - point.yCoord))
        return area1 + area2 + area3 == area0rig
        */

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

    /*
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
     */

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

    func checkEdgeIntersection(with triangle: TriangularMovableObject, points: [Point]) -> Bool {
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


    /*
    func isNotIntersecting(with triangle: TriangularMovableObject) -> Bool {
        return !intersectsEdges(with: triangle) && !triangle.intersectsEdges(with: self)
    }

    private func intersectsEdges(with triangle: TriangularMovableObject) -> Bool {
        return intersectsEdges(selfEdges: edges, selfPoints: [top, left, right], otherPoints: [triangle.top, triangle.left, triangle.right])
    }

    private func intersectsEdges(selfEdges: [Line], selfPoints: [Point], otherPoints: [Point]) -> Bool {
        for edge in selfEdges {
            if let nonParticipatingPoint = selfPoints.first(where: { $0 != edge.start && $0 != edge.end }) {
                if isOnSameSide(edge: edge, points: otherPoints) && !isOnSameSide(edge: edge, points: [nonParticipatingPoint]) {
                    return true
                }
            }
        }
        return false
    }

    private func isOnSameSide(edge: Line, points: [Point]) -> Bool {
        return edge.pointsLieOnSameSide(points[0], points[1]) && edge.pointsLieOnSameSide(points[1], points[2])
    }
    */

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let sharp = gameObject as? TriangularMovableObject {
            return isNotIntersecting(with: sharp)
        } else if let circle = gameObject as? CircularMovableObject {
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

    func getArea() -> Double {
        0.5 * base * height
    }
}
