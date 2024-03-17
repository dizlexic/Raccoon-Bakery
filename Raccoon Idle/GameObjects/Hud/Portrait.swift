//
//  Portrait.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/26/23.
//

import SpriteKit

class Portrait: Sprite {
    var character: CharacterNode?
    
    init(size: CGSize) {
        let textures = Util.loadTexturesFromAtlas(named: "Frames")
        super.init(texture: textures?.randomElement(), color: .clear, size: size)
        isUserInteractionEnabled = true
        self.loadedTextures = textures
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene as? DemoScene else { return }
        scene.cameraFocus = character
        GameData.shared.updateSelectedManagerByCharacter(character: character)
    }
    
    func setup() {
        guard let character = character else { return }
        let rect = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: size.height))
        let cropNode = SKCropNode()
        let image = SKSpriteNode(imageNamed: character.portrait)
        image.size = size
        cropNode.addChild(image)
        cropNode.maskNode = rect
        addChild(cropNode)
    }
}
