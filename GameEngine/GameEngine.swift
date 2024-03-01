//
//  GameEngineBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 9/2/24.
//

import Foundation
import SwiftUI

class GameEngine: GameEngineBody, ObservableObject {

    private let framesPerSecond = 120
    var displayLink: CADisplayLink?
    weak var gameEngineDelegate: GameEngineDelegate?

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    override init(motionObjects: inout [MotionObject],
                  gameObjects: inout [GameObject],
                  captureObjects: inout [CaptureObject],
                  ammo: inout [MotionObject]) {
        super.init(motionObjects: &motionObjects,
                   gameObjects: &gameObjects,
                   captureObjects: &captureObjects,
                   ammo: &ammo)

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
}
