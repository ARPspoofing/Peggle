//
//  TriangularMovableObjectDup.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
//import UIKit
protocol TriangularMovableObjectDup: MovableObject, Polygon {
    var top: Point { get set }
    var left: Point { get set }
    var right: Point { get set }
    var edges: [Line] { get set }
    var polygon: [Point] { get set }
}

extension TriangularMovableObjectDup {

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

    func isNotIntersecting(with triangle: TriangularMovableObjectDup) -> Bool {
        checkEdgeIntersection(with: triangle) || triangle.checkEdgeIntersection(with: self)
    }

    func checkEdgeIntersection(with triangle: TriangularMovableObjectDup) -> Bool {
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

    /*
    func circleIsInsideTriangle(peg: CircularMovableObject) -> Bool {
        var center = peg.center
        var centrex = center.xCoord
        var centrey = center.yCoord
        var v1x = top.xCoord
        var v1y = top.yCoord
        var v2x = right.xCoord
        var v2y = right.yCoord
        var v3x = left.xCoord
        var v3y = left.yCoord
        var c1x = centrex - v1x
        var c1y = centrey - v1y

        var radiusSqr = peg.radius*peg.radius
        var c1sqr = c1x*c1x + c1y*c1y - radiusSqr

        if c1sqr <= 0 {
            return true
        }

        var c2x = centrex - v2x
        var c2y = centrey - v2y
        var c2sqr = c2x*c2x + c2y*c2y - radiusSqr

        if c2sqr <= 0 {
            return true
        }

        var c3x = centrex - v3x
        var c3y = centrey - v3y

        var c3sqr = radiusSqr
        c3sqr = c3x*c3x + c3y*c3y - radiusSqr

        if c3sqr <= 0 {
            return true
        }

        var e1x = v2x - v1x
        var e1y = v2y - v1y

        var e2x = v3x - v2x
        var e2y = v3y - v2y

        var e3x = v1x - v3x
        var e3y = v1y - v3y
        /*
        if abs((e1y*c1x - e1x*c1y) | (e2y*c2x - e2x*c2y) | (e3y*c3x - e3x*c3y)) >= 0 {
            return true
        }

        var k = c1x*e1x + c1y*e1y

        if k > 0
        {
          len = e1x*e1x + e1y*e1y

          if k < len
          {
            if c1sqr * len <= k*k
              return true
          }
        }

        k = c2x*e2x + c2y*e2y

        if k > 0
        {
          len = e2x*e2x + e2y*e2y

          if k < len
          {
            if c2sqr * len <= k*k
              return true
          }
        }

        k = c3x*e3x + c3y*e3y

        if k > 0
        {
          len = e3x*e3x + e3y*e3y

          if k < len
          {
            if c3sqr * len <= k*k
              return true
          }
        }
        */

        return false
    }
    */

    /*
    func circumcircleRadius() -> CGFloat {
        let minX = polygon.min(by: { $0.xCoord < $1.xCoord })!.xCoord
        let maxX = polygon.max(by: { $0.xCoord < $1.xCoord })!.xCoord
        let minY = polygon.min(by: { $0.yCoord < $1.yCoord })!.yCoord
        let maxY = polygon.max(by: { $0.yCoord < $1.yCoord })!.yCoord

        let centerX = (minX + maxX) / 2
        let centerY = (minY + maxY) / 2

        var maxDistanceSquared: CGFloat = 0
        for vertex in polygon {
            let distanceSquared = pow(vertex.xCoord - centerX, 2) + pow(vertex.yCoord - centerY, 2)
            if distanceSquared > maxDistanceSquared {
                maxDistanceSquared = distanceSquared
            }
        }

        return sqrt(maxDistanceSquared)
    }

    func circleCanEnter(peg: CircularMovableObject) -> Bool {
        let circumcircleRadius = circumcircleRadius()
        print(peg.radius < circumcircleRadius)
        return peg.radius < circumcircleRadius
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

    /*
    func contains(point: Point) -> Bool {
        var test = CGPoint(x: point.xCoord, y: point.yCoord)
        if polygon.count <= 1 {
            return false
        }

        var p = UIBezierPath()
        let firstPoint = CGPoint(x: polygon[0].xCoord, y: polygon[0].yCoord)

        p.move(to: firstPoint)

        for index in 1...polygon.count-1 {
            p.addLine(to: CGPoint(x: polygon[index].xCoord, y: polygon[index].yCoord))
        }

        p.close()
        print(p.contains(test))
        return p.contains(test)
    }
    */

