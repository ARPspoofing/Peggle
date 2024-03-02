//
//  CaptureObjectView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 21/2/24.
//

import SwiftUI

struct CaptureObjectView: View {

    let name: String = "captureObjectItem"
    let width: Double
    let height: Double
    var isHighlighted = false
    let defaultDiameter = 50.0

    var body: some View {
        Image(name)
            .resizable()
            .frame(width: CGFloat(width), height: CGFloat(height))
    }
}
