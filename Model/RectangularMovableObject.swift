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

    func ccw(_ point1: Point, _ point2: Point, _ point3: Point) -> Bool {
        (point3.yCoord - point1.yCoord) * (point2.xCoord - point1.xCoord) > (point2.yCoord - point1.yCoord) * (point3.xCoord - point1.xCoord)
    }

    func linesIntersect(line1: Line, line2: Line) -> Bool {
        ccw(line1.start, line2.start, line2.end) != ccw(line1.end, line2.start, line2.end) && ccw(line1.start, line1.end, line2.start) != ccw(line1.start, line1.end, line2.end)
    }

    func pointOnLine(point: Point, line: Line) -> Bool {
        return (point.xCoord >= min(line.start.xCoord, line.end.xCoord) && point.xCoord <= max(line.start.xCoord, line.end.xCoord)) &&
               (point.yCoord >= min(line.start.yCoord, line.end.yCoord) && point.yCoord <= max(line.start.yCoord, line.end.yCoord))
    }

    /*
    func isNotIntersecting(with object: Polygon) -> Bool {
        for edge in object.edges {
            for side in edges {
                if linesIntersect(line1: edge, line2: side) {
                    print("is intersecting")
                    return false
                }
            }
        }
        print("is not intersecting")
        return true
    }
    */

    func isNotIntersecting(with object: Polygon) -> Bool {
        if self.edges[0].end.xCoord < object.edges[1].start.xCoord
            && self.edges[1].start.xCoord > object.edges[0].end.xCoord
            && self.edges[0].end.yCoord < object.edges[1].start.yCoord
            && self.edges[1].start.yCoord > object.edges[0].end.yCoord {
            return false
        } else {
            return true
        }
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
