//
//  ParticlesModifier.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/2/24.
//

import Foundation
import SwiftUI

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 1.5
    let rotationSpeedUp = 80.0

    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<30, id: \.self) { _ in
                content
                    .hueRotation(Angle(degrees: time * rotationSpeedUp))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
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
