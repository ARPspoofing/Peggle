//
//  StatusView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    private let desertLightBrown = Color(red: 209/255, green: 188/255, blue: 140/255)
    private let desertDarkBrown = Color(red: 195/255, green: 169/255, blue: 114/255)
    private let shadowColor = Color.black.opacity(0.6)
    private let shadowRadius: CGFloat = 5
    private let shadowY: CGFloat = 3
    private let fontSize: CGFloat = 20
    private let pointWidth: CGFloat = Constants.screenWidth * 0.30
    private let pointHeight: CGFloat = 50
    private let timeWidth: CGFloat = Constants.screenWidth * 0.2
    private let timeHeight: CGFloat = 50
    private let ammoWidth: CGFloat = Constants.screenWidth * 0.17
    private let ammoHeight: CGFloat = 50
    private let countWidth: CGFloat = Constants.screenWidth * 0.2
    private let countHeight: CGFloat = 50
    private let radius: CGFloat = 10
    private let lineWidth: CGFloat = 2
    private let opacity: CGFloat = 0.6
    private let seconds: Double = 60.0
    private let empty: CGFloat = 0

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: countWidth, height: countHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.black, lineWidth: lineWidth)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(opacity), radius: radius, x: radius, y: radius)
                    Text("Total Objects: \(viewModel.countObjects())\nOrange Pegs: \(viewModel.countActiveObjects())")
                        .foregroundColor(.black)
                        .font(.system(size: fontSize, weight: .bold))
                }
                ZStack {
                    Rectangle()
                        .frame(width: timeWidth, height: timeHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.black, lineWidth: lineWidth)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(opacity), radius: radius, x: radius, y: radius)
                    Text("\(seconds - viewModel.elapsedTime, specifier: "%.0f") sec")
                        .foregroundColor(.black)
                        .font(.system(size: fontSize, weight: .bold))
                }
                ZStack {
                    Rectangle()
                        .frame(width: timeWidth / 2, height: timeHeight)
                        .opacity(empty)
                }
                ZStack {
                    Rectangle()
                        .frame(width: ammoWidth, height: ammoHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.black, lineWidth: lineWidth)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(opacity), radius: radius, x: radius, y: radius)
                    Text("Ammo: \(viewModel.countAmmo())")
                        .foregroundColor(.black)
                        .font(.system(size: fontSize, weight: .bold))
                }
                ZStack {
                    Rectangle()
                        .frame(width: pointWidth, height: pointHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.black, lineWidth: lineWidth)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(opacity), radius: radius, x: radius, y: radius)
                    Text("\(viewModel.score, specifier: "%.0f") points")
                        .foregroundColor(.black)
                        .font(.system(size: fontSize, weight: .bold))
                }

            }.background(desertLightBrown)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
