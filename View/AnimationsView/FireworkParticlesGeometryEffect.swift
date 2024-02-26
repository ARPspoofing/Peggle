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
    var speed = 20.0 /*Double.random(in: 20 ... 100)*/
    var direction = Double.random(in: -Double.pi ... Double.pi)
    var translationDivisor = 1.5

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        var xTranslation = (speed * cos(direction) * time) * 1.2
        var yTranslation = (speed * sin(direction) * time) * 1.2
        if !isBlast {
            xTranslation = xTranslation / translationDivisor
            yTranslation = yTranslation / translationDivisor
        }
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
