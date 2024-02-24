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

    var width: Double = Constants.defaultHalfWidth
    var height: Double = Constants.defaultHalfWidth

    override init(name: String) {
        super.init(name: name)
    }

    override init(center: Point, name: String) {
        super.init(center: center, name: name)
    }

    init(center: Point, name: String, velocity: Vector, width: Double, height: Double) {
        super.init(center: center, name: name)
        self.velocity = velocity
        self.width = width
        self.height = height
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    override func makeDeepCopy() -> CaptureObject {
        CaptureObject(center: self.center, name: self.name, velocity: self.velocity, width: self.width, height: self.height)
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
