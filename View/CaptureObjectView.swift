//
//  CaptureObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

import SwiftUI

// TODO: Make it not depend on radius, change image
struct CaptureObjectView: View {

    private let name: String = "motionObject"
    private var isHighlighted = false
    private let defaultDiameter = 50.0

    var body: some View {
        Image(name)
            .resizable()
            .frame(width: defaultDiameter, height: defaultDiameter)
    }
}
