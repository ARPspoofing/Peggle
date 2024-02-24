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
    static let green = Color.green
    static let yellow = Color.yellow
    static let red = Color.red
    static let lightGrey = Color(UIColor.lightGray)
    static let customGrey = Color(red: 242, green: 242, blue: 247)

    // MARK: Button Constants
    static let deleteButtonScale: CGFloat = 0.4
    static let deleteSize = screenHeight * 0.1

    // MARK: Screen Constants
    static var screenWidth = UIScreen.main.bounds.size.width
    static var gameHeight = UIScreen.main.bounds.size.height
    static var canvasHeight = UIScreen.main.bounds.size.height * 0.8
    static var screenHeight = UIScreen.main.bounds.size.height * 0.8
    static var paletteHeight = UIScreen.main.bounds.size.height * 0.18
    static var activeHeight = UIScreen.main.bounds.size.height * 0.1
    static let defaultHalfWidth: CGFloat = 25

    // MARK: Circle Constants
    static let defaultCircleRadius: CGFloat = 25
    static let defaultCircleDiameter: CGFloat = 50
    static let maxCircleRadius: CGFloat = 40
    static let minCircleRadius: CGFloat = 18
    static let roundedRadius: CGFloat = 20
    static let radius: CGFloat = 10

    // MARK: Image Constants
    static let normalObject = "normalObject"
    static let actionObject = "actionObject"
    // TODO: Rename to not be pyramid
    static let sharpObject = "pyramidBlock"
    static let delete = "delete"
    static let background = "background"
    static let motionObject = "motionObject"
    static let shooterBase = "shooterBase"
    static let shooterHead = "shooterHead"
    static let none = "none"

    // MARK: Press Durations
    static let longDuration: Double = 1
}
