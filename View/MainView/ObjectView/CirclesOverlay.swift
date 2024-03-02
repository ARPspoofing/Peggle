//
//  CirclesOverlay.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

struct CirclesOverlay: View {
    @State var isDisplay: Bool
    var name: String
    var diameter: CGFloat
    @Binding var isAnimating: Bool
    var largeScale = 2.0
    var normalScale = 1.0
    var delay = 0.3

    var body: some View {
        ZStack {
            RadiatingCirclesView(isDisplay: isDisplay, name: name, diameter: diameter)
                .active()
                .scaleEffect(isDisplay ? largeScale : normalScale)
                .opacity(isDisplay ? 1 : 0)
                .onAppear {
                    //isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(.easeInOut(duration: delay)) {
                            isDisplay = false
                        }
                    }
                }
                .onDisappear {
                    isAnimating = false
                }
        }
    }
}
