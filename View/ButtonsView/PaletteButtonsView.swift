//
//  PaletteOptionsView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct PaletteButtonsView: View {

    private let constants = PaletteButtonsConstants()

    @EnvironmentObject var viewModel: CanvasViewModel

    var body: some View {
            HStack {
                pegOptionsDisplay
                Spacer()
                rotateOptionDisplay
                Spacer()
                resizeOptionDisplay
                Spacer()
                deleteOptionDisplay
            }
            .padding([.leading, .trailing], constants.leadingPadding)
        }
}

extension PaletteButtonsView {
    private var pegOptionsDisplay: some View {
        HStack {
            ForEach(viewModel.paletteObjects, id: \.self) { selectedObject in
                ObjectView(name: selectedObject, isHighlighted: viewModel.selectedObject == selectedObject)
                    .onTapGesture {_ in
                        viewModel.tapObject(selectedObject)
                    }
            }
        }.scaleEffect(constants.paletteButtonsScale, anchor: .leading)
    }
}

extension PaletteButtonsView {
    private var deleteOptionDisplay: some View {
        HStack {
            DeleteButtonView()
                .opacity(viewModel.isDeleteState ? constants.selectedAlpha : constants.unselectedAlpha)
        }.scaleEffect(constants.deleteButtonScale, anchor: .trailing)
            .onTapGesture {
                viewModel.toggleDeleteState()
            }
            .frame(height: constants.deleteSize)
    }
}

extension PaletteButtonsView {
    private var resizeOptionDisplay: some View {
        HStack {
            ResizeButtonView()
                .opacity(viewModel.isResizeState ? constants.selectedAlpha : constants.unselectedAlpha)
        }.scaleEffect(constants.resizeButtonScale, anchor: .trailing)
            .onTapGesture {
                viewModel.toggleResizeState()
            }
            .frame(height: constants.resizeSize)
    }
}

extension PaletteButtonsView {
    private var rotateOptionDisplay: some View {
        HStack {
            RotateButtonView()
                .opacity(viewModel.isRotateState ? constants.selectedAlpha : constants.unselectedAlpha)
        }.scaleEffect(constants.rotateButtonScale, anchor: .trailing)
            .onTapGesture {
                viewModel.toggleRotateState()
            }
            .frame(height: constants.rotateSize)
    }
}

struct PegButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonsView().previewInterfaceOrientation(.landscapeLeft)
    }
}
