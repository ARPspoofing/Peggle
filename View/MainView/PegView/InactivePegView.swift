//
//  InactivePegView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import SwiftUI

struct InactivePegView: View {
    var name: String
    var isHighlighted: Bool
    var selectedAlpha: Double
    var unselectedAlpha: Double
    var diameter: CGFloat = 50

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .opacity(isHighlighted ? selectedAlpha : unselectedAlpha)
            .frame(maxWidth: diameter, maxHeight: diameter)
    }
}
