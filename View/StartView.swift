//
//  StartView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import SwiftUI

struct StartView: View {
    @State private var readyToNavigate : Bool = false
    @State private var isButtonClicked = false
    @State private var isSecondaryButtonClicked = false

    private let startScreen = "startScreen"
    private let text = "Start"
    private let scroll = "scroll"
    private let fontSize: CGFloat = 30
    private let padding: CGFloat = 10
    private let paddingBottom: CGFloat = 30
    private let paddingSides: CGFloat = 20
    private let radius: CGFloat = 10
    private let width: CGFloat = 1
    private let scrollFrame: CGFloat = 200
    private let desertBrown = Color(red: 241/255, green: 195/255, blue: 102/255)
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3


    var body: some View {
        NavigationStack {
            ZStack {
                startScreenDisplay
                .overlay(
                    Button(action: {
                    }) {
                        ZStack(alignment: .bottom) {
                        scrollDisplay
                        Button(action: {
                            AudioManager.shared.play(fileName: "buttonClickAudio", isLooping: true)
                            readyToNavigate = true
                        }) {
                            textDisplay
                        }
                        .padding(.bottom, paddingBottom)
                        .shadow(color: shadowColor, radius: shadowRadius, y: shadowY)
                        }
                    }
                .padding(paddingSides)
                )
            }
            .onAppear {
                AudioManager.shared.play(fileName: "mainMenuAudio", isLooping: true)
            }.navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
    }
}

extension StartView {
    private var startScreenDisplay: some View {
        Image(startScreen)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $readyToNavigate) {
                InstructionView()
            }
    }
}

extension StartView {
    private var textDisplay: some View {
        Text(text)
            .foregroundColor(.black)
            .font(.system(size: fontSize, weight: .bold))
            .padding(.horizontal, padding)
            .padding(.vertical, padding)
            .background(
                RoundedRectangle(cornerRadius: padding)
                    .fill(desertBrown)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.black, lineWidth: width)
                    )
            )
            .cornerRadius(radius)
    }
}

extension StartView {
    private var scrollDisplay: some View {
        Image(scroll)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: scrollFrame, height: scrollFrame)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
