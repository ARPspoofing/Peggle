//
//  ObstacleDisplayView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 29/2/24.
//

import SwiftUI

struct ObstacleDisplayView: View {

    private let infoWidth: CGFloat = Constants.screenWidth / 3
    private let obstacle = "obstacleObject"

    var body: some View {
        Image(obstacle)
            .resizable()
            .frame(width: infoWidth / 4, height: infoWidth / 3)
    }
}

struct ObstacleDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ObstacleDisplayView()
    }
}
