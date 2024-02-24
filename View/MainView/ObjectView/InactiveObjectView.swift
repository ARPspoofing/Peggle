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
                //.frame(width: name == "pyramidBlock" ? diameter * 2 : diameter, height: name == "pyramidBlock" ? diameter * 2 : diameter)
                .frame(width: diameter, height: diameter)
                .rotationEffect(.radians(orientation))
        }
    }
}
