//
//  DeleteView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/1/24.
//

import SwiftUI

struct DeleteButtonView: View {
    var body: some View {
        let constants = DeleteButtonConstants()

        Image(constants.delete)
            .contentShape(Circle())
            .clipped()
            .contentShape(Circle())
            .frame(maxWidth: constants.defaultCircleRadius,
                   maxHeight: constants.defaultCircleRadius, alignment: .trailing)
    }
}
