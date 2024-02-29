//
//  InstructionView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct InstructionView: View {
    @State private var readyToNavigate : Bool = false
    @State private var isButtonClicked = false
    @State private var isSecondaryButtonClicked = false
    @State var degreesRotating = 0.0
    @State private var xOffset: CGFloat = -70.0
    @State private var currentImageIndex = 0
    let reappearImages: [String] = ["reappearObject", "reappearObjectActive"]
    let actionImages: [String] = ["actionObject", "actionObjectActive"]
    let oscillateImages: [String] = ["oscillateObject", "oscillateObjectActive"]
    private let maxOffset: CGFloat = 70.0
    private let maxRotationAngle: CGFloat = 180.0
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let infoHeight: CGFloat = Constants.screenWidth / 3
    private let infoSpacing: CGFloat = Constants.screenWidth / 10
    private let desertLightBrown = Color(red: 209/255, green: 188/255, blue: 140/255)
    private let desertDarkBrown = Color(red: 195/255, green: 169/255, blue: 114/255)
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3

    var body: some View {
        NavigationStack {
            ZStack {
                screenDisplay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        gridDisplay
                        Spacer()
                    }
                    Spacer()
                    Image("anubis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Spacer()
                }
            }
        }
    }
}

extension InstructionView {
    private var screenDisplay: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [
                    desertLightBrown,
                    desertLightBrown.opacity(0.9),
                    desertLightBrown.opacity(0.6),
                    desertLightBrown.opacity(0.9),
                    desertLightBrown.opacity(0.7),
                ]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .edgesIgnoringSafeArea(.all)
            .frame(width: Constants.screenWidth)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $readyToNavigate) {
                CanvasView()
            }
    }
}

extension InstructionView {
    private var shooterInfoDisplay: some View {
        ZStack {
            infoDisplayBox
            shooterDisplay
        }
    }
}

extension InstructionView {
    private var captureInfoDisplay: some View {
        ZStack {
            infoDisplayBox
            captureDisplay
        }
    }
}

extension InstructionView {
    private var powerInfoDisplay: some View {
        ZStack {
            infoDisplayBox
            powerDisplay
        }
    }
}

extension InstructionView {
    private var themeInfoDisplay: some View {
        ZStack {
            infoDisplayBox
            themeDisplay
        }
    }
}

extension InstructionView {
    private var shooterDisplay: some View {
        VStack {
            Image("scarab-beetle-rotate")
                .resizable()
                .rotationEffect(.degrees(degreesRotating))
                .frame(width: infoWidth / 2, height: infoWidth / 2)
                .onAppear {
                    withAnimation(.linear(duration: 1)
                        .speed(0.5).repeatForever(autoreverses: true)) {
                            degreesRotating = maxRotationAngle
                        }
                }
            Text("Rotate the scarab shooter and tap on the background to shoot.")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }


    }
}

extension InstructionView {
    private var captureDisplay: some View {
        VStack {
            Image("scarabShooterGold")
                .resizable()
                .frame(width: infoWidth / 2, height: infoWidth / 3)
                .offset(x: xOffset)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1)
                        .speed(0.8)
                        .repeatForever(autoreverses: true)) {
                            xOffset = maxOffset
                        }
                }
            Text("When a ball falls into the scarab, you get a free ball, but the limit is 10.")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }

    }
}

extension InstructionView {
    private func objectDisplay(with images: [String]) -> some View {
        Image(images[currentImageIndex])
            .resizable()
            .frame(width: infoWidth / 4, height: infoWidth / 4)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    currentImageIndex = (currentImageIndex + 1) % 2
                }
            }
    }
}

extension InstructionView {
    private var powerDisplay: some View {
        VStack {
            HStack {
                objectDisplay(with: reappearImages)
                objectDisplay(with: actionImages)
                objectDisplay(with: oscillateImages)
            }
            Text("Special objects are spook, kaboom and oscillate.")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}

extension InstructionView {
    private var sharpDisplay: some View {
        Image("pyramidBlock")
            .resizable()
            .frame(width: infoWidth / 3, height: infoWidth / 3)
    }
}

extension InstructionView {
    private var obstacleDisplay: some View {
        Image("obstacleObject")
            .resizable()
            .frame(width: infoWidth / 4, height: infoWidth / 3)
    }
}

extension InstructionView {
    private var themeDisplay: some View {
        VStack {
            HStack {
                sharpDisplay
                obstacleDisplay
            }
            Text("Ancient Egypt themed objects!")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}

extension InstructionView {
    private var infoDisplayBox: some View {
        ZStack {
            Rectangle()
                .frame(width: infoWidth, height: infoHeight)
                .foregroundColor(desertDarkBrown)
                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
        }
    }
}

extension InstructionView {
    private var gridDisplay: some View {
        VStack(spacing: infoSpacing) {
            HStack(spacing: infoSpacing) {
                shooterInfoDisplay
                captureInfoDisplay
            }
            HStack {
                Image("hieroglyph")
                    .resizable()
                    .frame(width: infoWidth / 2, height: infoWidth / 3)
                Image("ankh")
                    .resizable()
                    .frame(width: infoWidth / 2, height: infoWidth / 3)
                Image("horus")
                    .resizable()
                    .frame(width: infoWidth / 2, height: infoWidth / 3)
            }
            HStack(spacing: infoSpacing) {
                powerInfoDisplay
                themeInfoDisplay
            }
        }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
    }
}
