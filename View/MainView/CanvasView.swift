//
//  Canvas.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import SwiftUI

struct CanvasView: View {
    @StateObject var canvasViewModel = CanvasViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            backgroundDisplay
            motionObjectDisplay
            captureObjectDisplay
            if canvasViewModel.isStartState {
                ShooterView(canvasViewModel)
            }
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
    }
}

extension CanvasView {
    private var shooterDisplay: some View {
        ShooterView(canvasViewModel)
    }
}

// TODO: Make this neater
extension CanvasView {
    private var gameObjectsDisplay: some View {
        ZStack {
            ForEach(canvasViewModel.gameObjects, id: \.self) { object in
                if let index = canvasViewModel.gameObjects.firstIndex(of: object) {
                    ZStack {
                        if ((object as? Peg) != nil) {
                            customPegView(object: object, index: index)
                        } else if ((object as? TriangularMovableObject) != nil) {
                            customSharpView(object: object, index: index)
                        }
                    }
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
        ForEach(canvasViewModel.motionObjects.indices, id: \.self) { index in
            let object = canvasViewModel.motionObjects[index]
            customMotionObjectView(object: object, index: index)
        }
    }
}

extension CanvasView {
    private var captureObjectDisplay: some View {
        ForEach(canvasViewModel.captureObjects.indices, id: \.self) { index in
            let object = canvasViewModel.captureObjects[index]
            customMotionObjectView(object: object, index: index)
        }
    }
}

extension CanvasView {
    private func customPegView(object: GameObject, index: Int) -> some View {
        ZStack {
            PegView(name: object.name, isActive: object.isActive, isDisappear: object.isDisappear)
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
                            canvasViewModel.updateObjectPosition(index: index, dragLocation: value.location)
                        }
                        .onEnded { _ in }
                )
        }
    }
}

extension CanvasView {
    private func customSharpView(object: GameObject, index: Int) -> some View {
        ZStack {
            SharpView(name: object.name, isActive: object.isActive, isDisappear: object.isDisappear)
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
                            canvasViewModel.updateTrianglePosition(index: index, dragLocation: value.location)
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

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
