//
//  EmptyStateView.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)
            Text("No stations found").font(.title3)
            Text("Try adjusting your search or filters")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}
