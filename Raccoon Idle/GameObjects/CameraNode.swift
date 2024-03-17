//
//  CameraNode.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

class CameraNode: SKNode {
    func center() {
        let cameraPositionInScene: CGPoint = scene!.convert(position, from: parent!)
        
        let xPos = parent!.position.x - cameraPositionInScene.x
        let yPos = parent!.position.y - cameraPositionInScene.y
        
        parent?.position = CGPoint(x: xPos, y: yPos);
    }
}
