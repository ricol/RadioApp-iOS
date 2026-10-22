//
//  RadioAppApp.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import SwiftUI

@main
struct RadioApp: App {
    @StateObject private var viewModel = RadioViewModel(player: RadioPlayer())

    var body: some Scene {
        WindowGroup {
            RadioScreen()
                .environmentObject(viewModel)
        }
    }
}
