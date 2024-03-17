//
//  AppType.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/29/23.
//

import SpriteKit

class AppType {
    
    enum Direction: Int16, CaseIterable, Codable {
        case up=1, down, left, right
        var cgVector: CGVector {
            switch self {
                case .up:
                    return CGVector(dx: 0, dy: 1)
                case .down:
                    return CGVector(dx: 0, dy: -1)
                case .left:
                    return CGVector(dx: -1, dy: 0)
                case .right:
                    return CGVector(dx: 1, dy: 0)
            }
        }
    }
    
    enum OperationType: Int16 {
        case Additive=1, Multiplicative, Frequency, CPCAdd, CPCMulti, ManagerDiscount
    }
}
