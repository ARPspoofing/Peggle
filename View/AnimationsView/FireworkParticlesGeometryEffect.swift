//
//  FireworkParticlesGeometryEffect.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

struct FireworkParticlesGeometryEffect: GeometryEffect, ViewModifier {
    var time: Double
    var speed = Double.random(in: 20 ... 100)
    var direction = Double.random(in: -Double.pi ... Double.pi)
    var translationDivisor = 1.5

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = (speed * cos(direction) * time) / translationDivisor
        let yTranslation = (speed * sin(direction) * time) / translationDivisor
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
