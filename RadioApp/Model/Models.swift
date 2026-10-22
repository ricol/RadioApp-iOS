//
//  Models.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import Foundation

struct RadioStation: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let streamUrl: String
    let genre: String
    let country: String
    let logoUrl: String?
    let description: String?
    var isFavorite: Bool = false

    var streamURL: URL? { URL(string: streamUrl) }
    var logoURL: URL? { logoUrl.flatMap(URL.init(string:)) }
}

struct RadioState {
    var currentStation: RadioStation? = nil
    var isPlaying: Bool = false
    var isLoading: Bool = false
    var error: String? = nil
    var stations: [RadioStation] = []
    var filteredStations: [RadioStation] = []
    var searchQuery: String = ""
    var selectedGenre: String? = nil
}
