//
//  RadiatingCircleView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/2/24.
//

import SwiftUI

struct RadiatingCirclesView: View {
    let isDisplay: Bool
    let name: String
    let diameter: CGFloat
    let lightBlue = Color(red: 117 / 255, green: 251 / 255, blue: 253 / 255)
    let lightOrange = Color(red: 240 / 255, green: 200 / 255, blue: 200 / 255)
    let darkOrange = Color(red: 252 / 255, green: 169 / 255, blue: 3 / 255)
    let blue = Color.blue
    let orange = Color.orange
    let normalObject = "normalObjectActive"
    let actionObject = "actionObjectActive"
    let multiplier = 5
    let animationDuration = 0.3
    let even = 2
    let lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            ForEach(0..<5) { index in
                Circle()
                    .stroke(
                        name == normalObject ?
                        (index.isMultiple(of: even) ? lightBlue : blue) :
                        (name == actionObject ?
                         (index.isMultiple(of: even) ? lightOrange : darkOrange) :
                         orange),
                        lineWidth: lineWidth
                    )
                    // TODO: Fix invalid frame dimension negative or infinite
                    .frame(width: diameter - CGFloat(index * multiplier),
                           height: diameter - CGFloat(index * multiplier))
                    .opacity(isDisplay ? 1 : 0)
                    .animation(Animation.linear(duration: animationDuration), value: isDisplay)
            }
        }
    }
}
