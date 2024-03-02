//
//  GameOverView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 1/3/24.
//

import Foundation
import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var viewModel: CanvasViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                let dismissButton   = CustomAlertButton(title: "Back")
                let roundedScore = String(format: "%.0f", viewModel.score)
                let retryTitle = "Try Again!"
                let wonTitle = "You Won!"
                let retryMessage = "Score: \(roundedScore)\nTip: Clear blue pegs out of the way to get to orange pegs."
                let wonMessage  = "Score: \(roundedScore)\nCongratulations!"
                if !viewModel.isWin {
                    CustomAlertView(title: retryTitle, message: retryMessage, dismissButton: dismissButton,
                                primaryButton: nil, secondaryButton: nil)
                } else if viewModel.isWin {
                    CustomAlertView(title: wonTitle, message: wonMessage, dismissButton: dismissButton,
                                primaryButton: nil, secondaryButton: nil)
                }
            }
            .onAppear {
                viewModel.isWin ? AudioManager.shared.playVictoryAudio(isLooping: true) : AudioManager.shared.playGameOverAudio(isLooping: true)
            }
            .onDisappear {
                AudioManager.shared.stop()
                AudioManager.shared.playMainMenuAudio()
            }
        }
    }
}
