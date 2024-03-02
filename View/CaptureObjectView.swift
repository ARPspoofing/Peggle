//
//  CaptureObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

import SwiftUI

struct CaptureObjectView: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    let name: String = "captureObjectItem"
    let width: Double
    let height: Double
    var isHighlighted = false
    let defaultDiameter = 50.0

    var body: some View {

        ZStack {
            if viewModel.isReload {
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                    .modifier(ParticlesModifier(isBlast: true, isDoneShooting: $viewModel.isReload))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            viewModel.isReload = false
                        }
                    }
            }
            Image(name)
                .resizable()
                .frame(width: CGFloat(width), height: CGFloat(height))
        }

    }
}
