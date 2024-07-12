//
//  CollisionDetector.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

struct CollisionDetector {
    func checkSafeToInsert(source object: GameObject, with gameObject: GameObject) -> Bool {
        if let object = object as? RectangularMovableObject, let gameObject = gameObject as? RectangularMovableObject {
            return isNotIntersecting(source: object, with: gameObject)
        } else if let object = object as? RectangularMovableObject, let gameObject = gameObject as? TriangularMovableObject {
            return isNotIntersectingRT(source: object, with: gameObject)
        } else if let object = object as? TriangularMovableObject, let gameObject = gameObject as? RectangularMovableObject {
            return isNotIntersectingTR(source: object, with: gameObject)
        } else if let object = object as? TriangularMovableObject, let gameObject = gameObject as? TriangularMovableObject {
            return isNotIntersectingTT(source: object, with: gameObject)
        } else if let object = object as? RectangularMovableObject {
            return !isIntersecting(source: object, with: gameObject)
        } else if let object = object as? TriangularMovableObject {
            return !isIntersectingT(source: object, with: gameObject)
        } else if let gameObject = gameObject as? RectangularMovableObject {
            return !isIntersecting(source: gameObject, with: object)
        } else if let gameObject = gameObject as? TriangularMovableObject {
            return !isIntersectingT(source: gameObject, with: object)
        } else {
            return !isOverlap(source: object, with: gameObject)
        }
        /*
        !isNotIntersecting(source: object, with: gameObject)
        && isIntersecting(source: object, with: gameObject)
        && isOverlap(source: object, with: gameObject)
        */
    }

    // Non-Polygon - Non-Polygon Intersection (both do not contain edges)
    func isOverlap(source object: GameObject, with gameObject: GameObject) -> Bool {
        let distanceObjectSquared: Double = object.center.squareDistance(to: gameObject.center)
        let sumHalfLengthSquared: Double = (object.halfWidth + gameObject.halfWidth)
        * (object.halfWidth + gameObject.halfWidth)
        return distanceObjectSquared > sumHalfLengthSquared
    }

    // Polygon - Non-Polygon Intersection (one contains edges)
    func isIntersecting(source object: RectangularMovableObject, with gameObject: GameObject) -> Bool {
        /*
        guard let edges = gameObject.edges ?? object.edges else {
            return false
        }
        return checkEdgePointIntersection(edges: edges, source: object, with: gameObject)
        */
        return checkEdgePointIntersection(edges: object.edges, source: object, with: gameObject)
    }

    func isIntersectingT(source object: TriangularMovableObject, with gameObject: GameObject) -> Bool {
        /*
        guard let edges = gameObject.edges ?? object.edges else {
            return false
        }
        return checkEdgePointIntersection(edges: edges, source: object, with: gameObject)
        */
        return checkEdgePointIntersectionT(edges: object.edges, source: object, with: gameObject)
    }

    func checkEdgePointIntersectionT(edges: [Line], source object: TriangularMovableObject, with gameObject: GameObject) -> Bool {
        let squaredLength = gameObject.halfWidth * gameObject.halfWidth
        let objectCenter = gameObject.center

        for edge in edges {
            guard objectCenter.squareDistance(to: edge.start) >= squaredLength else {
                return true
            }
            guard distanceFromPointToLine(point: objectCenter, line: edge) >= gameObject.halfWidth else {
                return true
            }
        }
        return false
    }

    // TODO: Check with CircularMovableObject as well
    func checkEdgePointIntersection(edges: [Line], source object: RectangularMovableObject, with gameObject: GameObject) -> Bool {
        let squaredLength = gameObject.halfWidth * gameObject.halfWidth
        let objectCenter = gameObject.center

        for edge in edges {
            guard objectCenter.squareDistance(to: edge.start) >= squaredLength else {
                return true
            }
            guard distanceFromPointToLine(point: objectCenter, line: edge) >= gameObject.halfWidth else {
                return true
            }
        }
        return false
    }

    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        line.distanceFromPointToLine(point: point)
    }

    // Polygon - Polygon Intersection (both contains edges)
    func isNotIntersecting(source object: RectangularMovableObject, with gameObject: RectangularMovableObject) -> Bool {

        let edges = object.edges
        let objectEdges = gameObject.edges

        for edge in edges {
            for objectEdge in objectEdges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }
        guard edges[0].end.xCoord < objectEdges[1].start.xCoord
                && edges[1].start.xCoord > objectEdges[0].end.xCoord
                && edges[0].end.yCoord < objectEdges[1].start.yCoord
                && edges[1].start.yCoord > objectEdges[0].end.yCoord else {
            return true
        }
        return false
    }

    func isNotIntersectingRT(source object: RectangularMovableObject, with gameObject: TriangularMovableObject) -> Bool {

        let edges = object.edges
        let objectEdges = gameObject.edges

        for edge in edges {
            for objectEdge in objectEdges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }
        guard edges[0].end.xCoord < objectEdges[1].start.xCoord
                && edges[1].start.xCoord > objectEdges[0].end.xCoord
                && edges[0].end.yCoord < objectEdges[1].start.yCoord
                && edges[1].start.yCoord > objectEdges[0].end.yCoord else {
            return true
        }
        return false
    }

    func isNotIntersectingTR(source object: TriangularMovableObject, with gameObject: RectangularMovableObject) -> Bool {

        let edges = object.edges
        let objectEdges = gameObject.edges

        for edge in edges {
            for objectEdge in objectEdges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }
        guard edges[0].end.xCoord < objectEdges[1].start.xCoord
                && edges[1].start.xCoord > objectEdges[0].end.xCoord
                && edges[0].end.yCoord < objectEdges[1].start.yCoord
                && edges[1].start.yCoord > objectEdges[0].end.yCoord else {
            return true
        }
        return false
    }

    func isNotIntersectingTT(source object: TriangularMovableObject, with gameObject: TriangularMovableObject) -> Bool {

        let edges = object.edges
        let objectEdges = gameObject.edges

        for edge in edges {
            for objectEdge in objectEdges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }
        guard edges[0].end.xCoord < objectEdges[1].start.xCoord
                && edges[1].start.xCoord > objectEdges[0].end.xCoord
                && edges[0].end.yCoord < objectEdges[1].start.yCoord
                && edges[1].start.yCoord > objectEdges[0].end.yCoord else {
            return true
        }
        return false
    }

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

}
