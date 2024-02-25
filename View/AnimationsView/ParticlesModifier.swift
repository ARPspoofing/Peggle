//
//  ParticlesModifier.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/2/24.
//

import Foundation
import SwiftUI

struct ParticlesModifier: ViewModifier {
    var isBlast: Bool
    @Binding var isDoneShooting: Bool
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 1.5
    let rotationSpeedUp = 80.0

    func body(content: Content) -> some View {
        let particleCount = isBlast ? 50 : 30
        ZStack {
            ForEach(0..<particleCount, id: \.self) { _ in
                content
                    .hueRotation(Angle(degrees: time * rotationSpeedUp))
                    .scaleEffect(isBlast ? (isDoneShooting ? 0.3 : 0.7) : 0.3)
                    .modifier(FireworkParticlesGeometryEffect(isBlast: isBlast, time: time))
                    .opacity(((duration - time) / duration))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}
