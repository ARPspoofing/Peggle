//
//  FireworkParticlesGeometryEffect.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

struct FireworkParticlesGeometryEffect: GeometryEffect, ViewModifier {
    var isBlast: Bool
    var time: Double
    var speed: Double
    var direction = Double.random(in: -Double.pi ... Double.pi)
    var translationScale = 0.8

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        var xTranslation = (speed * cos(direction) * time) * 1.5
        var yTranslation = (speed * sin(direction) * time) * 1.5
        if !isBlast {
            xTranslation *= translationScale
            yTranslation *= translationScale
        }
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
