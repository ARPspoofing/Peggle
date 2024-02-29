//
//  InfoDisplayBoxView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct InfoDisplayBoxView: View {
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let infoHeight: CGFloat = Constants.screenWidth / 3
    private let desertDarkBrown = Color(red: 195/255, green: 169/255, blue: 114/255)

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: infoWidth, height: infoHeight)
                .foregroundColor(desertDarkBrown)
                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
        }
    }
}
