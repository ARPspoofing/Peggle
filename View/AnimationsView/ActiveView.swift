//
//  ActiveView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/2/24.
//

import SwiftUI

struct ActiveView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content.blur(radius: 5)
        }
    }
}

extension View {
    func active() -> some View {
        modifier(ActiveView())
    }
}
