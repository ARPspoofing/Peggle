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

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: Constants.screenWidth * 0.2, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
                    Text("\(viewModel.score, specifier: "%.0f") points")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold))
                }

                ZStack {
                    Rectangle()
                        .frame(width: Constants.screenWidth * 0.2, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
                    Text("\(60.0 - viewModel.elapsedTime, specifier: "%.0f") sec")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold))
                }

                ZStack {
                    Rectangle()
                        .frame(width: Constants.screenWidth * 0.2, height: 50)
                        .opacity(0)
                }

                ZStack {
                    Rectangle()
                        .frame(width: Constants.screenWidth * 0.37, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .foregroundColor(desertDarkBrown)
                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
                    Text("Ammo: \(viewModel.remainingAmmo.count)")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold))
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
