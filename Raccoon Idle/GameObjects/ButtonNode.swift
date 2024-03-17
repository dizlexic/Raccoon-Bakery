//
//  ButtonNode.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/25/23.
//

import SpriteKit

enum ButtonAction {
    case active, idle, pressed
}

class ButtonNode: Sprite {
    
    typealias Direction = AppType.Direction

    typealias ActionFrame = (CharacterAction, [(Direction, [SKTexture])])
    
    var actionFrames: [ActionFrame?] = []

    let gameData = GameData.shared

    func setup() {
        isUserInteractionEnabled = true
    }
    
    func touched() {
        
    }
    
    func touchEnded() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchEnded()
    }
}
