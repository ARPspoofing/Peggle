//
//  PaletteButtonView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct PegView: View {

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
            if isActive {
                ActivePegView(
                    name: name,
                    isDisappear: isDisappear,
                    isShowingCircle: canvasViewModel.isShowingCircle,
                    diameter: diameter,
                    isDoneShooting: $canvasViewModel.isDoneShooting,
                    isAnimating: $canvasViewModel.isAnimating
                )
            } else {
                InactivePegView(
                    name: name,
                    isHighlighted: isHighlighted,
                    selectedAlpha: pegViewModel.selectedAlpha,
                    unselectedAlpha: pegViewModel.unselectedAlpha
                )
            }
        }
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView(name: Constants.normalObject, isHighlighted: false).previewInterfaceOrientation(.landscapeLeft)
    }
}
