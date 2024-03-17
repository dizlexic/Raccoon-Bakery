//
//  SimpleAnimation.swift
//  Raccoon Bakery
//
//  Created by Celeste Whitlow on 10/8/23.
//

import SpriteKit



class Mixer: SKSpriteNode  {
    
    let atlas = SKTextureAtlas(named: "Mixer")
    var MixerArray = [SKTexture]()
    var mixer = SKSpriteNode()
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        MixerArray = atlas.textureNames.map {
            atlas.textureNamed($0)
        }
        
        let simpleAnimation = SKAction.animate(with: MixerArray, timePerFrame: 0.1)
        run(SKAction.repeatForever(simpleAnimation))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        MixerArray = atlas.textureNames.map {
            atlas.textureNamed($0)
        }
 
        
        let simpleAnimation = SKAction.animate(with: MixerArray, timePerFrame: 0.1)
        run(SKAction.repeatForever(simpleAnimation))
    }

}
