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
                    ),
                    isFocused: $searchFocused
                )

                GenreFilter(
                    genres: viewModel.getGenres(),
                    selected: viewModel.state.selectedGenre
                ) { genre in
                    releaseFocus()
                    viewModel.filterByGenre(genre)
                }

                if viewModel.state.filteredStations.isEmpty {
                    EmptyStateView()
                } else {
                    StationList(
                        stations: viewModel.state.filteredStations,
                        selectedStation: viewModel.state.currentStation,
                        isPlaying: { viewModel.state.currentStation?.id == $0.id && viewModel.state.isPlaying },
                        onTap: { station in
                            releaseFocus()
                            viewModel.playStation(station)
                        },
                        onPlayPause: { station in
                            releaseFocus()
                            if viewModel.state.currentStation?.id == station.id {
                                viewModel.togglePlayPause()
                            } else {
                                viewModel.playStation(station)
                            }
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            // Tap anywhere on the background releases focus. Using
            // simultaneousGesture so taps on buttons / rows still fire.
            .simultaneousGesture(
                TapGesture().onEnded { releaseFocus() }
            )
            .navigationTitle("📻 Radio Station")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        releaseFocus()
                        if let current = viewModel.state.currentStation {
                            viewModel.toggleFavorite(current)
                        }
                    } label: {
                        Image(systemName: (viewModel.state.currentStation?.isFavorite ?? false) ? "heart.fill" : "heart")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        releaseFocus()
                        /* settings */
                    } label: {
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
                        onPlayPause: {
                            releaseFocus()
                            viewModel.togglePlayPause()
                        },
                        onStop: {
                            releaseFocus()
                            viewModel.stop()
                        }
                    )
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            // Also clear focus when the user starts scrolling.
            .scrollDismissesKeyboard(.immediately)
        }
    }

    private func releaseFocus() {
        searchFocused = false
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
