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
            // TODO: Remove magic string
            Image(name)
                .resizable()
                .scaledToFit()
                .opacity(isHighlighted ? selectedAlpha : unselectedAlpha)
                //.frame(width: diameter, height: diameter)
                .frame(width: diameter, height: diameter)
                .rotationEffect(.radians(orientation))
                //TODO: Fix glow later
                //.shadow(color: Color.yellow.opacity(1), radius: 20, x: 0, y: 0)
                //.shadow(color: Color.white, radius: 20, x: 0, y: 0)
        }
    }
}
