//
//  Raccoon.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

class Raccoon: CharacterNode {
    override func setup() {
        self.loadedTextures = Util.loadTexturesFromAtlas(named: "Raccoon")
        self.zPosition = Constants.zPositions.characters
        actionFrames = [
            (.idle, [
                (.up, frameChunks.count > 2 ? frameChunks[2] : []),
                (.down, frameChunks.count > 0 ? frameChunks[0] : []),
                (.left, frameChunks.count > 4 ? frameChunks[4] : []),
                (.right, frameChunks.count > 6 ? frameChunks[6] : []),
            ]),
            (.walk, [
                (.up, frameChunks.count > 3 ? frameChunks[2] + frameChunks[3] : []),
                (.down, frameChunks.count > 1 ? frameChunks[0] + frameChunks[1] : []),
                (.left, frameChunks.count > 5 ? frameChunks[4] + frameChunks[5] : []),
                (.right, frameChunks.count > 7 ? frameChunks[6] + frameChunks[7] : []),
            ]),
             (.flair, [
                (.up, frameChunks.count > 3 ? frameChunks[0] + frameChunks[2] + frameChunks[0] + frameChunks[2]: []),
                (.down, frameChunks.count > 3 ? frameChunks[2] + frameChunks[0] + frameChunks[2] + frameChunks[0] : []),
                (.left, frameChunks.count > 5 ? frameChunks[4] + frameChunks[7] + frameChunks[4] + frameChunks[7] : []),
                (.right, frameChunks.count > 7 ? frameChunks[6] + frameChunks[4] + frameChunks[6] + frameChunks[4] : []),
             ])
        ]

        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(flairInterval))) { [weak self] in
            self?.runFlair()
        }
    }
    
    func buildMoveAction() {
        
    }
    
    override func buildActionAnimation(for action: CharacterAction,in direction: Direction, repeat forever: Bool = false) -> SKAction {
        guard let actionSet = actionFrames.compactMap( { $0 } ).first(where: { $0.0 == action }) else { return SKAction() }
        guard let textures = actionSet.1.first(where: {$0.0 == direction })?.1 else { return SKAction() }
        return buildAnimation(frames: textures, repeatForever: forever, tpf: actionSet.0 == .idle || actionSet.0 == .flair ? Constants.CharacterMoveDuration * 3: Constants.CharacterMoveDuration)
    }
}

