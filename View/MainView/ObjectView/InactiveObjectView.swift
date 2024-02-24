//
//  InactiveObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/2/24.
//

import SwiftUI

struct InactiveObjectView: View {
    var name: String
    var isHighlighted: Bool
    var selectedAlpha: Double
    var unselectedAlpha: Double
    var diameter: CGFloat
    var orientation: CGFloat
    /*
    var top: Point
    var left: Point
    var right: Point
    */
    var centerX: Double
    var centerY: Double

    var body: some View {
        ZStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .opacity(isHighlighted ? selectedAlpha : unselectedAlpha)
                .frame(width: diameter, height: diameter)
                .rotationEffect(.radians(orientation))
            /*
            if centerX != 0 {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                    .position(x: CGFloat(centerX), y: CGFloat(centerY))
            }
            */
        }

        /*
            // Dot for the left point
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
                .position(x: CGFloat(left.xCoord), y: CGFloat(left.yCoord))

            // Dot for the right point
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
                .position(x: CGFloat(right.xCoord), y: CGFloat(right.yCoord))
        */
        //}


    }
}

/*
import SwiftUI

struct InactiveObjectView: View {
    var name: String
    var isHighlighted: Bool
    var selectedAlpha: Double
    var unselectedAlpha: Double
    var diameter: CGFloat
    var orientation: CGFloat

    var body: some View {
        return GeometryReader { geometry in
            /*
            let frame = geometry.frame(in: .local)
            Text("Top-left corner: (\(frame.minX), \(frame.minY)), Bottom-right corner: (\(frame.maxX), \(frame.maxY))")
                .foregroundColor(.red)
                .bold()
                .font(.title)
                .padding()
            */

            Image(name)
                .resizable()
                .scaledToFit()
                .opacity(isHighlighted ? selectedAlpha : unselectedAlpha)
                .frame(maxWidth: diameter, maxHeight: diameter)
                .background(Color.red)
                .rotationEffect(.radians(orientation))
        }
    }
}
*/

