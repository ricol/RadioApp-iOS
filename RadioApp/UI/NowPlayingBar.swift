//
//  NowPlayingBar.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import SwiftUI

struct NowPlayingBar: View {
    let station: RadioStation
    let isPlaying: Bool
    let isLoading: Bool
    let error: String?
    let onPlayPause: () -> Void
    let onStop: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Now Playing")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
                Text(station.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                if let error, !error.isEmpty {
                    Text(error)
                        .font(.caption2)
                        .foregroundStyle(.red)
                        .lineLimit(1)
                }
            }

            Spacer()

            if isLoading {
                ProgressView()
                    .tint(.white)
            }

            Button(action: onPlayPause) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            .disabled(isLoading)

            Button(action: onStop) {
                Image(systemName: "stop.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
}
