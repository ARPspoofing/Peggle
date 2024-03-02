//
//  AmmoView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import SwiftUI

struct AmmoView: View {
    @State var colorOpacity = 0.5
    @State var materialOpacity = 0.5
    let motionX: CGFloat = 100
    let motionYMultiple: CGFloat = 50
    let motion = "motion"
    let velocity = Vector(horizontal: 3.0, vertical: 3.0)

    var body: some View {
        ZStack {
            ForEach(Array(1...10), id: \.self) { index in
                let object = MotionObject(center: Point(xCoord: motionX,
                                                        yCoord: Double(index) * motionYMultiple),
                                          name: motion, velocity: velocity)
                customMotionObjectView(object: object, index: index)
            }
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
