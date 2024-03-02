//
//  CanvasView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

// TODO: Remove width and height if necessary
// TODOL Fix hackish implementation of balls at the side
struct CanvasView: View {
    @StateObject var canvasViewModel = CanvasViewModel()
    let centerY = 250.0 / 2.0

    var body: some View {
        // TODO: Add limitation to prevent adding ball on testtube
        ZStack(alignment: .top) {
            ZStack {
                backgroundDisplay
                glassDisplay
            }
            motionObjectDisplay
            captureObjectDisplay
            if canvasViewModel.isGameOver && canvasViewModel.isStartState {
                GameOverView()
            }
            if canvasViewModel.isStartState {
                ShooterView(canvasViewModel)
            }
            ammoDisplay
            gameObjectsDisplay
            if !canvasViewModel.isStartState {
                PaletteView()
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
            ObjectView(name: object.name, isActive: object.isActive, isDisappear: object.isDisappear, width: object.halfWidth, orientation: object.orientation, isNoHealth: object.health == 0, health: object.health)
                .position(x: object.retrieveXCoord(), y: object.retrieveYCoord())
                .onTapGesture {
                    guard !canvasViewModel.isStartState else {
                        return
                    }
                    if canvasViewModel.isDeleteState {
                        canvasViewModel.removeAndRender(removeObjectIndex: index)
                    }
                }
                .onLongPressGesture(minimumDuration: Constants.longDuration) {
                    guard !canvasViewModel.isStartState else {
                        return
                    }
                    canvasViewModel.removeAndRender(removeObjectIndex: index)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !canvasViewModel.isStartState else {
                                return
                            }
                            if canvasViewModel.isResizeState {
                                canvasViewModel.updateObjectWidth(index: index, dragLocation: value.location)
                            } else if canvasViewModel.isRotateState {
                                canvasViewModel.updateObjectOrientation(index: index,
                                                                        dragLocation: value.location)
                            } else {
                                canvasViewModel.updateObjectPosition(index: index, dragLocation: value.location)
                            }
                        }
                        .onEnded { _ in }
                )
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
            /*
            if let capture = object as? CaptureObject {
                Circle()
                    .stroke(Color.red, lineWidth: 5)
                    .frame(width: 5, height: 5)
                    .position(x: capture.topLine.start.xCoord, y: capture.topLine.start.yCoord)
                Circle()
                    .stroke(Color.red, lineWidth: 5)
                    .frame(width: 5, height: 5)
                    .position(x: capture.topLine.end.xCoord, y: capture.topLine.end.yCoord)
                Circle()
                    .stroke(Color.red, lineWidth: 5)
                    .frame(width: 5, height: 5)
                    .position(x: capture.bottomLeft.xCoord, y: capture.bottomLeft.yCoord)
                Circle()
                    .stroke(Color.red, lineWidth: 5)
                    .frame(width: 5, height: 5)
                    .position(x: capture.bottomRight.xCoord, y: capture.bottomRight.yCoord)
            }
            */
        }
    }
}

extension CanvasView {
    private var glassDisplay: some View {
        Image("glass")
        .opacity(0.55)
        .position(x: 50, y: 650)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
