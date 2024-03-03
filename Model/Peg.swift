//
//  Peg.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

@objc(Peg)
class Peg: GameObject {

    var radius: Double {
        get {
            super.halfWidth
        }
        set(newValue) {
            super.halfWidth = newValue
        }
    }

    override init(name: String) {
        super.init(name: name)
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
    }

    init(center: Point, name: String, radius: Double, orientation: Double) {
        super.init(center: center, name: name)
        self.radius = radius
        self.orientation = orientation
    }

    init(center: Point, name: String, radius: Double, orientation: Double, isBlast: Bool) {
        super.init(center: center, name: name)
        self.radius = radius
        self.orientation = orientation
        self.isBlast = isBlast
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        checkNoIntersection(with: gameObject) && checkBorders()
    }

    override func makeDeepCopy() -> Peg {
        Peg(center: self.center, name: self.name, radius: self.radius, orientation: self.orientation)
    }
}

extension Peg: CircularMovableObject {

    func getArea() -> Double {
        Double.pi * radius * radius
    }
}
