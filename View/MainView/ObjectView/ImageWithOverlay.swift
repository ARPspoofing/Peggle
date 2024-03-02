//
//  ImageWithOverlay.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

struct ImageWithOverlay: View {
    var imageName: String
    var isDisappear: Bool
    var isShowingCircle: Bool
    var diameter: CGFloat
    var isNoHealth: Bool
    var health: Double
    var actionObjectActive = Constants.actionObjectActive
    @State private var isShowingHealthBar = true
    @Binding var isDoneShooting: Bool
    @Binding var isAnimating: Bool

    var body: some View {
        if isDoneShooting && isNoHealth {
            ParticlesOverlay(isBlast: false, diameter: diameter, isDoneShooting: $isDoneShooting, isNoHealth: isNoHealth)
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .opacity((isDisappear || isDoneShooting) && isNoHealth ? 0 : health <= 50.0 ? 0.5 : 1)
                .frame(maxWidth: diameter, maxHeight: diameter)
                .overlay(
                    //!(imageName.contains("Sharp") || imageName.contains("obstacle"))
                    ZStack(alignment: .topTrailing) {
                        if isShowingHealthBar && !isNoHealth {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 100, height: 10)
                                .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: CGFloat(health), height: 10)
                                .foregroundColor(.green)
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                                        withAnimation {
                                            isShowingHealthBar = false
                                        }
                                    }
                                }
                            Text("\(Int(health))/100")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .padding(5)
                        }
                        CirclesOverlay(
                            isDisplay: isShowingCircle,
                            name: imageName,
                            diameter: diameter,
                            isAnimating: $isAnimating
                        )
                    }
                )
            if imageName == actionObjectActive {
                ParticlesOverlay(isBlast: true, diameter: diameter, isDoneShooting: $isDoneShooting, isNoHealth: true)
            }
        }
    }
}
