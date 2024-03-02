//
//  RadiatingCircleView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/2/24.
//

import SwiftUI

// TODO: Fix radiating circles when shoot cannon while animating
struct RadiatingCirclesView: View {
    let isDisplay: Bool
    let name: String
    let diameter: CGFloat
    let lightBlue = Color(red: 117 / 255, green: 251 / 255, blue: 253 / 255)
    let lightOrange = Color(red: 240 / 255, green: 200 / 255, blue: 200 / 255)
    let darkOrange = Color(red: 252 / 255, green: 169 / 255, blue: 3 / 255)
    let lightPurple = Color(red: 191 / 255, green: 144 / 255, blue: 223 / 255)
    let purple = Color(red: 148 / 255, green: 0 / 255, blue: 211 / 255)
    let lightGreen = Color(red: 144/255, green: 238/255, blue: 144/255)
    let green = Color(red: 0/255, green: 128/255, blue: 0/255)
    let blue = Color.blue
    let orange = Color.orange



    static let sharpObjectActive = "sharpBlockActive"
    static let obstacleObjectActive = "obstacleObjectActive"
    static let actionObjectSharpActive = "actionObjectSharpActive"
    static let bounceObjectActive = "bounceObjectActive"
    static let bounceObjectSharpActive = "bounceObjectSharpActive"
    static let glowObjectActive = "glowObjectActive"
    static let motionObjectSharpActive = "motionObjectSharpActive"
    static let normalObjectSharpActive = "normalObjectSharpActive"
    static let oscillateObjectSharpActive = "oscillateObjectSharpActive"
    static let reappearObjectSharpActive = "reappearObjectSharpActive"
    static let solidObjectActive = "solidObjectActive"
    static let solidObjectSharpActive = "solidObjectSharpActive"


    let multiplier = 5
    let animationDuration = 0.3
    let even = 2
    let lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            ForEach(0..<5) { index in
                Circle()
                    .stroke(
                        name == Constants.normalObjectActive ?
                        (index.isMultiple(of: even) ? lightBlue : blue) :
                            (name == Constants.actionObjectActive ?
                        (index.isMultiple(of: even) ? lightOrange : darkOrange) :
                                (name == Constants.oscillateObjectActive ?
                        (index.isMultiple(of: even) ? lightPurple : purple) :
                                    (name == Constants.reappearObjectActive ?
                        (index.isMultiple(of: even) ? lightGreen : green) :
                        orange)
                        )),
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
