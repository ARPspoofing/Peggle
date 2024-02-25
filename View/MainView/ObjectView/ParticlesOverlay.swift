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
    @Binding var isDoneShooting: Bool
    @State private var shouldAnimate = false
    var initialDiameter: CGFloat = 60
    var additionalPadding: CGFloat = 20
    var body: some View {
        ZStack {
            JaggedCircle()
                        .fill(Color.white)
                        .frame(width: initialDiameter, height: initialDiameter)
            Circle()
                .fill(Color.red)
                .frame(width: additionalPadding, height: additionalPadding)
                .modifier(ParticlesModifier(isBlast: isBlast, isDoneShooting: $isDoneShooting))
        }
    }
}
