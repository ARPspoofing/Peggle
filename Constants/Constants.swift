//
//  Constants.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

import SwiftUI

struct Constants {
    // MARK: Alpha Constants
    static let selectedAlpha: CGFloat = 1.0
    static let unselectedAlpha: CGFloat = 0.3

    // MARK: Color Constants
    static let clear = Color.clear
    static let white = Color.white
    static let black = Color.black
    static let blue = Color.blue
    static let yellow = Color.yellow
    static let red = Color.red
    static let orange = Color.orange
    static let pink = Color.pink
    static let grey = Color.gray
    static let lightGrey = Color(UIColor.lightGray)
    static let customGrey = Color(red: 242, green: 242, blue: 247)
    static let desertLightBrown = Color(red: 209/255, green: 188/255, blue: 140/255)
    static let desertDarkBrown = Color(red: 195/255, green: 169/255, blue: 114/255)
    static let rustBrown = Color(red: 108/255, green: 55/255, blue: 68/255)
    static let lightBlue = Color(red: 117 / 255, green: 251 / 255, blue: 253 / 255)
    static let lightOrange = Color(red: 240 / 255, green: 200 / 255, blue: 200 / 255)
    static let darkOrange = Color(red: 252 / 255, green: 169 / 255, blue: 3 / 255)
    static let lightPurple = Color(red: 191 / 255, green: 144 / 255, blue: 223 / 255)
    static let purple = Color(red: 148 / 255, green: 0 / 255, blue: 211 / 255)
    static let lightGreen = Color(red: 144/255, green: 238/255, blue: 144/255)
    static let green = Color(red: 0/255, green: 128/255, blue: 0/255)
    static let lightPink = Color(red: 255 / 255, green: 182 / 255, blue: 193 / 255)
    static let gold = Color(red: 255 / 255, green: 215 / 255, blue: 0 / 255)
    static let lightGray = Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255)

    // MARK: Button Constants
    static let deleteButtonScale: CGFloat = 0.4
    static let deleteSize = screenHeight * 0.1

    // MARK: Screen Constants
    static var screenWidth = UIScreen.main.bounds.size.width
    static var gameHeight = UIScreen.main.bounds.size.height
    static var canvasHeight = UIScreen.main.bounds.size.height * 0.8
    static var screenHeight = UIScreen.main.bounds.size.height * 0.8
    static var paletteHeight = UIScreen.main.bounds.size.height * 0.15
    static var activeHeight = UIScreen.main.bounds.size.height * 0.1
    static let defaultHalfWidth: CGFloat = 25

    // MARK: Circle Constants
    static let defaultCircleRadius: CGFloat = 25
    static let defaultCircleDiameter: CGFloat = 50
    static let maxCircleRadius: CGFloat = 40
    static let minCircleRadius: CGFloat = 18
    static let roundedRadius: CGFloat = 20
    static let radius: CGFloat = 10
    static let topWidth: CGFloat = 50

    // MARK: Image Constants
    static let normalObject = "normalObject"
    static let actionObject = "actionObject"
    static let sharpObject = "sharpBlock"
    static let sharp = "Sharp"
    static let pointed = "sharp"
    static let obstacle = "obstacle"
    static let delete = "delete"
    static let background = "background"
    static let motionObject = "motionObject"
    static let captureObject = "captureObject"
    static let oscillateObject = "oscillateObject"
    static let reappearObject = "reappearObject"
    static let obstacleObject = "obstacleObject"
    static let actionObjectSharp = "actionObjectSharp"
    static let bounceObject = "bounceObject"
    static let bounceObjectSharp = "bounceObjectSharp"
    static let glowObject = "glowObject"
    static let motionObjectSharp = "motionObjectSharp"
    static let normalObjectSharp = "normalObjectSharp"
    static let oscillateObjectSharp = "oscillateObjectSharp"
    static let reappearObjectSharp = "reappearObjectSharp"
    static let solidObject = "solidObject"
    static let solidObjectSharp = "solidObjectSharp"
    static let shooterBase = "shooterBase"
    static let shooterHead = "shooterHead"
    static let none = "none"
    static let paletteObjects = [Constants.normalObject, Constants.actionObject,
                                 Constants.oscillateObject, Constants.reappearObject,
                                 Constants.glowObject, Constants.solidObject,
                                 Constants.bounceObject, Constants.obstacleObject,
                                 Constants.normalObjectSharp, Constants.actionObjectSharp,
                                 Constants.oscillateObjectSharp, Constants.reappearObjectSharp,
                                 Constants.motionObjectSharp, Constants.solidObjectSharp,
                                 Constants.bounceObjectSharp, Constants.sharpObject]

    // MARK: Active Image Constants
    static let normalObjectActive = "normalObjectActive"
    static let actionObjectActive = "actionObjectActive"
    static let sharpObjectActive = "sharpBlockActive"
    static let oscillateObjectActive = "oscillateObjectActive"
    static let reappearObjectActive = "reappearObjectActive"
    static let obstacleObjectActive = "obstacleObjectActive"
    static let actionObjectSharpActive = "actionObjectSharpActive"
    static let bounceObjectActive = "bounceObjectActive"
    static let bounceObjectSharpActive = "bounceObjectSharpActive"
    static let glowObjectActive = "glowObjectActive"
    static let motionObjectSharpActive = "motionObjectSharpActive"
    static let normalObjectSharpActive = "normalObjectSharpActive"
    static let oscillateObjectSharpActive = "oscillateObjectSharpActive"
    static let reappearObjectSharpActive = "reappearObjectSharpActive"
    static let solidObjectActive = "solidObjectActive"
    static let solidObjectSharpActive = "solidObjectSharpActive"

    // MARK: Press Durations
    static let longDuration: Double = 1
}
