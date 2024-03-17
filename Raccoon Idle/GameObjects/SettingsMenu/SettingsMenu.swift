//
//  SettingsMenu.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/28/23.
//

import SpriteKit

class SettingsMenu: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: nil, color: .magenta, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
