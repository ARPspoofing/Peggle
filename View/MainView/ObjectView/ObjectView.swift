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
    private var isActive = false
    private var diameter = 50.0
    private var orientation: CGFloat = 0.0
    private var centerX: Double = 0.0
    private var centerY: Double = 0.0
    private var top: Point = Point(xCoord: 0.0, yCoord: 0.0)
    private var left: Point = Point(xCoord: 0.0, yCoord: 0.0)
    private var right: Point = Point(xCoord: 0.0, yCoord: 0.0)

    // TODO: Remove redundant init
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

    init(name: String, isActive: Bool, isDisappear: Bool, width: CGFloat, orientation: CGFloat, centerX: Double, centerY: Double/*, top: Point, left: Point, right: Point*/) {
        self.name = name
        self.pegViewModel = ObjectViewModel(name: name)
        self.isHighlighted = true
        self.isActive = isActive
        self.isDisappear = isDisappear
        self.diameter = width * 2
        self.orientation = orientation
        self.centerX = centerX
        self.centerY = centerY
        /*
        self.top = top
        self.left = left
        self.right = right
        */
    }

    var body: some View {
        ZStack {
            if isActive {
                ActiveObjectView(
                    name: name,
                    isDisappear: isDisappear,
                    isShowingCircle: canvasViewModel.isShowingCircle,
                    diameter: diameter,
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
                    orientation: orientation,
                    centerX: centerX,
                    centerY: centerY
                    /*
                    top: top,
                    left: left,
                    right: right
                    */
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
