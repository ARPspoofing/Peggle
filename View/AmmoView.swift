//
//  AmmoView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import SwiftUI

/*
struct AmmoView: View {

    @EnvironmentObject var viewModel: CanvasViewModel

    var body: some View {
        /*
        ForEach(viewModel.motionObjects.indices, id: \.self) { index in
            let object = viewModel.motionObjects[index]
            customMotionObjectView(object: object, index: index)
        }
        */

        MotionObjectView().position(x: 200, y: 200)
        MotionObjectView().position(x: 200, y: 200)
        MotionObjectView().position(x: 200, y: 200)
        MotionObjectView().position(x: 200, y: 200)

        /*
        ForEach(Array(1...10), id: \.self) { index in
            let object = MotionObject(center: Point(xCoord: Double(index) + 200, yCoord: Double(index) + 200), name: "motion", velocity: Vector(horizontal: 3.0, vertical: 3.0))
            customMotionObjectView(object: object, index: index)
        }
        */
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
*/

struct AmmoView: View {

    @State var colorOpacity = 0.5
    @State var materialOpacity = 0.5
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                // TODO: Might remove Material
                ZStack {
                    //Image("motionObject")
                    ForEach(Array(1...10), id: \.self) { index in
                        let object = MotionObject(center: Point(xCoord: 100, yCoord: Double(index) * 50), name: "motion", velocity: Vector(horizontal: 3.0, vertical: 3.0))
                        customMotionObjectView(object: object, index: index)
                    }
                    Rectangle()
                        .fill(
                            Material.thin
                        )
                        .frame(width: .infinity, height: .infinity)
                        .opacity(materialOpacity)
                    Color(
                        red: 255/255,
                        green: 255/255,
                        blue: 255/255,
                        opacity: colorOpacity)
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .border(
                    Color(
                        red: 255/255,
                        green: 255/255,
                        blue: 255/255,
                        opacity: 0.1
                    )
                )
                .cornerRadius(15)
                .frame(height: 300)
                Spacer()
                VStack(spacing: 0) {
                    Text("Material Opacity:")
                    Slider(value: $materialOpacity)
                }
                .padding()

                VStack(spacing: 0) {
                    Text("Color Opacity:")
                    Slider(value: $colorOpacity)
                }
                .padding()
                Spacer()
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