    /*
    func contains(circle: CircularMovableObject) -> Bool {
        let center = CGPoint(x: circle.center.xCoord, y: circle.center.yCoord)
        let radius = circle.radius

        if polygon.count <= 1 {
            return false
        }

        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)

        var polygonPath = UIBezierPath()
        let firstPoint = CGPoint(x: polygon[0].xCoord, y: polygon[0].yCoord)
        polygonPath.move(to: firstPoint)

        for index in 1..<polygon.count {
            let nextPoint = CGPoint(x: polygon[index].xCoord, y: polygon[index].yCoord)
            polygonPath.addLine(to: nextPoint)
        }

        polygonPath.close()

        return polygonPath.contains(circlePath.bounds)
    }
    */

    func contains(circle: CircularMovableObject) -> Bool {
        //print("start of contains", circle.center)
        let center = CGPoint(x: circle.center.xCoord, y: circle.center.yCoord)
        //print("center", center)
        let radius = circle.radius

        if polygon.count <= 1 {
            return false
        }

        // Sample points along the circumference of the circle
        let samplePoints = 360 // Adjust the number of points for better accuracy
        let deltaAngle = 2 * CGFloat.pi / CGFloat(samplePoints)

        for i in 0..<samplePoints {
            let angle = CGFloat(i) * deltaAngle
            let x = center.x + radius * cos(CGFloat(angle))
            let y = center.y + radius * sin(CGFloat(angle))
            let testPoint = CGPoint(x: x, y: y)

            // Check if the test point is inside the polygon
            if pointInsidePolygon(testPoint) {
                //print("point inside")
                return true
            }

            /*
            // Check if the circle's circumference intersects with any edge of the polygon
            for edge in edges {
                if pointToLineDistance(point: center, lineStart: edge.start, lineEnd: edge.end) <= radius {
                    print("intersecting!!")
                    return true
                }
            }
            */

        }
        //print("point not inside")
        return false
    }

    func pointToLineDistance(point: CGPoint, lineStart: Point, lineEnd: Point) -> CGFloat {
        let dx = CGFloat(lineEnd.xCoord - lineStart.xCoord)
        let dy = CGFloat(lineEnd.yCoord - lineStart.yCoord)
        let mag = dx * dx + dy * dy
        let dotProduct = (CGFloat(point.x - lineStart.xCoord) * dx + CGFloat(point.y - lineStart.yCoord) * dy) / mag

        let projectionX: CGFloat
        let projectionY: CGFloat
        if dotProduct < 0 {
            projectionX = CGFloat(lineStart.xCoord)
            projectionY = CGFloat(lineStart.yCoord)
        } else if dotProduct <= 1 {
            projectionX = CGFloat(lineStart.xCoord) + dotProduct * dx
            projectionY = CGFloat(lineStart.yCoord) + dotProduct * dy
        } else {
            projectionX = CGFloat(lineEnd.xCoord)
            projectionY = CGFloat(lineEnd.yCoord)
        }

        let distance = sqrt(pow(CGFloat(point.x) - projectionX, 2) + pow(CGFloat(point.y) - projectionY, 2))
        return distance
    }

    func pointInsidePolygon(_ point: CGPoint) -> Bool {
        let point = CGPoint(x: round(point.x * 10) / 10, y: round(point.y * 10) / 10)
        var points = polygon
        let nvert = polygon.count
        print("nvert", nvert, point.x, point.y)
        print("first point", points[0].xCoord, points[0].yCoord)
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
        print("point inside status", c)
        return c
    }

    func pointInPolygon(point: Point) -> Bool {
        var points = polygon
        var i = polygon.count
        var j = polygon.count
        var nvert = polygon.count
        var c = false

        j = nvert - 1
        for i in 0..<nvert {
            if ((points[i].yCoord <= point.yCoord) != (points[j].yCoord <= point.yCoord))
                && (point.xCoord <= (points[j].xCoord - points[i].xCoord)
                    * (point.yCoord - points[i].yCoord) / (points[j].yCoord - points[i].yCoord)
                    + points[i].xCoord) {
                c = !c
            }
            j = i
        }
        if c == false {
            print(left.xCoord, left.yCoord, top.xCoord, top.yCoord, right.xCoord, right.yCoord, point.xCoord, point.yCoord)
        }

        return c
    }

    func checkNoIntersection(with gameObject: GameObject) -> Bool {
        if let sharp = gameObject as? TriangularMovableObjectDup {
            return isNotIntersecting(with: sharp)
        } else if let circle = gameObject as? CircularMovableObject {
            //print("triangle - circle")
            return !(isIntersecting(with: circle) || contains(circle: circle))
        } else if let obstacle = gameObject as? RectangularMovableObject {
            return obstacle.isNotIntersecting(with: self)
        } else {
            return true
        }
    }
}

extension TriangularMovableObjectDup {

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

/*
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
*/
