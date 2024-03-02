//
//  ActiveObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

struct ActiveObjectView: View {
    var name: String
    var isDisappear: Bool
    var isShowingCircle: Bool
    var diameter: CGFloat
    var isNoHealth: Bool
    var health: Double
    var orientation: Double
    var activeName = "Active"
    @Binding var isDoneShooting: Bool
    @Binding var isAnimating: Bool

    var body: some View {
        ImageWithOverlay(
            imageName: name + activeName,
            isDisappear: isDisappear,
            isShowingCircle: isShowingCircle,
            diameter: diameter,
            isNoHealth: isNoHealth,
            health: health,
            isDoneShooting: $isDoneShooting,
            isAnimating: $isAnimating
        )
        .rotationEffect(.radians(orientation))
    }
}
