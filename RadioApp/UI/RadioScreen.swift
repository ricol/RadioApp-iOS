//
//  RadioScreen.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import SwiftUI

struct RadioScreen: View {
    @EnvironmentObject var viewModel: RadioViewModel
    @FocusState private var searchFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    text: Binding(
                        get: { viewModel.state.searchQuery },
                        set: { viewModel.searchStations($0) }
                    )
                )

                GenreFilter(
                    genres: viewModel.getGenres(),
                    selected: viewModel.state.selectedGenre
                ) { genre in
                    searchFocused = false
                    viewModel.filterByGenre(genre)
                }

                if viewModel.state.filteredStations.isEmpty {
                    EmptyStateView()
                } else {
                    StationList(
                        stations: viewModel.state.filteredStations,
                        selectedStation: viewModel.state.currentStation,
                        isPlaying: { viewModel.state.currentStation?.id == $0.id && viewModel.state.isPlaying },
                        onTap: { viewModel.playStation($0) },
                        onPlayPause: { station in
                            if viewModel.state.currentStation?.id == station.id {
                                viewModel.togglePlayPause()
                            } else {
                                viewModel.playStation(station)
                            }
                        }
                    )
                }
            }
            .navigationTitle("📻 Radio Station")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let current = viewModel.state.currentStation {
                            viewModel.toggleFavorite(current)
                        }
                    } label: {
                        Image(systemName: (viewModel.state.currentStation?.isFavorite ?? false) ? "heart.fill" : "heart")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { /* settings */ } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if let station = viewModel.state.currentStation {
                    NowPlayingBar(
                        station: station,
                        isPlaying: viewModel.state.isPlaying,
                        isLoading: viewModel.state.isLoading,
                        error: viewModel.state.error,
                        onPlayPause: { viewModel.togglePlayPause() },
                        onStop: { viewModel.stop() }
                    )
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
