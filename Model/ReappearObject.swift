//
//  ReappearObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 28/2/24.
//

import Foundation

@objc(ReappearObject)
class ReappearObject: Peg, StateChangeObject {

    var velocity = Vector(horizontal: 0.0, vertical: 0.0)

    init(center: Point, name: String, radius: Double) {
        super.init(center: center, name: name)
        self.radius = radius
    }

    override init(center: Point, name: String, radius: Double, orientation: Double) {
        super.init(center: center, name: name)
        self.radius = radius
        self.orientation = orientation
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
