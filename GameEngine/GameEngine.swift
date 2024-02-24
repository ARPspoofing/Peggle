//
//  GameEngineBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 9/2/24.
//

import Foundation
import SwiftUI

///*
class GameEngine: GameEngineBody, ObservableObject {

    private let framesPerSecond = 120
    var displayLink: CADisplayLink?
    weak var gameEngineDelegate: GameEngineDelegate?

    override var motionObjects: [MotionObject] {
        didSet {
            handleMotionObjectsUpdate()
        }
    }

    func stop() {
            displayLink?.invalidate()
            displayLink = nil
        }

    override init(motionObjects: inout [MotionObject],
                  gameObjects: inout [GameObject],
                  captureObjects: inout [CaptureObject]) {
        super.init(motionObjects: &motionObjects, gameObjects: &gameObjects, captureObjects: &captureObjects)
        self.motionObjects = motionObjects

        displayLink = CADisplayLink(target: self, selector: #selector(updateBallPosition))
        displayLink?.preferredFramesPerSecond = framesPerSecond
        displayLink?.add(to: .main, forMode: .common)
    }

    private func triggerUpdates() {
        gameEngineDelegate?.gameEngineDidUpdate()
    }

    @objc override func updateBallPosition() {
        super.updateBallPosition()
        triggerUpdates()
    }

    private func handleMotionObjectsUpdate() {
        // Handle the update, such as triggering game logic, notifying delegates, etc.
        //triggerUpdates()
    }
}
//*/


/*
import SwiftUI

class GameEngine: GameEngineBody, ObservableObject {

    private let framesPerSecond = 120
    var displayLink: CADisplayLink?
    weak var gameEngineDelegate: GameEngineDelegate?

    override init(motionObjects: inout [MotionObject],
                  gameObjects: inout [GameObject],
                  captureObjects: inout [CaptureObject]) {
        super.init(motionObjects: &motionObjects, gameObjects: &gameObjects, captureObjects: &captureObjects)

        displayLink = CADisplayLink(target: self, selector: #selector(updateBallPosition))
        displayLink?.preferredFramesPerSecond = framesPerSecond
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func triggerUpdates() {
        gameEngineDelegate?.gameEngineDidUpdate()
    }

    @objc override func updateBallPosition() {
        print(motionObjects.count)
        super.updateBallPosition()
        triggerUpdates()
    }
}
*/
