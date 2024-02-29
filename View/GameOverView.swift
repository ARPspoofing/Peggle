//
//  GameOverView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct GameOverView: View {
    @State private var isAlertPresented = false
    var body: some View {
        ZStack {
                    Button {
                        isAlertPresented = true

                    } label: {
                        Text("Alert test")
                    }
                }
                .alert(title: "title", message: "message",
                   primaryButton: CustomAlertButton(title: "Yes", action: { }),
                   secondaryButton: CustomAlertButton(title: "No", action: {  }),
                   isPresented: $isAlertPresented)
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}

extension View {

    func alert(title: String = "", message: String = "", dismissButton: CustomAlertButton = CustomAlertButton(title: "ok"), isPresented: Binding<Bool>) -> some View {
        let title   = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")

        return modifier(CustomAlertModifier(title: title, message: message, dismissButton: dismissButton, isPresented: isPresented))
    }

    func alert(title: String = "", message: String = "", primaryButton: CustomAlertButton, secondaryButton: CustomAlertButton, isPresented: Binding<Bool>) -> some View {
        let title   = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")

        return modifier(CustomAlertModifier(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton, isPresented: isPresented))
    }
}

struct CustomAlert: View {

    // MARK: - Value
    // MARK: Public
    let title: String
    let message: String
    let dismissButton: CustomAlertButton?
    let primaryButton: CustomAlertButton?
    let secondaryButton: CustomAlertButton?

    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat             = 0.001

    @Environment(\.dismiss) private var dismiss


    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            dimView

            alertView
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .task {
            animate(isShown: true)
        }
    }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 20) {
            titleView
            messageView
            buttonsView
        }
        .padding(24)
        .frame(width: 320)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .lineSpacing(24 - UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var messageView: some View {
        if !message.isEmpty {
            Text(message)
                .font(.system(size: title.isEmpty ? 18 : 16))
                .foregroundColor(title.isEmpty ? .black : .gray)
                .lineSpacing(24 - UIFont.systemFont(ofSize: title.isEmpty ? 18 : 16).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var buttonsView: some View {
        HStack(spacing: 12) {
            if dismissButton != nil {
                dismissButtonView

            } else if primaryButton != nil, secondaryButton != nil {
                secondaryButtonView
                primaryButtonView
            }
        }
        .padding(.top, 23)
    }

    @ViewBuilder
    private var primaryButtonView: some View {
        if let button = primaryButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
                    dismiss()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    @ViewBuilder
    private var secondaryButtonView: some View {
        if let button = secondaryButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
                    dismiss()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    @ViewBuilder
    private var dismissButtonView: some View {
        if let button = dismissButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
                    dismiss()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    private var dimView: some View {
        Color.gray
            .opacity(0.88)
            .opacity(backgroundOpacity)
    }


    // MARK: - Function
    // MARK: Private
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1

            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }

        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity           = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}

#if DEBUG
struct CustomAlert_Previews: PreviewProvider {

    static var previews: some View {
        let dismissButton   = CustomAlertButton(title: "OK")
        let primaryButton   = CustomAlertButton(title: "OK")
        let secondaryButton = CustomAlertButton(title: "Cancel")

        let title = "This is your life. Do what you want and do it often."
        let message = """
                    If you don't like something, change it.
                    If you don't like your job, quit.
                    If you don't have enough time, stop watching TV.
                    """

        return VStack {
            CustomAlert(title: title, message: message, dismissButton: nil,           primaryButton: nil,           secondaryButton: nil)
            CustomAlert(title: title, message: message, dismissButton: dismissButton, primaryButton: nil,           secondaryButton: nil)
            CustomAlert(title: title, message: message, dismissButton: nil,           primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        .previewDevice("iPhone 13 Pro Max")
        .preferredColorScheme(.light)
    }
}
#endif


struct CustomAlertButton: View {

    // MARK: - Value
    // MARK: Public
    let title: LocalizedStringKey
    var action: (() -> Void)? = nil


    // MARK: - View
    // MARK: Public
    var body: some View {
        Button {
          action?()

        } label: {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
        }
        .frame(height: 30)
        .background(Color.purple)
        .cornerRadius(15)
    }
}

struct CustomAlertModifier {

    // MARK: - Value
    // MARK: Private
    @Binding private var isPresented: Bool

    // MARK: Private
    private let title: String
    private let message: String
    private let dismissButton: CustomAlertButton?
    private let primaryButton: CustomAlertButton?
    private let secondaryButton: CustomAlertButton?
}


extension CustomAlertModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                CustomAlert(title: title, message: message, dismissButton: dismissButton, primaryButton: primaryButton, secondaryButton: secondaryButton)
            }
    }
}

extension CustomAlertModifier {

    init(title: String = "", message: String = "", dismissButton: CustomAlertButton, isPresented: Binding<Bool>) {
        self.title         = title
        self.message       = message
        self.dismissButton = dismissButton

        self.primaryButton   = nil
        self.secondaryButton = nil

        _isPresented = isPresented
    }

    init(title: String = "", message: String = "", primaryButton: CustomAlertButton, secondaryButton: CustomAlertButton, isPresented: Binding<Bool>) {
        self.title           = title
        self.message         = message
        self.primaryButton   = primaryButton
        self.secondaryButton = secondaryButton

        self.dismissButton = nil

        _isPresented = isPresented
    }
}
