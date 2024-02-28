//
//  RectangularMovableObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 28/2/24.
//

import Foundation

protocol RectangularMovableObject: MovableObject, Polygon {
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

    func isNotIntersecting(with triangle: TriangularMovableObject) -> Bool {
       return false
   }

    /*
   func checkNoIntersection(with gameObject: GameObject) -> Bool {
       if let sharp = gameObject as? TriangularMovableObject {
           return isNotIntersecting(with: sharp)
       } else if let circle = gameObject as? Peg {
           return !(isIntersecting(with: circle) || circleInsideTriangle(peg: circle))
       } else {
           return true
       }
   }
*/
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
