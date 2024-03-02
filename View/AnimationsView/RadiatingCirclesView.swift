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

    let lightBlue = Constants.lightBlue
    let lightOrange = Constants.lightOrange
    let darkOrange = Constants.darkOrange
    let lightPurple = Constants.lightPurple
    let purple = Constants.purple
    let lightGreen = Constants.lightGreen
    let green = Constants.green
    let lightPink = Constants.lightPink
    let gold = Constants.gold
    let lightGray = Constants.lightGray
    let blue = Constants.blue
    let orange = Constants.orange
    let pink = Constants.pink
    let yellow = Constants.yellow
    let grey = Constants.grey
    let lightBrown = Constants.desertLightBrown
    let darkBrown = Constants.desertDarkBrown

    let multiplier = 5
    let animationDuration = 0.3
    let even = 2
    let lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            ForEach(0..<5) { index in

                let strokeColorMap: [String: Color] = [
                    Constants.normalObjectActive: index.isMultiple(of: even) ? lightBlue : blue,
                    Constants.actionObjectActive: index.isMultiple(of: even) ? lightOrange : darkOrange,
                    Constants.oscillateObjectActive: index.isMultiple(of: even) ? lightPurple : purple,
                    Constants.reappearObjectActive: index.isMultiple(of: even) ? lightGreen : green,
                    Constants.sharpObjectActive: index.isMultiple(of: even) ? lightBrown : darkBrown,
                    Constants.bounceObjectActive: index.isMultiple(of: even) ? lightPink : pink,
                    Constants.glowObjectActive: index.isMultiple(of: even) ? yellow : gold,
                    Constants.solidObjectActive: index.isMultiple(of: even) ? grey : lightGray,
                ]

                Circle()
                    .stroke(strokeColorMap[name] ?? orange, lineWidth: lineWidth)
                    .frame(width: diameter - CGFloat(index * multiplier),
                           height: diameter - CGFloat(index * multiplier))
                    .opacity(isDisplay ? 1 : 0)
                    .animation(Animation.linear(duration: animationDuration), value: isDisplay)
            }
        }
    }
}
