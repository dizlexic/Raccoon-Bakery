//
//  Sprite.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

typealias LoadedTexture = TextureManager.LoadedTexture

extension SKNode {
    func addChild(node: SKNode, position: CGPoint) {
        node.position = position
        addChild(node)
    }
}

class Sprite: SKSpriteNode {

    var isAnimating: Bool = false

    enum SetupError: Error {
        case Unknown
    }

    var loadedTextures: [SKTexture]?
    var frames: [SKTexture] {
        loadedTextures?.sorted(by: {
            return $0.description < $1.description
        }) ?? []
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        texture?.filteringMode = .nearest
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        texture?.filteringMode = .nearest
    }

}

