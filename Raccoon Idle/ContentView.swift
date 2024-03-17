//
//  ContentView.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/21/23.
//

import UIKit
import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                GameView(size: geo.size)
            }
        }
        .ignoresSafeArea()
    }
}

struct GameView: UIViewRepresentable {
    typealias UIViewType = SKView
    var size: CGSize
    var gameConfig: GameConfiguration = GameConfiguration.shared
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = SKScene(fileNamed: "OrganizedScene")!
        scene.size = size
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.showsFPS = true
        uiView.showsNodeCount = true
    }
    
    init(size: CGSize) {
        self.size = size
        gameConfig.size = size
    }
}

#Preview {
    ContentView()
}
