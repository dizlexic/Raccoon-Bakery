//
//  Constants.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

class Util {

    static func getRadiansBetweenTwoPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> Double {
        return Double(atan2(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x)) + .pi/2
    }
    
    static func getRandomNumber(upperLimit: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(upperLimit + 1)))
    }
    
    static func getDistance(point1: CGPoint, point2: CGPoint) -> Double {
        return Double(sqrt(pow((point1.x - point2.x), 2) + pow((point1.y - point2.y), 2)))
    }
    
    static func getAngle(opposite: CGFloat, adjacent: CGFloat) -> CGFloat {
        return atan(opposite / adjacent)
    }
    
    static func getTriangleLegs(hypotenuse: CGFloat, angle: CGFloat, sign: CGFloat) -> (CGFloat, CGFloat) {
        let dy = sin(angle) * 1000 * sign
        let dx = cos(angle) * 1000 * sign
        return (dx, dy)
    }

    static func loadTexturesFromAtlas(named name: String) -> [SKTexture]? {
        let textureAtlas = SKTextureAtlas(named: name)
        guard textureAtlas.textureNames.count > 0 else {
            print("Warning: createTexture for name: (\(name)) failed (textureNames.count <= 0)")
            return nil
        }

        /// returns [SKTexture] by grabbing each from the atlas by it's name
        return textureAtlas.textureNames.map {
            let texture = textureAtlas.textureNamed($0)
            texture.filteringMode = .nearest
            return texture
        }
    }
}
