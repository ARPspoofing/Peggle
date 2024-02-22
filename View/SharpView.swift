//
//  SharpView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import SwiftUI

// TODO: Make this neater, change pegViewModel to sharpViewModel
struct SharpView: View {

    @ObservedObject private var pegViewModel: PegViewModel
    @EnvironmentObject var canvasViewModel: CanvasViewModel

    private let name: String
    private var isHighlighted: Bool
    private var isDisappear: Bool
    private var isActive = false
    private let diameter = 50.0

    init(name: String, isHighlighted: Bool) {
        self.name = name
        self.pegViewModel = PegViewModel(name: name)
        self.isHighlighted = isHighlighted
        self.isDisappear = false
    }

    init(name: String, isActive: Bool, isDisappear: Bool) {
        self.name = name
        self.pegViewModel = PegViewModel(name: name)
        self.isHighlighted = true
        self.isActive = isActive
        self.isDisappear = isDisappear
    }

    var body: some View {
        ZStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .opacity(isHighlighted ? 1.0 : 0.3)
                .frame(maxWidth: diameter, maxHeight: diameter)
                .background(Color.red)
        }
    }
}
