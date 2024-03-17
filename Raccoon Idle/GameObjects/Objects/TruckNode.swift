//
//  TruckNode.swift
//  Raccoon Bakery
//
//  Created by Celeste Whitlow on 10/8/23.
//

import SpriteKit

class Truck: SKSpriteNode  {
    
    let atlas = SKTextureAtlas(named: "Truck")
    var conveyorArray = [SKTexture]()
    var reverseArray = [SKTexture]()
    var totalArray = [SKTexture]()
    var conveyor = SKSpriteNode()
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
//        
//        conveyorArray = atlas.textureNames.map {
//            atlas.textureNamed($0)
//        }.sorted(by: {
//            $0.description < $1.description
//        })
//        
//        let simpleAnimation = SKAction.animate(with: conveyorArray, timePerFrame: 0.2)
//        run(SKAction.repeatForever(simpleAnimation))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        conveyorArray = atlas.textureNames.map {
            atlas.textureNamed($0)
        }.sorted(by: {
            $0.description < $1.description
        })
        
        reverseArray = atlas.textureNames.map {
            atlas.textureNamed($0)
        }.sorted(by: {
            $0.description > $1.description
        })
        
        totalArray = conveyorArray + reverseArray
 
        
        let simpleAnimation = SKAction.animate(with: totalArray, timePerFrame: 0.1)
        run(SKAction.repeatForever(simpleAnimation))
    }

}



