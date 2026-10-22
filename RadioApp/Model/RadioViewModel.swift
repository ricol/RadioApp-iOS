//
//  RadioViewModel.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import Foundation
import Combine

final class RadioViewModel: ObservableObject {

    @Published private(set) var state = RadioState()

    let player: RadioPlayer

    private var allStations: [RadioStation]
    private let genres: [String]

    init(player: RadioPlayer) {
        self.player = player

        let stations = RadioDataSource.getStations()
            .sorted { lhs, rhs in
                // Chinese stations first
                if lhs.country == "中国" && rhs.country != "中国" { return true }
                if rhs.country == "中国" && lhs.country != "中国" { return false }
                return lhs.name < rhs.name
            }
        self.allStations = stations
        self.genres = RadioDataSource.getGenres(from: stations)

        state.stations = stations
        state.filteredStations = stations

        // Bind player state into view model state
        observePlayer()
    }

    private var cancellables = Set<AnyCancellable>()

    private func observePlayer() {
        player.$currentStation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] station in self?.state.currentStation = station }
            .store(in: &cancellables)

        player.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] playing in self?.state.isPlaying = playing }
            .store(in: &cancellables)

        player.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in self?.state.isLoading = loading }
            .store(in: &cancellables)

        player.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] err in self?.state.error = err }
            .store(in: &cancellables)
    }

    // MARK: - Intents

    func searchStations(_ query: String) {
        state.searchQuery = query
        filter()
    }

    func filterByGenre(_ genre: String?) {
        state.selectedGenre = genre
        filter()
    }

    func playStation(_ station: RadioStation) {
        player.play(station: station)
    }

    func togglePlayPause() {
        player.togglePlayPause()
    }

    func stop() {
        player.stop()
    }

    func toggleFavorite(_ station: RadioStation) {
        guard let idx = allStations.firstIndex(where: { $0.id == station.id }) else { return }
        allStations[idx].isFavorite.toggle()
        let updated = allStations[idx]

        if let fIdx = state.filteredStations.firstIndex(where: { $0.id == updated.id }) {
            state.filteredStations[fIdx] = updated
        }
        state.stations = allStations
        player.updateCurrentStation(updated)
    }

    func getGenres() -> [String] { genres }

    // MARK: - Filtering

    private func filter() {
        let q = state.searchQuery.lowercased()
        let genre = state.selectedGenre

        state.filteredStations = allStations.filter { station in
            let matchesSearch = q.isEmpty
                || station.name.lowercased().contains(q)
                || (station.description?.lowercased().contains(q) ?? false)
                || station.country.lowercased().contains(q)
            let matchesGenre = genre == nil || station.genre == genre
            return matchesSearch && matchesGenre
        }
    }
}
