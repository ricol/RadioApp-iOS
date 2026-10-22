//
//  StateList.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import SwiftUI

struct StationList: View {
    let stations: [RadioStation]
    let selectedStation: RadioStation?
    let isPlaying: (RadioStation) -> Bool
    let onTap: (RadioStation) -> Void
    let onPlayPause: (RadioStation) -> Void

    var body: some View {
        List {
            ForEach(stations) { station in
                StationRow(
                    station: station,
                    isPlaying: isPlaying(station),
                    isSelected: station.id == selectedStation?.id,
                    onTap: { onTap(station) },
                    onPlayPause: { onPlayPause(station) }
                )
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        // Hook this up to a delete action if you add it.
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

struct StationRow: View {
    let station: RadioStation
    let isPlaying: Bool
    let isSelected: Bool
    let onTap: () -> Void
    let onPlayPause: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            logo

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(station.name)
                        .font(.headline)
                        .lineLimit(2)
                    if station.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                Text("\(station.genre) • \(station.country)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                if let d = station.description {
                    Text(d)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: onPlayPause) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.accentColor)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(
            isSelected ? Color.accentColor.opacity(0.15) : Color(.secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: 12)
        )
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture(perform: onTap)
    }

    @ViewBuilder
    private var logo: some View {
        if let url = station.logoURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    placeholder
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
        } else {
            placeholder
                .frame(width: 60, height: 60)
        }
    }

    private var placeholder: some View {
        ZStack {
            Circle().fill(Color.accentColor.opacity(0.2))
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.title3)
                .foregroundStyle(Color.accentColor)
        }
    }
}
