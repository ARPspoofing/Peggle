//
//  SharpDisplayView.swift
//  Peggle
//
//  Created by Muhammad  Reyaaz on 29/2/24.
//

import SwiftUI

struct SharpDisplayView: View {

    private let sharp = "pyramidBlock"
    private let infoWidth: CGFloat = Constants.screenWidth / 3

    var body: some View {
        Image(sharp)
            .resizable()
            .frame(width: infoWidth / 3, height: infoWidth / 3)
    }
}
