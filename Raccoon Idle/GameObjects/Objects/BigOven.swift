//
//  BigOven.swift
//  Raccoon Bakery
//
//  Created by Celeste Whitlow on 10/10/23.
//

import SpriteKit

class BigOven: SKSpriteNode  {
    
    let atlas = SKTextureAtlas(named: "BigOven")
    var conveyorArray = [SKTexture]()
    var conveyor = SKSpriteNode()
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        conveyorArray = atlas.textureNames.map {
            atlas.textureNamed($0)
        }.sorted(by: {
            $0.description < $1.description
        })
        
        let simpleAnimation = SKAction.animate(with: conveyorArray, timePerFrame: 0.2)
        run(SKAction.repeatForever(simpleAnimation))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        conveyorArray = atlas.textureNames.map {
            atlas.textureNamed($0)
        }.sorted(by: {
            $0.description < $1.description
        })
 
        
        let simpleAnimation = SKAction.animate(with: conveyorArray, timePerFrame: 0.2)
        run(SKAction.repeatForever(simpleAnimation))
    }

}
