//
//  Peg.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

// TODO: Check if peg needs to conform to game object
@objc(Peg)
class Peg: GameObject {
    
    var radius: Double {
        get {
            return super.halfWidth
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

    init(center: Point, name: String, radius: Double) {
        super.init(center: center, name: name)
        self.radius = radius
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func checkBorders() -> Bool {
        checkRightBorder() && checkLeftBorder() && checkBottomBorder() && checkTopBorder()
    }

    override func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        return checkNoIntersection(with: gameObject) && checkBorders()
    }

    override func makeDeepCopy() -> Peg {
        Peg(center: self.center, name: self.name, radius: self.radius)
    }
}

extension Peg: CircularMovableObject {

    func getArea() -> Double {
        Double.pi * radius * radius
    }
}
