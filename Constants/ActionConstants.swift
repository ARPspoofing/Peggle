//
//  ActionConstants.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

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
