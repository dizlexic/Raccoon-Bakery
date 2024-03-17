//
//  Globals.swift
//  Raccoon Idle


import Foundation
import SpriteKit

extension Notification.Name {
    static var progressNotification = TextureManager.Notifications.ProgressNotification.name
    static var preloadNotification = TextureManager.Notifications.PreloadNotification.name
}

class TextureManager {
    typealias TextureLoader = ()->Void
    typealias LoadedTexture = (UUID, [SKTexture])

    var textureLoaders: [TextureLoader] {
        [
            mainMenuPreload,
            backgroundTilesPreload,
            mousePreload
        ]
    }
    var loadedTextures: [LoadedTexture] = []
    
    func createTexture(_ name:String) -> LoadedTexture {
        let textureAtlas = SKTextureAtlas(named: name)
        var frames = [SKTexture]()
        guard textureAtlas.textureNames.count > 0 else {
            print("Warning: createTexture for name: (\(name)) failed (textureNames.count <= 0)")
            return (UUID(), [])
        }
        for i in 0...textureAtlas.textureNames.count - 1 {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        return LoadedTexture(UUID(), frames)
    }
    
    enum Notifications:String, CaseIterable {
        case ProgressNotification
        case PreloadNotification
        
        var name: Notification.Name {
            Notification.Name(self.rawValue)
        }
    }
    
    deinit {
        print("Texture Manager is deinitiated")
    }
    
    static let shared = TextureManager()
    
    private var isLoaded: Bool = false
    private var filesToLoad: Int {
        textureLoaders.count
    }
    private var filesLoaded: Int = 0
    private var loadQueue: DispatchQueue

    init() {
        loadQueue = DispatchQueue(label: "TextureLoadQueue")
    }
    
    func load() {
        guard !isLoaded else {
            print("Warning: Already loaded")
            return
        }
        defer { isLoaded = true }
        for loader in textureLoaders {
            loadQueue.async {
                loader()
            }
        }
    }
    
    func mainMenuPreload() {
        loadedTextures.append(createTexture("Objects"))
        checkProgress()
    }
    
    func backgroundTilesPreload() {
        loadedTextures.append(createTexture("Bakery"))
        checkProgress()
    }
    
    func mousePreload() {
        loadedTextures.append(createTexture("mouse"))
        checkProgress()
    }
    
    private func checkProgress() {
        print("Checking progress")
        self.loadQueue.async {
            let nc = NotificationCenter.default
            self.filesLoaded += 1
            let filesLeft: Int = Int(CGFloat(self.filesLoaded) / CGFloat(self.filesToLoad)) * 100
            
            DispatchQueue.main.async {
                print("displatching progress")
                nc.post(name: .progressNotification, object: nil, userInfo: ["filesLeft": filesLeft])
            }
            
            if self.filesLoaded == self.filesToLoad {
                DispatchQueue.main.async {
                    print("dispatching complete")
                    nc.post(name: .progressNotification, object: nil, userInfo: ["complete": true])
                }
            }
        }
    }
}


