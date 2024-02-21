//
//  ActionButtonsView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 18/2/24.
//

import SwiftUI

extension ActionButtonsView {

    func dismissButton() -> Alert.Button {
        .default(Text(constants.dismissAlertText))
    }

    func destructiveButton(text: String, action: @escaping () -> Void) -> Alert.Button {
        .destructive(Text(text), action: action)
    }

    func defaultButton(text: String, action: @escaping () -> Void) -> Alert.Button {
        .default(Text(text), action: action)
    }

    func successLoadAlert() -> Alert {
        Alert(
            title: Text(constants.successLoadingTitle),
            message: Text(status),
            dismissButton: dismissButton()
        )
    }

    func errorLoadAlert() -> Alert {
        Alert(
            title: Text(constants.errorLoadingTitle),
            message: Text(constants.errorLoadingPrompt),
            dismissButton: dismissButton()
        )
    }

    func noStartAlert() -> Alert {
        Alert(
            title: Text(constants.noStartAlertTitle),
            message: Text(constants.noStartAlertPrompt),
            dismissButton: dismissButton()
        )
    }

    func noResetAlert() -> Alert {
        Alert(
            title: Text(constants.noResetAlertTitle),
            message: Text(constants.noResetAlertPrompt),
            dismissButton: dismissButton()
        )
    }

    func resetAlert() -> Alert {
        Alert(
            title: Text(constants.resetAlertTitle),
            message: Text(constants.resetAlertPrompt),
            primaryButton: destructiveButton(text: constants.resetText) {
                actionButtonsViewModel.resetLevel(&canvasViewModel.gameObjects)
            },
            secondaryButton: .cancel()
        )
    }

    func startOverwriteAlert() -> Alert {
        Alert(
            title: Text(constants.startAlertTitle),
            message: Text(constants.startAlertPrompt),
            primaryButton: defaultButton(text: constants.startText) {
                _ = actionButtonsViewModel.saveLevel(
                    levelName: inputText,
                    gameObjects: canvasViewModel.gameObjects
                )
                canvasViewModel.start()
                canvasViewModel.initCaptureObject()
            },
            secondaryButton: .cancel()
        )
    }

    func overwriteAlert() -> Alert {
        Alert(
            title: Text(constants.overwriteAlertTitle),
            message: Text(constants.overwriteAlertPrompt),
            primaryButton: destructiveButton(text: constants.overwriteText) {
                _ = actionButtonsViewModel.saveLevel(
                    levelName: inputText,
                    gameObjects: canvasViewModel.gameObjects
                )
            },
            secondaryButton: .cancel()
        )
    }

    func saveAlert() -> Alert {
        Alert(
            title: Text(constants.saveAlertTitle),
            message: Text(status),
            dismissButton: dismissButton()
        )
    }

    func customAlert(isPresented: Binding<Bool>, activeAlert: String, status: String) -> Alert {
        let alert: [String: Alert] = [
            constants.saveAlert: saveAlert(),
            constants.overwriteAlert: overwriteAlert(),
            constants.startOverwriteAlert: startOverwriteAlert(),
            constants.resetAlert: resetAlert(),
            constants.noResetAlert: noResetAlert(),
            constants.noStartAlert: noStartAlert(),
            constants.errorLoadAlert: errorLoadAlert(),
            constants.successLoadAlert: successLoadAlert()
        ]
        return alert[activeAlert] ?? Alert(title: Text(unknownAlert), message: Text(unknownAlert))
    }
}
