//
//  NavButton.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/28/23.
//

import SpriteKit

class NavButton: SKSpriteNode {

    init(type: NavigationButtonType) {
        textures = [SKTexture]()
        self.type = type
        let count = type.skAtlas.textureNames.count
        if count > 0 {
            for i in 0...count - 1 {
                textures.append(type.skAtlas.textureNamed(type.skAtlas.textureNames[i]))
            }
            textures.sort(by: {
                $0.description < $1.description
            })
        }
    
        super.init(texture: textures.first, color: .magenta, size: Constants.ButtonFrameBaseSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum NavigationButtonType: String {
        typealias OverlayType = Overlay.OverlayType

        case Setting, Statistic, Upgrade
        
        var skAtlas: SKTextureAtlas {
            SKTextureAtlas(named: "\(self.name)NavigationButton")
        }
        
        var name: String {
            self.rawValue
        }
        
        var overlay: OverlayType {
            OverlayType(rawValue: self.name) ?? .Setting
        }
    }

    var currentFrame: Int = 1;
    var type: NavigationButtonType = .Setting
    var gameData: GameData = GameData.shared
    var textures: [SKTexture]
    
    var activeFrames: [SKTexture] {
        textures
    }
    
    var idleFrames: [SKTexture] {
        textures
    }

    func setup() {
        self.zPosition = Constants.zPositions.UIMenus3
        self.size = Constants.ButtonFrameBaseSize
        self.isUserInteractionEnabled = true
    }
    
    func update() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Debug: \(type.name) nav button touched")
        guard touches.first != nil else { return }
        if let activeOverlay = gameData.activeOverlay {
            if activeOverlay == type.name {
                return
                // OR
                // gameData.activeOverlay = nil
            }
        }
        gameData.activeOverlay = type.name
    }
}


