//
//  RadioPlayer.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import AVFoundation
import MediaPlayer
import Combine

@MainActor
final class RadioPlayer: ObservableObject {

    @Published private(set) var currentStation: RadioStation?
    @Published private(set) var isPlaying = false
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?

    private let player = AVPlayer()
    private var timeObserver: Any?
    private var statusCancellable: AnyCancellable?
    private var itemStatusCancellable: AnyCancellable?
    private var timeControlCancellable: AnyCancellable?
    private var hasConfiguredSession = false

    init() {
        observePlayer()
        configureRemoteCommands()
    }

    // MARK: - Public API

    func play(station: RadioStation) {
        guard let url = station.streamURL else {
            error = "Invalid stream URL"
            return
        }
        if currentStation == station && isPlaying { return }

        error = nil
        isLoading = true
        currentStation = station
        configureAudioSessionIfNeeded()

        let item = AVPlayerItem(url: url)
        observeItem(item)
        player.replaceCurrentItem(with: item)
        player.play()
        updateNowPlayingInfo()
    }

    func togglePlayPause() {
        guard player.currentItem != nil else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
        currentStation = nil
        isPlaying = false
        isLoading = false
        error = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    func updateCurrentStation(_ station: RadioStation) {
        // Called when favourite flag flips
        if currentStation?.id == station.id {
            currentStation = station
            updateNowPlayingInfo()
        }
    }

    // MARK: - Audio Session

    private func configureAudioSessionIfNeeded() {
        guard !hasConfiguredSession else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
            hasConfiguredSession = true
        } catch {
            self.error = "Audio session error: \(error.localizedDescription)"
        }
    }

    // MARK: - Player observation

    private func observePlayer() {
        statusCancellable = player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .playing:
                    self.isPlaying = true
                    self.isLoading = false
                case .waitingToPlayAtSpecifiedRate:
                    self.isLoading = true
                case .paused:
                    self.isPlaying = false
                @unknown default:
                    break
                }
            }
    }

    private func observeItem(_ item: AVPlayerItem) {
        itemStatusCancellable = item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .failed:
                    self.error = item.error?.localizedDescription ?? "Playback failed"
                    self.isPlaying = false
                    self.isLoading = false
                case .readyToPlay:
                    self.updateNowPlayingInfo()
                default:
                    break
                }
            }

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            // Live streams shouldn't end, but if it does, retry.
            self?.player.seek(to: .zero)
            self?.player.play()
        }
    }

    // MARK: - Now Playing / Remote Commands

    private func updateNowPlayingInfo() {
        guard let station = currentStation else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: station.name,
            MPMediaItemPropertyArtist: station.description ?? station.genre,
            MPMediaItemPropertyAlbumTitle: station.country,
            MPNowPlayingInfoPropertyIsLiveStream: true
        ]

        if let url = station.logoURL {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data, let image = UIImage(data: data) else { return }
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                DispatchQueue.main.async {
                    var current = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
                    current[MPMediaItemPropertyArtwork] = artwork
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = current
                }
            }.resume()
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func configureRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.isEnabled = true
        center.playCommand.addTarget { [weak self] _ in
            self?.player.play()
            return .success
        }

        center.pauseCommand.isEnabled = true
        center.pauseCommand.addTarget { [weak self] _ in
            self?.player.pause()
            return .success
        }

        center.togglePlayPauseCommand.isEnabled = true
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        center.stopCommand.isEnabled = true
        center.stopCommand.addTarget { [weak self] _ in
            self?.stop()
            return .success
        }
    }
}
