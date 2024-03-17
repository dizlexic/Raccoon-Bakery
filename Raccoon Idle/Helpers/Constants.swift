//
//  Constants.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/29/23.
//

import SpriteKit

extension UInt32 {
    static let CharacterBitMask: UInt32 = 0b1
    static let EnemyBitMask: UInt32 = 0b01
    static let WallBitMask: UInt32 = 0b001
    static let FloorBitMask: UInt32 = 0b0001
    static let CoinBitMask: UInt32 = 0b00001
}

class Constants {
    static let CharacterMoveDuration: Double = 0.1
    static let GameCellUnit: CGFloat = 12
    static let CameraStartingPosition = CGPoint(x: 300, y: 160)
    static let UIPadding: CGFloat = 10
    static let ButtonFrameBaseSize: CGSize = CGSize(width: 50, height: 50)
    
    enum SoundFile {
        static let music = "music.mp3"
    }
    
    enum CategoryBitMasks {
        static let hero: UInt32 = 1
        static let enemy: UInt32 = 2
        static let map: UInt32 = 4
        static let spell: UInt32 = 8
        static let penetratingSpell: UInt32 = 16
    }
    
    enum zPositions {
        static let map: CGFloat = 0
        static let mapObjects: CGFloat = 1
        static let characters: CGFloat = 2
        static let objectLayer1: CGFloat = 3
        static let objectLayer2: CGFloat = 4
        static let objectLayer3: CGFloat = 5
        static let UIObjects1: CGFloat = 6
        static let UIObjects2: CGFloat = 7
        static let UIMenus3: CGFloat = 8
        static let Announce: CGFloat = 9
    }
    
    enum Color {
        static let hpBar = UIColor(red: 0.164, green: 0.592, blue: 0.286, alpha: 1)
        static let energyBar = UIColor(red: 0.353, green: 0.659, blue: 0.812, alpha: 1)
        static let resourceFrame = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    }
}
