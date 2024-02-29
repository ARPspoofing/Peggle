//
//  GameObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

import UIKit

class GameObject: NSObject, Identifiable, Codable, DisappearObject {

    private(set) var id = UUID()
    var name: String

    var center = Point(xCoord: 0.0, yCoord: 0.0)
    // TODO: Fix orientation and halfWidth, add init for width
    var orientation: Double = 0.0
    @objc dynamic var halfWidth: Double = Constants.defaultHalfWidth
    var initialTop: Point = Point(xCoord: 0.0, yCoord: 0.0)

    // TODO: Abstract this out
    var isBlast = false
    var isSpook = false
    var hasBlasted = false
    var activeIdx = 0


    var isActive = false

    var isHandleOverlap = false
    var isDisappear = false
    var handleOverlapCount = 0

    let initialWidth: Double = 25.0
    let maxWidth: Double = 50.0
    let minDistance: Double = 0.0
    let maxDistance: Double = 200.0

    init(name: String) {
        self.name = name
    }

    init(center: Point, name: String) {
        self.center = center
        self.name = name
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? GameObject else {
            return false
        }
        return id == rhs.id
    }

    func changeCenter(newCenter: Point) {
        center.setCartesian(xCoord: newCenter.xCoord, yCoord: newCenter.yCoord)
    }

    func changeHalfWidth(newHalfWidth: Double) {
        halfWidth = newHalfWidth
    }

    func retrieveXCoord() -> Double {
        center.xCoord
    }

    func retrieveYCoord() -> Double {
        center.yCoord
    }

    func centerVector() -> Vector {
        center.convertToVector()
    }

    func checkBorders() -> Bool {
        true
    }

    func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        true
    }

    func changeOrientation(to end: Double) {
        orientation = end
    }

    func distance(to object: GameObject) -> Double {
        self.center.distance(to: object.center)
    }

    func calcDistance(point: CGPoint) -> Double {
        let newPoint = Point(xCoord: point.x, yCoord: point.y)
        let deltaX = newPoint.xCoord - center.xCoord
        let deltaY = newPoint.yCoord - center.yCoord
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }

    func calcAngle(to point: CGPoint) -> Double {
        center.calcAngle(to: point)
    }

    func scaleWidth(point: CGPoint) -> Double {
        let distance = calcDistance(point: point)
        let distanceRange = maxDistance - minDistance
        let widthRange = maxWidth - initialWidth
        let normalizedDistance = (distance - minDistance) / distanceRange
        let scaledWidth = initialWidth + widthRange * normalizedDistance
        return min(scaledWidth, maxWidth)
    }

    func makeDeepCopy() -> GameObject {
        GameObject(center: self.center, name: self.name)
    }
}
