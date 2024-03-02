//
//  CustomAlertView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

// Credits to Dan from stackoverflow
struct CustomAlertView: View {
    @State private var isNavigationActive = false

    let title: String
    let message: String
    let dismissButton: CustomAlertButton?
    let primaryButton: CustomAlertButton?
    let secondaryButton: CustomAlertButton?
    let desertLightBrown = Color(red: 209/255, green: 188/255, blue: 140/255)
    let rustBrown = Color(red: 108/255, green: 55/255, blue: 68/255)
    let rustBrowns = Color(red: 108/255, green: 55/255, blue: 68/255)

    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat             = 0.001


    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                dimView
                alertView
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
            .navigationDestination(isPresented: $isNavigationActive) {
                CanvasView()
            }
            .ignoresSafeArea()
            .transition(.opacity)
            .task {
                animate(isShown: true)
            }
        }
    }

    private var alertView: some View {
        VStack(spacing: 20) {
            titleView
            messageView
            buttonsView
        }
        .padding(24)
        .frame(width: 320)
        .background(desertLightBrown)
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
                .foregroundColor(title.isEmpty ? .black : rustBrown)
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

    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        if isShown {
            opacity = 1
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }
        } else {
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

struct CustomAlertButton: View {
    @EnvironmentObject private var viewModel: CanvasViewModel
    @State private var isNavigationActive = false
    let title: LocalizedStringKey
    var action: (() -> Void)? = nil
    private let desertDarkBrown = Color(red: 195/255, green: 169/255, blue: 114/255)

    var body: some View {
        NavigationLink(destination: CanvasView(), isActive: $isNavigationActive) {
                EmptyView()
            }
            .hidden()
        Button(action: {
            isNavigationActive = true
        }) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .padding(.horizontal, 10)
        }.frame(height: 30)
            .background(desertDarkBrown)
            .cornerRadius(15)
    }
}
