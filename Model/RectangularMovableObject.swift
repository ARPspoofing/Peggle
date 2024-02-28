//
//  RectangularMovableObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 28/2/24.
//

import Foundation

protocol RectangularMovableObject: MovableObject, Polygon {
    var top: Point { get set }
    var topLeft: Point { get set }
    var topRight: Point { get set }
    var bottomLeft: Point { get set }
    var bottomRight: Point { get set }
    var edges: [Line] { get set }
}

extension RectangularMovableObject {

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

    func linesIntersect(line1: Line, line2: Line) -> Bool {
        let p = line1.start
        let q = line2.start
        let r = Point(xCoord: line1.end.xCoord - p.xCoord, yCoord: line1.end.yCoord - p.yCoord)
        let s = Point(xCoord: line2.end.xCoord - q.xCoord, yCoord: line2.end.yCoord - q.yCoord)

        let denominator = calculateDenominator(r: r, s: s)
        let numerator1 = calculateNumerator1(q: q, p: p, s: s)
        let numerator2 = calculateNumerator2(q: q, p: p, r: r)

        if denominator == 0 {
            return areLinesParallel(line1: line1, line2: line2)
        }

        let t = numerator1 / denominator
        let u = numerator2 / denominator

        return t >= 0 && t <= 1 && u >= 0 && u <= 1
    }

    func calculateDenominator(r: Point, s: Point) -> Double {
        return r.xCoord * s.yCoord - r.yCoord * s.xCoord
    }

    func calculateNumerator1(q: Point, p: Point, s: Point) -> Double {
        return (q.yCoord - p.yCoord) * s.xCoord - (q.xCoord - p.xCoord) * s.yCoord
    }

    func calculateNumerator2(q: Point, p: Point, r: Point) -> Double {
        return (q.xCoord - p.xCoord) * r.yCoord - (q.yCoord - p.yCoord) * r.xCoord
    }

    func areLinesParallel(line1: Line, line2: Line) -> Bool {
        return (line1.end.yCoord - line1.start.yCoord) / (line1.end.xCoord - line1.start.xCoord) == (line2.end.yCoord - line2.start.yCoord) / (line2.end.xCoord - line2.start.xCoord)
    }

    func pointOnLine(point: Point, line: Line) -> Bool {
        return (point.xCoord >= min(line.start.xCoord, line.end.xCoord) && point.xCoord <= max(line.start.xCoord, line.end.xCoord)) &&
               (point.yCoord >= min(line.start.yCoord, line.end.yCoord) && point.yCoord <= max(line.start.yCoord, line.end.yCoord))
    }

    func isNotIntersecting(with object: Polygon) -> Bool {
        for edge in object.edges {
            for side in edges {
                if linesIntersect(line1: edge, line2: side) {
                    return true
                }
            }
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
}

extension RectangularMovableObject {

   func checkRightBorder() -> Bool {
       self.center.xCoord + self.base / 2 < Constants.screenWidth
   }

   func checkLeftBorder() -> Bool {
       self.center.xCoord - self.base / 2 > 0
   }

   func checkBottomBorder() -> Bool {
       self.center.yCoord + self.height / 2 < Constants.screenHeight
   }

   func checkBottomBorderGame() -> Bool {
       self.center.yCoord + self.height / 2 < Constants.gameHeight
   }

   func checkTopBorder() -> Bool {
       self.center.yCoord - self.height / 2 > 0
   }

   func getArea() -> Double {
       base * height
   }
}
