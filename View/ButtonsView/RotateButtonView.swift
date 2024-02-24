//
//  RotateButtonView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/2/24.
//

import SwiftUI

struct RotateButtonView: View {
    var body: some View {
        let constants = RotateButtonConstants()

        Image(constants.rotate)
            .contentShape(Circle())
            .clipped()
            .contentShape(Circle())
            .frame(maxWidth: constants.defaultCircleRadius,
                   maxHeight: constants.defaultCircleRadius, alignment: .trailing)
    }
}
