//
//  ActionButtons.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct ActionButtonsView: View {

    internal let constants = ActionConstants()

    @EnvironmentObject var canvasViewModel: CanvasViewModel
    @StateObject var actionButtonsViewModel = ActionButtonsViewModel()

    @State internal var isTextFieldActive = false
    @State internal var isLevelSelectionPresented = false
    @State internal var inputText: String = ""
    @State internal var loadLevelErrorMessage: String?

    @State internal var showAlert = false
    @State internal var closeSheetWithAlert = false
    @State internal var successLevelAlert = "Successfully loaded level!"
    @State internal var unknownAlert = "Unknown Alert"
    @State internal var status = "Successfully loaded level!"
    @State internal var activeAlert: String = "successLoadAlert"

    @ViewBuilder
    var body: some View {
        actionButtonsDisplay
            .sheet(isPresented: $isLevelSelectionPresented, onDismiss: {
                showAlert = closeSheetWithAlert
            }) {
                LevelSelectionView(levels: actionButtonsViewModel.getLevels(),
                                   onSelect: { selectedLevel in
                    inputText = selectedLevel

                    if let error = actionButtonsViewModel
                        .loadLevel(inputText, &canvasViewModel.gameObjects) {
                        status = error
                        activeAlert = constants.errorLoadAlert
                    } else {
                        status = successLevelAlert
                        activeAlert = constants.successLoadAlert
                    }
                    closeSheetWithAlert = true
                    isLevelSelectionPresented.toggle()
                },
                                   onCancel: {
                    closeSheetWithAlert = false
                    isLevelSelectionPresented.toggle()
                }).frame(width: constants.sheetWidth, height: constants.sheetHeight)
                    .clearModalBackground()
            }
            .alert(isPresented: $showAlert) {
                customAlert(isPresented: $showAlert, activeAlert: activeAlert, status: status)
            }
    }
}

extension ActionButtonsView {
    private var actionButtonsDisplay: some View {
        HStack {
            customLoadButton
            customSaveButton
            customResetButton
            customTextField
            customStartButton
        }
    }
}

extension ActionButtonsView {
    private var customLoadButton: some View {
        Button(constants.loadLabel) {
            guard !inputText.isEmpty else {
                return isLevelSelectionPresented.toggle()
            }
            if let error = actionButtonsViewModel
                .loadLevel(inputText, &canvasViewModel.gameObjects) {
                status = error
                activeAlert = constants.errorLoadAlert
            } else {
                status = successLevelAlert
                activeAlert = constants.successLoadAlert
            }
            showAlert = true
        }
        .padding(.leading, constants.buttonPadding)
        .disabled(isTextFieldActive)
    }
}

extension ActionButtonsView {
    private var customSaveButton: some View {
        Button(constants.saveLabel) {
            guard !canvasViewModel.gameObjects.isEmpty else {
                activeAlert = constants.saveAlert
                status = constants.noSaveAlertPrompt
                showAlert = true
                return
            }
            let isLevelExists: Bool = actionButtonsViewModel.checkLevelExistence(levelName: inputText)
            if isLevelExists {
                activeAlert = constants.overwriteAlert
            } else {
                status = actionButtonsViewModel.saveLevel(
                    levelName: inputText,
                    gameObjects: canvasViewModel.gameObjects
                )
                activeAlert = constants.saveAlert
            }
            showAlert = true
        }
        .disabled(isTextFieldActive)
    }
}

extension ActionButtonsView {
    private var customResetButton: some View {
        Button(constants.resetLabel) {
            showAlert = true
            guard !canvasViewModel.gameObjects.isEmpty else {
                activeAlert = constants.noResetAlert
                return
            }
            activeAlert = constants.resetAlert
        }
        .disabled(isTextFieldActive)
    }
}

extension ActionButtonsView {
    private var customStartButton: some View {
        Button(constants.startLabel) {
            guard !canvasViewModel.gameObjects.isEmpty else {
                activeAlert = constants.noStartAlert
                showAlert = true
                return
            }
            if let validMessage = actionButtonsViewModel
                .checkValidity(levelName: inputText, gameObjects: canvasViewModel.gameObjects) {
                status = validMessage
                activeAlert = constants.saveAlert
                showAlert = true
                return
            }
            activeAlert = constants.startOverwriteAlert
            showAlert = true
        }
        .padding(.trailing, constants.buttonPadding)
        .disabled(isTextFieldActive)
    }
}

extension ActionButtonsView {
    private var customTextField: some View {
        TextField(constants.placeholder, text: $inputText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, constants.textFieldPadding)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                self.isTextFieldActive = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                self.isTextFieldActive = false
            }
    }
}

struct ActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonsView().previewInterfaceOrientation(.landscapeLeft)
    }
}
