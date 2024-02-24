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
        // TODO: Modify constants to be for resize
        let constants = ResizeButtonConstants()

        Image(constants.resize)
            .contentShape(Circle())
            .clipped()
            .contentShape(Circle())
            .frame(maxWidth: constants.defaultCircleRadius,
                   maxHeight: constants.defaultCircleRadius, alignment: .trailing)
    }
}
