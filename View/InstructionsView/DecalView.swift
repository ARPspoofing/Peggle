//
//  DecalView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct DecalView: View {
    let anubis = "anubis"
    private let decalDim: CGFloat = 100.0

    var body: some View {
        Image(anubis)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: decalDim, height: decalDim)
    }
}
