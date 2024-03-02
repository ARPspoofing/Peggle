//
//  StatusView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    private let desertLightBrown = Constants.desertLightBrown
    private let desertDarkBrown = Constants.desertDarkBrown
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3
    private let height: CGFloat = 50
    private let pointWidth: CGFloat = Constants.screenWidth * 0.2
    private let timeWidth: CGFloat = Constants.screenWidth * 0.1
    private let ammoWidth: CGFloat = Constants.screenWidth * 0.16
    private let countWidth: CGFloat = Constants.screenWidth * 0.4
    private let radius: CGFloat = 10
    private let lineWidth: CGFloat = 2
    private let opacity: CGFloat = 0.6
    private let seconds: Double = 60.0
    private let empty: CGFloat = 0

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                StatView(width: ammoWidth, text: "Ammo: \(viewModel.countAmmo())")

                let formattedScore = String(format: "%.0f", viewModel.score)
                StatView(width: pointWidth, text: "\(formattedScore) points")

                let formattedTime = String(format: "%.0f", seconds - viewModel.elapsedTime)
                StatView(width: timeWidth, text: "\(formattedTime) sec")
                Rectangle()
                    .frame(width: timeWidth, height: height)
                    .opacity(empty)

                StatView(
                    width: countWidth,
                    text: "Total Objects: \(viewModel.countObjects())\n" +
                          "Orange Pegs: \(viewModel.countActiveObjects())"
                )
            }.background(desertLightBrown)
        }
    }
}

struct StatView: View {
    let width: CGFloat
    let text: String
    private let desertLightBrown = Constants.desertLightBrown
    private let desertDarkBrown = Constants.desertDarkBrown
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3
    private let fontSize: CGFloat = 20
    private let height: CGFloat = 50
    private let radius: CGFloat = 10
    private let lineWidth: CGFloat = 2
    private let opacity: CGFloat = 0.6
    private let seconds: Double = 60.0
    private let empty: CGFloat = 0

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.black, lineWidth: lineWidth)
                )
                .foregroundColor(desertDarkBrown)
                .shadow(color: Color.black.opacity(opacity), radius: radius, x: radius, y: radius)

            Text(text)
                .foregroundColor(.black)
                .font(.system(size: fontSize, weight: .bold))
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
