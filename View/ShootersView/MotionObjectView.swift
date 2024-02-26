//
//  MotionObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 7/2/24.
//

import SwiftUI

struct MotionObjectView: View {

    private let name: String = "motionObject"
    private var isHighlighted = false
    private let defaultDiameter = 50.0

    var body: some View {
        Image(name)
            .resizable()
            .frame(width: defaultDiameter, height: defaultDiameter)
    }
}

struct MotionObjectView_Previews: PreviewProvider {
    static var previews: some View {
        MotionObjectView()
    }
}
