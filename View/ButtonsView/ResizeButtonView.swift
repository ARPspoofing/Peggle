//
//  ResizeButtonView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/2/24.
//

import SwiftUI

import SwiftUI

struct ResizeButtonView: View {
    var body: some View {
        let constants = ResizeButtonConstants()

        Image(constants.resize)
            .contentShape(Circle())
            .clipped()
            .contentShape(Circle())
            .frame(width: constants.defaultCircleRadius / 2,
                   height: constants.defaultCircleRadius / 2, alignment: .trailing)
    }
}
