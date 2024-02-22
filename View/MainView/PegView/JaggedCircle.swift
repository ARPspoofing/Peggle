//
//  JaggedCircle.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import Foundation
import SwiftUI

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
