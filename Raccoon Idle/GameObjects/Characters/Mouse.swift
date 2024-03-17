//
//  Mouse.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

class Mouse: CharacterNode {
    override func setup() {
        loadedTextures = Util.loadTexturesFromAtlas(named: "Mouse")
        portrait = "mous_00"
        actionFrames = [
            (.idle, [
                (.up, frameChunks.count > 2 ? frameChunks[2] : []),
                (.down, frameChunks.count > 0 ? frameChunks[0] : []),
                (.left, frameChunks.count > 4 ? frameChunks[4] : []),
                (.right, frameChunks.count > 6 ? frameChunks[6] : []),
            ]),
            (.walk, [
                (.up, frameChunks.count > 3 ? frameChunks[3] : []),
                (.down, frameChunks.count > 1 ? frameChunks[1] : []),
                (.left, frameChunks.count > 5 ? frameChunks[5] : []),
                (.right, frameChunks.count > 7 ? frameChunks[7] : []),
            ])
        ]
    }
}
