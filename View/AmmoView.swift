//
//  AmmoView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import SwiftUI

// TODO: Remove magic numbers
struct AmmoView: View {

    @State var colorOpacity = 0.5
    @State var materialOpacity = 0.5
    var body: some View {
        let totalHeight = Double(Array(1...10).count) * 50.0
        let centerY = totalHeight / 2.0
        ZStack {
            ForEach(Array(1...10), id: \.self) { index in
                let object = MotionObject(center: Point(xCoord: 100, yCoord: Double(index) * 50), name: "motion", velocity: Vector(horizontal: 3.0, vertical: 3.0))
                customMotionObjectView(object: object, index: index)
            }
            Image("glass").position(x: 90, y: centerY)
                .opacity(0.55)
        }

    }
}

extension AmmoView {
    private func customMotionObjectView(object: GameObject, index: Int) -> some View {
        MotionObjectView()
            .position(x: object.retrieveXCoord(), y: object.retrieveYCoord())
    }
}

struct AmmoView_Previews: PreviewProvider {
    static var previews: some View {
        AmmoView()
    }
}
