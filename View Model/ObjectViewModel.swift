//
//  PaletteButtonViewModel.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import Foundation

class ObjectViewModel: ObservableObject {

    let pegModel: Peg
    let selectedAlpha: Double = Constants.selectedAlpha
    let unselectedAlpha: Double = Constants.unselectedAlpha

    @Published private(set) var isSelected: Bool

    init(name: String) {
        pegModel = Peg(name: name)
        self.isSelected = false
    }

    func getPegRadius() -> Double {
        pegModel.radius
    }

    func calculateWidth() -> Double {
        pegModel.radius + pegModel.radius
    }

    func calculateHeight() -> Double {
        pegModel.radius + pegModel.radius
    }
}
