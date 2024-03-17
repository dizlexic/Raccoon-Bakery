//
//  Raccoon_IdleApp.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/21/23.
//

import SwiftUI

@main
struct Raccom_IdleApp: App {
    @Environment(\.scenePhase) var phase
    let game = GameController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    TextureManager.shared.load()
                }
        }
        .onChange(of: phase) { previousValue, newValue in
            print("Scene phase transitioning from \(previousValue) to \(newValue)")
            switch newValue {
                case .active: game.load()
                case .inactive, .background: game.unload()
                default: game.unload()
            }
        }
    }
}
