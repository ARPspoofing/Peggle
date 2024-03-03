//
//  CanvasView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct CanvasView: View {
    @StateObject var canvasViewModel = CanvasViewModel()
    let glass = "glass"
    let centerY = 250.0 / 2.0
    let glassOpacity: CGFloat = 0.55
    let glassWidth: CGFloat = 80
    let glassHeight: CGFloat = Constants.gameHeight - 300
    let glassX: CGFloat = 25
    let glassY: CGFloat = Constants.gameHeight / 2 - 100

    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                backgroundDisplay
                if canvasViewModel.isStartState {
                    glassDisplay
                }
            }
            motionObjectDisplay
            captureObjectDisplay
            if canvasViewModel.isStartState {
                ShooterView(canvasViewModel)
                ammoDisplay
            }
            gameObjectsDisplay
            if !canvasViewModel.isStartState {
                PaletteView()
            }
            if canvasViewModel.isGameOver && canvasViewModel.isStartState {
                GameOverView()
            }
        }
        .environmentObject(canvasViewModel)
    }
}

extension CanvasView {
    private var backgroundDisplay: some View {
        ZStack(alignment: .top) {
            BackgroundView()
                .gesture(DragGesture().onChanged({ value in
                    canvasViewModel.backgroundOnDragGesture(point: Point(xCoord: value.location.x,
                                                                         yCoord: value.location.y))
                }))
                .gesture(DragGesture(minimumDistance: 0)
                    .onEnded { coordinate in
                        if canvasViewModel.isStartState {
                            canvasViewModel.shootBall()
                        } else {
                            guard let selectedObject = canvasViewModel.selectedObject else {
                                return
                            }
                            canvasViewModel.render(coordinate.location, selectedObject)
                        }
                    }
                )
            StatusView()
        }
    }
}

extension CanvasView {
    private var shooterDisplay: some View {
        ShooterView(canvasViewModel)
    }
}

extension CanvasView {
    private var gameObjectsDisplay: some View {
        ZStack {
            ForEach(canvasViewModel.gameObjects, id: \.self) { object in
                if let index = canvasViewModel.gameObjects.firstIndex(of: object) {
                    Group {
                        customObjectView(object: object, index: index)
                    }
                    .transition(.opacity.animation(
                        Animation.easeInOut(duration: canvasViewModel.isStartState && object.health == 0.0 ? 1.0 : 0.0)
                            .delay({
                                let delayValue = Double(object.activeIdx) / 5
                                return delayValue
                            }())
                    )
                    )
                }
            }
        }
        .animation(
            canvasViewModel.isStartState && !canvasViewModel.isDoneShooting ?
            Animation.easeInOut(duration: 0.3) :
                (canvasViewModel.isDoneShooting ? Animation.easeInOut(duration: 1.0) : .none)
        )
    }
}

extension CanvasView {
    private var motionObjectDisplay: some View {
        ZStack {
            ForEach(canvasViewModel.motionObjects.indices, id: \.self) { index in
                let object = canvasViewModel.motionObjects[index]
                customMotionObjectView(object: object, index: index)
            }
        }
    }
}

extension CanvasView {
    private var captureObjectDisplay: some View {
        ForEach(canvasViewModel.captureObjects.indices, id: \.self) { index in
            let object = canvasViewModel.captureObjects[index]
            customCaptureObjectView(object: object, index: index, width: object.width, height: object.height)
        }
    }
}

extension CanvasView {
    private var ammoDisplay: some View {
        ForEach(canvasViewModel.remainingAmmo.indices, id: \.self) { index in
            let object = canvasViewModel.remainingAmmo[index]
            customMotionObjectView(object: object, index: index)
        }
    }
}

extension CanvasView {
    private func customObjectView(object: GameObject, index: Int) -> some View {
        ZStack {
            ObjectView(name: object.name, isActive: object.isActive,
                       isDisappear: object.isDisappear, width: object.halfWidth,
                       orientation: object.orientation, isNoHealth: object.health == 0,
                       health: object.health)
            .position(x: object.retrieveXCoord(), y: object.retrieveYCoord())
            .onTapGesture {
                handleTapGesture(index)
            }
            .onLongPressGesture(minimumDuration: Constants.longDuration) {
                handleLongPressGesture(index)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        handleDragGestureChange(index, value)
                    }
                    .onEnded { _ in }
            )
        }
    }

    private func handleTapGesture(_ index: Int) {
        guard !canvasViewModel.isStartState else {
            return
        }
        if canvasViewModel.isDeleteState {
            canvasViewModel.removeAndRender(removeObjectIndex: index)
        }
    }

    private func handleLongPressGesture(_ index: Int) {
        guard !canvasViewModel.isStartState else {
            return
        }
        canvasViewModel.removeAndRender(removeObjectIndex: index)
    }

    private func handleDragGestureChange(_ index: Int, _ value: DragGesture.Value) {
        guard !canvasViewModel.isStartState else {
            return
        }
        if canvasViewModel.isResizeState {
            canvasViewModel.updateObjectWidth(index: index, dragLocation: value.location)
        } else if canvasViewModel.isRotateState {
            canvasViewModel.updateObjectOrientation(index: index, dragLocation: value.location)
        } else {
            canvasViewModel.updateObjectPosition(index: index, dragLocation: value.location)
        }
    }
}

extension CanvasView {
    private func customMotionObjectView(object: GameObject, index: Int) -> some View {
        MotionObjectView()
            .position(x: object.retrieveXCoord(), y: object.retrieveYCoord())
    }
}

extension CanvasView {
    private func customCaptureObjectView(object: GameObject, index: Int, width: Double, height: Double) -> some View {
        ZStack {
            CaptureObjectView(width: width, height: height)
                .position(x: object.retrieveXCoord(), y: object.retrieveYCoord())
        }
    }
}

extension CanvasView {
    private var glassDisplay: some View {
        Image(glass)
            .resizable()
            .opacity(glassOpacity)
            .frame(width: glassWidth, height: glassHeight)
            .position(x: glassX, y: glassY)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
