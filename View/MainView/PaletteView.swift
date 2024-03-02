//
//  Palette.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct PaletteView: View {
    @State private var isKeyboardActive = false
    @State private var keyboardHeight: CGFloat = 0
    private let desertLightBrown = Color(red: 209/255, green: 188/255, blue: 140/255)

    var body: some View {
        GeometryReader { _ in
            paletteDisplay
                .onReceive(
                    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notif in
                        handleKeyboardWillShow(notif)
                }
                .onReceive(NotificationCenter .default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        handleKeyboardWillHide()
                }
        }
    }

    private var paletteDisplay: some View {
        VStack {
            Spacer()
            VStack {
                if !isKeyboardActive {
                    PaletteButtonsView()
                }
                ActionButtonsView()
            }
            .frame(width: Constants.screenWidth,
                   height: !isKeyboardActive ? Constants.paletteHeight : Constants.activeHeight)
            .background(desertLightBrown)
        }
    }
}

extension PaletteView {
    private func handleKeyboardWillShow(_ notification: Notification) {
        withAnimation {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
            isKeyboardActive = true
        }
    }

    private func handleKeyboardWillHide() {
        withAnimation {
            keyboardHeight = 0
            isKeyboardActive = false
        }
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView().previewInterfaceOrientation(.landscapeLeft)
    }
}
