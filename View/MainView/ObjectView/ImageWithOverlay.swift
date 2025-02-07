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
    let radius: CGFloat = 5
    let width: CGFloat = 50
    let height: CGFloat = 10
    let fontSize: CGFloat = 12
    @State private var isShowingHealthBar = true
    @Binding var isDoneShooting: Bool
    @Binding var isAnimating: Bool

    var body: some View {
        let obstacleCondition = (imageName.contains(Constants.sharp) ||
                                 imageName.contains(Constants.obstacle) ||
                                 imageName.contains(Constants.pointed))
        if isDoneShooting && isNoHealth && !obstacleCondition {
            ParticlesOverlay(isBlast: false, diameter: diameter,
                             isDoneShooting: $isDoneShooting,
                             isNoHealth: isNoHealth)
        } else {
            mainImage
        }
    }
}

// MARK: - Computed Properties
extension ImageWithOverlay {
    var mainImage: some View {
        ZStack {
            let obstacleCondition = (imageName.contains(Constants.sharp) ||
                                     imageName.contains(Constants.obstacle) ||
                                     imageName.contains(Constants.pointed))
            Image(imageName)
                .resizable()
                .scaledToFit()
                .opacity(obstacleCondition ? 1 : (isDisappear || isDoneShooting) &&
                         isNoHealth ? 0 : health <= 50.0 ? 0.5 : 1)
                .frame(maxWidth: diameter, maxHeight: diameter)
                .overlay(healthBarOverlay)
                .if(imageName == actionObjectActive) { view in
                    view.overlay(actionObjectOverlay)
                }
        }
    }

    var healthBarOverlay: some View {
        ZStack(alignment: .topLeading) {
            let obstacleCondition = (imageName.contains(Constants.sharp) ||
                                     imageName.contains(Constants.obstacle) ||
                                     imageName.contains(Constants.pointed))
            let displayCondition = isShowingHealthBar && !isNoHealth && !obstacleCondition
            if displayCondition {
                RoundedRectangle(cornerRadius: radius)
                    .frame(width: width, height: height)
                    .foregroundColor(.gray)
                RoundedRectangle(cornerRadius: radius)
                    .frame(width: CGFloat(health / 2), height: height)
                    .foregroundColor(.green)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                            withAnimation {
                                isShowingHealthBar = false
                            }
                        }
                    }
                Text("\(Int(health))/100")
                    .font(.system(size: fontSize))
                    .foregroundColor(.white)
                    .padding(radius)
                CirclesOverlay(
                    isDisplay: isShowingCircle,
                    name: imageName,
                    diameter: diameter,
                    isAnimating: $isAnimating
                )
            }
        }
    }

    var actionObjectOverlay: some View {
        ParticlesOverlay(isBlast: true, diameter: diameter, isDoneShooting: $isDoneShooting, isNoHealth: true)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
