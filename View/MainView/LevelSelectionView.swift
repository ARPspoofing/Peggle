//
//  LevelSelectionView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/1/24.
//

import SwiftUI

struct LevelSelectionView: View {
    var levels: [String]
    var onSelect: (String) -> Void
    var onCancel: () -> Void
    var cancel = "Cancel"
    var selectText = "Select Level:"

    var body: some View {
        GeometryReader { geometry in
            VStack {
                levelListDisplay(geometry: geometry)
                cancelButton(geometry: geometry)
            }
        }
    }
}

extension LevelSelectionView {
    private func levelListDisplay(geometry: GeometryProxy) -> some View {
        List {
            Section(header: Text(selectText).font(.headline)) {
                ForEach(levels, id: \.self) { level in
                    Button(action: {
                        onSelect(level)
                    }) {
                        Text(level).foregroundColor(Constants.blue)
                    }
                }
            }
        }
        .background(Constants.customGrey)
        .cornerRadius(Constants.radius)
        .listStyle(PlainListStyle())
        .frame(minWidth: geometry.size.width)
    }
}

extension LevelSelectionView {
    private func cancelButton(geometry: GeometryProxy) -> some View {
        Button(action: { onCancel() }) {
            Text(cancel)
                .foregroundColor(Constants.red)
                .padding()
                .frame(minWidth: geometry.size.width)
        }
        .background(Color.white)
        .cornerRadius(Constants.radius)
    }
}
