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
    let shooter = "scarab-beetle-rotate"
    let capture = "scarabShooterGold"
    let sharp = "pyramidBlock"
    let obstacle = "obstacleObject"
    let hieroglyph = "hieroglyph"
    let base = "base"
    let ankh = "ankh"
    let horus = "horus"
    let anubis = "anubis"
    let buttonText = "Done"
    let intro = "How To Play"
    let shooterText = "Rotate the scarab shooter and tap on the background to shoot."
    let captureText = "When a ball falls into the scarab, you get a free ball, but the limit is 10."
    let powerText = "Special objects are spook, kaboom and oscillate."
    let obstacleText = "Ancient Egypt themed objects!"

    private let maxOffset: CGFloat = 70.0
    private let maxRotationAngle: CGFloat = 180.0
    private let decalDim: CGFloat = 100.0
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let infoHeight: CGFloat = Constants.screenWidth / 3
    private let infoSpacing: CGFloat = Constants.screenWidth / 10
    private let desertLightBrown = Color(red: 209/255, green: 188/255, blue: 140/255)
    private let desertDarkBrown = Color(red: 195/255, green: 169/255, blue: 114/255)
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3
    private let fontSize: CGFloat = 20

    var body: some View {
        NavigationStack {
            ZStack {
                screenDisplay
                VStack {
                    IntroDisplayView()
                    Spacer()
                    gridDisplay
                    Spacer()
                    DecalView()
                    Spacer()
                    customButton
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

/*
extension InstructionView {
    private var introDisplay: some View {
        ZStack {
            Image(base)
            Text(intro)
            .font(.system(size: fontSize, weight: .bold))
        }
    }
}
*/

extension InstructionView {
    private var customButton: some View {
        Button(action: {
            readyToNavigate = true
            }) {
                Text(buttonText)
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 20)
                    .background(desertDarkBrown)
                    .cornerRadius(8)
            }
    }
}

/*
extension InstructionView {
    private var bottomDecal: some View {
        Image(anubis)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: decalDim, height: decalDim)
    }
}
*/


extension InstructionView {
    private var shooterInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            //ShooterDisplayView()
            shooterDisplay
        }
    }
}

extension InstructionView {
    private var captureInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            captureDisplay
            //CaptureDisplayView()
        }
    }
}

extension InstructionView {
    private var powerInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            ObjectDisplayView()
        }
    }
}

extension InstructionView {
    private var themeInfoDisplay: some View {
        ZStack {
            InfoDisplayBoxView()
            ThemeDisplayView()
        }
    }
}

extension InstructionView {
    private var shooterDisplay: some View {
        VStack {
            Image(shooter)
                .resizable()
                .rotationEffect(.degrees(degreesRotating))
                .frame(width: infoWidth / 2, height: infoWidth / 2)
                .onAppear {
                    withAnimation(.linear(duration: 1)
                        .speed(0.5).repeatForever(autoreverses: true)) {
                            degreesRotating = maxRotationAngle
                        }
                }
            Text(shooterText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}

extension InstructionView {
    private var captureDisplay: some View {
        VStack {
            Image(capture)
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
            Text(captureText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }

    }
}
//*/

/*
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
            Text(powerText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}
*/

/*
extension InstructionView {
    private var sharpDisplay: some View {
        Image(sharp)
            .resizable()
            .frame(width: infoWidth / 3, height: infoWidth / 3)
    }
}

extension InstructionView {
    private var obstacleDisplay: some View {
        Image(obstacle)
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
            Text(obstacleText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}
*/

/*
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
*/

extension InstructionView {
    private var gridDisplay: some View {
        HStack {
            Spacer()
            VStack(spacing: infoSpacing) {
                HStack(spacing: infoSpacing) {
                    shooterInfoDisplay
                    captureInfoDisplay
                }
                HStack {
                    Image(hieroglyph)
                        .resizable()
                        .frame(width: infoWidth / 2, height: infoWidth / 3)
                    Image(ankh)
                        .resizable()
                        .frame(width: infoWidth / 2, height: infoWidth / 3)
                    Image(horus)
                        .resizable()
                        .frame(width: infoWidth / 2, height: infoWidth / 3)
                }
                HStack(spacing: infoSpacing) {
                    powerInfoDisplay
                    themeInfoDisplay
                }
            }
            Spacer()
        }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
    }
}
