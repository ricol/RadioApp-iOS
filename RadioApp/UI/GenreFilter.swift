//
//  GenreFilter.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import SwiftUI

struct GenreFilter: View {
    let genres: [String]
    let selected: String?
    let onSelect: (String?) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(label: "All", isSelected: selected == nil) {
                    onSelect(nil)
                }
                ForEach(genres, id: \.self) { genre in
                    chip(label: genre, isSelected: selected == genre) {
                        onSelect(genre)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private func chip(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    isSelected ? Color.accentColor : Color(.secondarySystemBackground),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}
