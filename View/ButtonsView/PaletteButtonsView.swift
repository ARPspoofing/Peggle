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
            Spacer().frame(width: constants.rotateWidth)
            resizeOptionDisplay
            Spacer().frame(width: constants.resizeWidth)
            deleteOptionDisplay
        }
        .padding([.leading, .trailing], constants.leadingPadding)
    }
}

extension PaletteButtonsView {
    private var pegOptionsDisplay: some View {
        VStack {
            ForEach(0..<2) { rowIndex in
                HStack {
                    ForEach(0..<8) { columnIndex in
                        let index = rowIndex * 8 + columnIndex
                        if index < viewModel.paletteObjects.count {
                            let selectedObject = viewModel.paletteObjects[index]
                            ObjectView(name: selectedObject,
                                       isHighlighted: viewModel.selectedObject == selectedObject,
                                       width: constants.objectWidth)
                            .onTapGesture { _ in
                                viewModel.tapObject(selectedObject)
                            }
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }.scaleEffect(constants.paletteButtonsScale, anchor: .leading)

    }
}

extension PaletteButtonsView {
    private func optionDisplay<Content: View>(content: Content,
                                              isSelected: Bool,
                                              scale: CGFloat,
                                              onTap: @escaping () -> Void,
                                              size: CGFloat) -> some View {
        HStack {
            content
                .opacity(isSelected ? constants.selectedAlpha : constants.unselectedAlpha)
        }
        .scaleEffect(scale, anchor: .trailing)
        .onTapGesture {
            onTap()
        }
        .frame(height: size)
    }
}

extension PaletteButtonsView {
    private var deleteOptionDisplay: some View {
        optionDisplay(content: DeleteButtonView(),
                      isSelected: viewModel.isDeleteState,
                      scale: constants.deleteButtonScale,
                      onTap: viewModel.toggleDeleteState,
                      size: constants.deleteSize)
    }
}

extension PaletteButtonsView {
    private var resizeOptionDisplay: some View {
        optionDisplay(content: ResizeButtonView(),
                      isSelected: viewModel.isResizeState,
                      scale: constants.resizeButtonScale,
                      onTap: viewModel.toggleResizeState,
                      size: constants.resizeSize)
    }
}

extension PaletteButtonsView {
    private var rotateOptionDisplay: some View {
        optionDisplay(content: RotateButtonView(),
                      isSelected: viewModel.isRotateState,
                      scale: constants.rotateButtonScale,
                      onTap: viewModel.toggleRotateState,
                      size: constants.rotateSize)
    }
}

struct PegButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonsView().previewInterfaceOrientation(.landscapeLeft)
    }
}
