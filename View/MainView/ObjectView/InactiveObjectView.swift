//
//  InactiveObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import SwiftUI

struct InactiveObjectView: View {
    var name: String
    var isHighlighted: Bool
    var selectedAlpha: Double
    var unselectedAlpha: Double
    var diameter: CGFloat
    var orientation: CGFloat

    var body: some View {
        ZStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .opacity(isHighlighted ? selectedAlpha : unselectedAlpha)
                .frame(width: diameter, height: diameter)
                .rotationEffect(.radians(orientation))
        }
    }
}
