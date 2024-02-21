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
    var isActive = false

    var isHandleOverlap = false
    var isDisappear = false
    var handleOverlapCount = 0

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

    func retrieveXCoord() -> Double {
        center.xCoord
    }

    func retrieveYCoord() -> Double {
        center.yCoord
    }

    func centerVector() -> Vector {
        center.convertToVector()
    }

    func makeDeepCopy() -> GameObject {
        GameObject(center: self.center, name: self.name)
    }
}
