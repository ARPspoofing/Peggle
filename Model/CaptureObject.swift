//
//  CaptureObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

import Foundation
import SwiftUI

@objc(CaptureObject)
class CaptureObject: MotionObject {

    var width: Double = Constants.defaultCircleDiameter * 4.0
    var height: Double = Constants.defaultCircleDiameter * 2.0

    override init(name: String) {
        super.init(name: name)
        self.velocity = Vector(horizontal: 3.0, vertical: 0)
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
        self.velocity = Vector(horizontal: 3.0, vertical: 0)
    }

    override init(center: Point, name: String, velocity: Vector) {
        super.init(center: center, name: name, velocity: velocity)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func makeDeepCopy() -> CaptureObject {
        CaptureObject(center: self.center, name: self.name, velocity: self.velocity)
    }

    // TODO: Make it override or bring it to another protocol to make it seem less hackish
    func checkRightBorder() -> Bool {
        center.xCoord + width / 2 < Constants.screenWidth
    }

    func checkLeftBorder() -> Bool {
        center.xCoord - width / 2 > 0
    }

    func checkBottomBorder() -> Bool {
        center.yCoord + height < Constants.screenHeight
    }

    func checkBottomBorderGame() -> Bool {
        center.yCoord + height < Constants.gameHeight
    }

    func checkTopBorder() -> Bool {
        center.yCoord - height > 0
    }
}
