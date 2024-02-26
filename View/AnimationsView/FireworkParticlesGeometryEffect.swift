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
    var translationDivisor = 1.5

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        //self.speed = isBlast ? Double.random(in: 20 ... 100) : 20.0
        var xTranslation = (speed * cos(direction) * time) * 1.5
        var yTranslation = (speed * sin(direction) * time) * 1.5
        if !isBlast {
            xTranslation = xTranslation / translationDivisor
            yTranslation = yTranslation / translationDivisor
        }
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
