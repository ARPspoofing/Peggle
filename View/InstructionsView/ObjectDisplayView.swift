//
//  ObjectDisplayView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct ObjectDisplayView: View {
    private let reappearImages: [String] = ["reappearObject", "reappearObjectActive"]
    private let actionImages: [String] = ["actionObject", "actionObjectActive"]
    private let oscillateImages: [String] = ["oscillateObject", "oscillateObjectActive"]
    let powerText = "Special objects are spook, kaboom and oscillate."
    private let infoWidth: CGFloat = Constants.screenWidth / 3
    @State private var currentImageIndex = 0

    var body: some View {
        VStack {
            HStack {
                objectDisplay(with: reappearImages)
                objectDisplay(with: actionImages)
                objectDisplay(with: oscillateImages)
            }
            Text(powerText)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(nil)
                .frame(width: infoWidth)
        }
    }
}

extension ObjectDisplayView {
    private func objectDisplay(with images: [String]) -> some View {
        Image(images[currentImageIndex])
            .resizable()
            .frame(width: infoWidth / 4, height: infoWidth / 4)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    currentImageIndex = (currentImageIndex + 1) % 2
                }
            }
    }
}
