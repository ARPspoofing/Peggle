//
//  ParticlesOverlay.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

struct ParticlesOverlay: View {
    var isBlast: Bool
    var diameter: CGFloat
    @Binding var isDoneShooting: Bool
    var isNoHealth: Bool
    @State private var shouldAnimate = false
    var initialDiameter: CGFloat = 60
    var additionalPadding: CGFloat = 20
    var body: some View {
        ZStack {
            JaggedCircle()
                        .fill(Color.white)
                        .opacity(isBlast ? 1 : 0.0)
                        .frame(width: initialDiameter, height: initialDiameter)
            Circle()
                        .fill(Color.white)
                        .opacity(isBlast || !isNoHealth ? 0 : 0.7)
                        .frame(width: diameter, height: diameter)
            Circle()
                .fill(Color.red)
                .frame(width: additionalPadding, height: additionalPadding)
                .modifier(ParticlesModifier(isBlast: isBlast, isDoneShooting: $isDoneShooting))
        }
    }
}
