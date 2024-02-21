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

struct ActivePegView: View {
    var name: String
    var isDisappear: Bool
    var isShowingCircle: Bool
    var diameter: CGFloat
    var activeName = "Active"
    @Binding var isDoneShooting: Bool
    @Binding var isAnimating: Bool

    var body: some View {
        ImageWithOverlay(
            imageName: name + activeName,
            isDisappear: isDisappear,
            isShowingCircle: isShowingCircle,
            diameter: diameter,
            isDoneShooting: $isDoneShooting,
            isAnimating: $isAnimating
        )
    }
}

struct ImageWithOverlay: View {
    var imageName: String
    var isDisappear: Bool
    var isShowingCircle: Bool
    var diameter: CGFloat
    var initialDiameter: CGFloat = 50.0
    @Binding var isDoneShooting: Bool
    @Binding var isAnimating: Bool

    var body: some View {
        if isDoneShooting {
            Image(imageName)
                .opacity(0)
            ParticlesOverlay()
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .opacity(isDisappear || isDoneShooting ? 0 : 1)
                .frame(maxWidth: initialDiameter, maxHeight: initialDiameter)
                .overlay(
                    CirclesOverlay(
                        isDisplay: isShowingCircle,
                        name: imageName,
                        diameter: diameter,
                        isAnimating: $isAnimating
                    )
                )
        }
    }
}

struct CirclesOverlay: View {
    @State var isDisplay: Bool
    var name: String
    var diameter: CGFloat
    @Binding var isAnimating: Bool
    var largeScale = 1.8
    var normalScale = 1.0
    var delay = 0.3

    var body: some View {
        ZStack {
            RadiatingCirclesView(isDisplay: isDisplay, name: name, diameter: diameter)
                .active()
                .scaleEffect(isDisplay ? largeScale : normalScale)
                .opacity(isDisplay ? 1 : 0)
                .onAppear {
                    isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(.easeInOut(duration: delay)) {
                            isDisplay = false
                        }
                    }
                }
                .onDisappear {
                    isAnimating = false
                }
        }
    }
}

struct ParticlesOverlay: View {
    @State private var shouldAnimate = false
    var initialDiameter: CGFloat = 60
    var additionalPadding: CGFloat = 20
    var body: some View {
        ZStack {
            JaggedCircle()
                        .fill(Color.white)
                        .frame(width: initialDiameter, height: initialDiameter)
            Circle()
                .fill(Color.red)
                .frame(width: additionalPadding, height: additionalPadding)
                .modifier(ParticlesModifier())
        }
    }
}

struct JaggedCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.width, rect.size.height) / 2

        let numberOfPoints = 50
        let angleStep = .pi * 2 / CGFloat(numberOfPoints)
        let smallRadiusScale = 0.8
        let largeRadiusScale = 1.2

        for i in 0..<numberOfPoints {
            let angle = angleStep * CGFloat(i)
            let randomRadius = CGFloat.random(in: radius * smallRadiusScale...radius * largeRadiusScale)
            let x = center.x + randomRadius * cos(angle)
            let y = center.y + randomRadius * sin(angle)

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()

        return path
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView(name: Constants.normalObject, isHighlighted: false).previewInterfaceOrientation(.landscapeLeft)
    }
}
