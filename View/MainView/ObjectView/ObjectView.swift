//
//  PaletteButtonView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct ObjectView: View {

    @ObservedObject private var pegViewModel: ObjectViewModel
    @EnvironmentObject var canvasViewModel: CanvasViewModel

    private let name: String
    private var isHighlighted: Bool
    private var isDisappear: Bool
    private var health: Double = 100.0
    private var isNoHealth = false
    private var isPalette = false
    private var isActive = false
    private var diameter = 50.0
    private var orientation: CGFloat = 0.0

    init(name: String, isHighlighted: Bool) {
        self.name = name
        self.pegViewModel = ObjectViewModel(name: name)
        self.isHighlighted = isHighlighted
        self.isDisappear = false
    }

    init(name: String, isHighlighted: Bool, width: CGFloat) {
        self.name = name
        self.pegViewModel = ObjectViewModel(name: name)
        self.isHighlighted = isHighlighted
        self.isDisappear = false
        self.diameter = width * 2
    }

    init(name: String, isActive: Bool, isDisappear: Bool, width: CGFloat, orientation: CGFloat) {
        self.name = name
        self.pegViewModel = ObjectViewModel(name: name)
        self.isHighlighted = true
        self.isActive = isActive
        self.isDisappear = isDisappear
        self.diameter = width * 2
        self.orientation = orientation
    }

    init(name: String, isActive: Bool, isDisappear: Bool,
         width: CGFloat, orientation: CGFloat,
         isNoHealth: Bool, health: Double) {
        self.name = name
        self.pegViewModel = ObjectViewModel(name: name)
        self.isHighlighted = true
        self.isActive = isActive
        self.isDisappear = isDisappear
        self.diameter = width * 2
        self.orientation = orientation
        self.isNoHealth = isNoHealth
        self.health = health
    }

    var body: some View {
        ZStack {
            if isActive {
                ActiveObjectView(
                    name: name,
                    isDisappear: isDisappear,
                    isShowingCircle: canvasViewModel.isShowingCircle,
                    diameter: diameter,
                    isNoHealth: isNoHealth,
                    health: health,
                    orientation: orientation,
                    isDoneShooting: $canvasViewModel.isDoneShooting,
                    isAnimating: $canvasViewModel.isAnimating
                )
            } else {
                InactiveObjectView(
                    name: name,
                    isHighlighted: isHighlighted,
                    selectedAlpha: pegViewModel.selectedAlpha,
                    unselectedAlpha: pegViewModel.unselectedAlpha,
                    diameter: diameter,
                    orientation: orientation
                )
            }
        }
    }
}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectView(name: Constants.normalObject, isHighlighted: false).previewInterfaceOrientation(.landscapeLeft)
    }
}
