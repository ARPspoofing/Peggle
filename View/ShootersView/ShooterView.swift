//
//  ShooterView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 6/2/24.
//

import SwiftUI

struct ShooterView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var isShootingImageVisible = false

    private let shooterBaseImage = "shooterBase"
    private let shooterBaseWidth: CGFloat = 150
    private let shooterBaseHeight: CGFloat = 150
    private let shooterBaseX: CGFloat = Constants.screenWidth / 2
    private let shooterBaseY: CGFloat = 80

    private let shooterHeadImage = "shooterHead"
    private let shooterHeadWidth: CGFloat = 75
    private let shooterHeadHeight: CGFloat = 100
    private let shooterHeadX = Constants.screenWidth / 2
    private let shooterHeadY: CGFloat = 100 + 80 / 2
    private let shooterHeadOffset: CGFloat = 10
    private let delay = 0.2
    private let unitX: CGFloat = 0.5

    init(_ viewModel: CanvasViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                shooterSight
                Image("scarab-beetle")
                    .resizable()
                    .frame(width: shooterBaseWidth, height: shooterBaseHeight)
                    .position(x: shooterBaseX, y: shooterBaseY)
                    .rotationEffect(.radians(viewModel.shooterRotation),
                                    anchor: UnitPoint(x: unitX, y: shooterBaseY / geometry.size.height))
                    .onReceive(viewModel.$isShooting) { shooting in
                        if shooting {
                            isShootingImageVisible = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                isShootingImageVisible = false
                            }
                        }
                    }
            }
        }
    }
}

extension ShooterView {
    private var shooterSight: some View {
        ZStack {
            if !viewModel.isGameOver {
                let endPointX = viewModel.pathEndPointX
                let endPointY = viewModel.pathEndPointY
                let numberOfDots = viewModel.pathCount

                ForEach(0..<numberOfDots, id: \.self) { index in
                    let progress = CGFloat(index) / CGFloat(numberOfDots - 1)
                    let x = viewModel.shooterPosition.xCoord + (endPointX - viewModel.shooterPosition.xCoord) * Double(progress)

                    let y: CGFloat = viewModel.shooterPosition.yCoord + (endPointY - viewModel.shooterPosition.yCoord) * Double(progress)

                    Circle()
                        .fill(Color.red.opacity(0.8))
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }
            }
        }
    }
}
