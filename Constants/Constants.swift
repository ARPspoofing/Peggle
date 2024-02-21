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
    static let delete = "delete"
    static let background = "background"
    static let motionObject = "motionObject"
    static let shooterBase = "shooterBase"
    static let shooterHead = "shooterHead"
    static let none = "none"

    // MARK: Press Durations
    static let longDuration: Double = 1
}

struct ActionConstants {
    let sheetWidth: Double = 300
    let sheetHeight: Double = 400
    let buttonPadding: CGFloat = 20
    let textFieldPadding: CGFloat = 35
    let selectedAlpha: CGFloat = 1.0
    let unselectedAlpha: CGFloat = 0.3
    let initializePoint = Point(xCoord: 0.0, yCoord: 0.0)
    let screenWidth = UIScreen.main.bounds.size.width
    let initialTextLabel = ""
    let loadLabel = "LOAD"
    let saveLabel = "SAVE"
    let resetLabel = "RESET"
    let startLabel = "START"
    let placeholder = "LEVEL NAME"
    let saveAlertTitle = "Save Status"
    let dismissAlertText = "OK"
    let overwriteAlertTitle = "Overwrite Confirmation"
    let overwriteAlertPrompt = "Are you sure you want to overwrite current level?"
    let overwriteText = "Overwrite"
    let startAlertTitle = "Start Confirmation"
    let startAlertPrompt =
    "Starting a modified level will overwrite the previous level.Do you want to continue?"
    let startText = "Start"
    let resetAlertTitle = "Reset Confirmation"
    let resetAlertPrompt = "Are you sure you want to reset?"
    let resetText = "Reset"
    let noResetAlertTitle = "The canvas is already empty!"
    let noResetAlertPrompt = "A game object must exist before reset can occur"
    let noSaveAlertPrompt = "There must be at least one peg on the game board"
    let noStartAlertTitle = "The canvas is empty"
    let noStartAlertPrompt = "A game object must exist before starting"
    let errorLoadingTitle = "Error loading level!"
    let errorLoadingPrompt = "Level not found!"
    let normalObject = "normalObject"
    let actionObject = "actionObject"
    let delete = "delete"
    let motionObject = "motionObject"
    let none = "none"
    let successLoadingTitle = "Load Status"
    let saveAlert = "saveAlert"
    let resetAlert = "resetAlert"
    let noResetAlert = "noResetAlert"
    let noStartAlert = "noStartAlert"
    let errorLoadAlert = "errorLoadAlert"
    let successLoadAlert = "successLoadAlert"
    let overwriteAlert = "overwriteAlert"
    let startOverwriteAlert = "startOverwriteAlert"
}

struct CanvasViewModelConstants {
    let initializePoint = Point(xCoord: 0.0, yCoord: 0.0)
    let screenWidth = UIScreen.main.bounds.size.width
    let normalObject = "normalObject"
    let actionObject = "actionObject"
    let delete = "delete"
    let motionObject = "motionObject"
    let none = "none"
}

struct ActionViewModelConstants {
    let noPegMessage = "There must be at least one peg on the game board"
    let emptyLevelMessage = "Please enter a non empty alphanumeric level name"
    let alphaNumericLevelMessage = "Please enter an alphanumeric level name"
}

struct DeleteButtonConstants {
    let delete = "delete"
    let defaultCircleRadius: CGFloat = 25
}

struct PointConstants {
    let originX = 0.0
    let originY = 0.0
    let lowerBound: CGFloat = -Double.pi
    let upperBound: CGFloat = Double.pi
}

struct PaletteButtonsConstants {
    let leadingPadding: CGFloat = 20
    let paletteButtonsScale: Double = 2
    let selectedAlpha: CGFloat = 1.0
    let unselectedAlpha: CGFloat = 0.3
    let deleteButtonScale: CGFloat = 0.4
    let deleteSize = UIScreen.main.bounds.size.height * 0.8 * 0.1
}
