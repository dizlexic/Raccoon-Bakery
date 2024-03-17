//
//  SharpTexture.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/9/23.
//

import SpriteKit

class SharpTexture: SKTexture {
    override init() {
        super.init()
        filteringMode = .nearest
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        filteringMode = .nearest
    }
}
