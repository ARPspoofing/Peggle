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
    @Binding var isDoneShooting: Bool
    @Binding var isAnimating: Bool

    var body: some View {
        if isDoneShooting {
            Image(imageName)
                .opacity(0)
            ParticlesOverlay(isBlast: false, isDoneShooting: $isDoneShooting)
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .opacity(isDisappear || isDoneShooting ? 0 : 1)
                .frame(maxWidth: diameter, maxHeight: diameter)
                .overlay(
                    CirclesOverlay(
                        isDisplay: isShowingCircle,
                        name: imageName,
                        diameter: diameter,
                        isAnimating: $isAnimating
                    )
                )
            // TODO: Make this neater
            if imageName == "actionObjectActive" {
                ParticlesOverlay(isBlast: true, isDoneShooting: $isDoneShooting)
            }
        }
    }
}
