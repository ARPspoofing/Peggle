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
    var polygon: [Point] { get set }
}

extension TriangularMovableObject {

    func isIntersecting(with peg: CircularMovableObject) -> Bool {
        let squaredRadius = peg.radius * peg.radius
        for edge in edges {
            guard peg.center.squareDistance(to: edge.start) >= squaredRadius else {
                return true
            }
            guard peg.center.squareDistance(to: edge.end) >= squaredRadius else {
                return true
            }
            guard distanceFromPointToLine(point: peg.center, line: edge) >= peg.radius else {
                return true
            }
        }
        return false
    }

    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        line.distanceFromPointToLine(point: point)
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
         let result = pointIsInsideTriangle(point: peg.center)
     && min(edges[0].squaredLength, edges[1].squaredLength, edges[2].squaredLength)
     > peg.radius * peg.radius
         print(result)
         return result
     }

    func pointIsInsideTriangle(point: Point) -> Bool {
        let totalArea = triangleArea(left: left, top: top, right: right)
        let area1 = triangleArea(left: top, top: left, right: point)
        let area2 = triangleArea(left: left, top: right, right: point)
        let area3 = triangleArea(left: right, top: top, right: point)
        return area1 + area2 + area3 == totalArea
    }

    func triangleArea(left: Point, top: Point, right: Point) -> Double {
        abs((left.xCoord - top.xCoord) * (right.yCoord - top.yCoord)
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

    /*
    func checkStartEndIntersect(_ point1: Point, _ point2: Point, _ point3: Point) -> Bool {
        (point3.yCoord - point1.yCoord) * (point2.xCoord - point1.xCoord) >
        (point2.yCoord - point1.yCoord) * (point3.xCoord - point1.xCoord)
    }

    func linesIntersect(line1: Line, line2: Line) -> Bool {
        checkStartEndIntersect(line1.start, line2.start, line2.end) !=
        checkStartEndIntersect(line1.end, line2.start, line2.end) &&
        checkStartEndIntersect(line1.start, line1.end, line2.start) !=
        checkStartEndIntersect(line1.start, line1.end, line2.end)
    }

    func pointOnLine(point: Point, line: Line) -> Bool {
        (point.xCoord >= min(line.start.xCoord, line.end.xCoord) &&
         point.xCoord <= max(line.start.xCoord, line.end.xCoord)) &&
        (point.yCoord >= min(line.start.yCoord, line.end.yCoord) &&
         point.yCoord <= max(line.start.yCoord, line.end.yCoord))
    }

    func isNotIntersecting(with object: Polygon) -> Bool {
        for edge in edges {
            for objectEdge in object.edges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }
        guard self.edges[0].end.xCoord < object.edges[1].start.xCoord
                && self.edges[1].start.xCoord > object.edges[0].end.xCoord
                && self.edges[0].end.yCoord < object.edges[1].start.yCoord
                && self.edges[1].start.yCoord > object.edges[0].end.yCoord else {
            return true
        }
        return false
    }

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let object = gameObject as? CircularMovableObject {
            return !(isIntersecting(with: object))
        } else if let object = gameObject as? Polygon {
            return isNotIntersecting(with: object)
        } else {
            return true
        }
    }
    */

    func distanceToEdge(from point: Point, to edge: Line) -> CGFloat {
            let p1 = edge.start
            let p2 = edge.end
            let x1 = p1.xCoord, y1 = p1.yCoord
            let x2 = p2.xCoord, y2 = p2.yCoord
            let x = point.xCoord, y = point.yCoord

            let numerator = abs((x2 - x1) * (y1 - y) - (x1 - x) * (y2 - y1))
            let denominator = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
            return numerator / denominator
        }

    func circleCanEnter(circle: CircularMovableObject) -> Bool {
        for i in 0..<polygon.count {
            let j = (i + 1) % polygon.count
            let distance = distanceToEdge(from: circle.center, to: Line(start: polygon[i], end: polygon[j]))
            if distance < circle.radius {
                return false
            }
        }
        return true
    }

    ///*
    func circleIsInsideTriangle(peg: CircularMovableObject) -> Bool {
        let center = peg.center
        let centrex = center.xCoord
        let centrey = center.yCoord
        let v1x = left.xCoord
        let v1y = left.yCoord
        let v2x = top.xCoord
        let v2y = top.yCoord
        let v3x = right.xCoord
        let v3y = right.yCoord
        if ((v2x - v1x)*(centrey - v1y) - (v2y - v1y)*(centrex - v1x)) >= 0 &&
           ((v3x - v2x)*(centrey - v2y) - (v3y - v2y)*(centrex - v2x)) >= 0 &&
           ((v1x - v3x)*(centrex - v3x) - (v1y - v3y)*(centrex - v3x)) >= 0{
            print("true")
            return true
        } else {
            print("false")
            return false
        }
    }
    //*/

    func contains(circle: CircularMovableObject) -> Bool {
        let center = CGPoint(x: circle.center.xCoord, y: circle.center.yCoord)
        let radius = circle.radius

        if polygon.count <= 1 {
            return false
        }
        if pointInsidePolygon(center) {
            return true
        }
        return false
    }


    func pointInsidePolygon(_ point: CGPoint) -> Bool {
        var points = polygon
        let nvert = polygon.count
        var c = false

        var j = nvert - 1
        for i in 0..<nvert {
            if ((points[i].yCoord <= point.y) != (points[j].yCoord <= point.y))
                && (point.x <= (points[j].xCoord - points[i].xCoord)
                    * (point.y - points[i].yCoord) / (points[j].yCoord - points[i].yCoord)
                    + points[i].xCoord) {
                c = !c
            }
            j = i
        }
        return c
    }

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let sharp = gameObject as? TriangularMovableObject {
            return isNotIntersecting(with: sharp)
        } else if let circle = gameObject as? CircularMovableObject {
            return !(isIntersecting(with: circle) || contains(circle: circle))
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
        self.center.yCoord - self.circumradius > Constants.topWidth
    }

    func getArea() -> Double {
        0.5 * base * height
    }
}

extension Array where Element == Point {
    func minX() -> CGFloat {
        return self.min(by: { $0.xCoord < $1.xCoord })!.xCoord
    }

    func maxX() -> CGFloat {
        return self.max(by: { $0.xCoord < $1.xCoord })!.xCoord
    }

    func minY() -> CGFloat {
        return self.min(by: { $0.yCoord < $1.yCoord })!.yCoord
    }

    func maxY() -> CGFloat {
        return self.max(by: { $0.yCoord < $1.yCoord })!.yCoord
    }
}
