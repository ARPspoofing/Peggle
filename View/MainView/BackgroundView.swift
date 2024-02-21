//
//  Background.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    private let background = "background"

    var body: some View {
        GeometryReader { _ in
            Image(background)
                .resizable()
                .scaledToFill()
                .statusBar(hidden: true)
                .frame(width: Constants.screenWidth,
                       height: viewModel.isStartState ? Constants.gameHeight : Constants.canvasHeight)
        }
    }

    struct BackgroundView_Previews: PreviewProvider {
        static var previews: some View {
            BackgroundView().previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
