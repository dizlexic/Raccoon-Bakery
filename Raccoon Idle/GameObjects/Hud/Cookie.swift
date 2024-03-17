//
//  Cookie.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

class Cookie: ButtonNode {
    var runningSpin: Bool = false
    let baseSpin: Double = 2.5

    lazy var spinAction: SKAction = SKAction.rotate(
        byAngle: CGFloat(Double.pi) * -1,
        duration: baseSpin)
    lazy var infiniteSpin: SKAction = SKAction.repeatForever(spinAction)
    
    init(size: CGSize) {
        let cookie = SKTexture(imageNamed: "Cookie")
        super.init(texture: cookie, color: .blue, size: size)
    }
    
    init(size: CGSize, at position: CGPoint?) {
        let cookie = SKTexture(imageNamed: "Cookie")
        super.init(texture: cookie, color: .blue, size: size)
        guard let pos = position else { return }
        self.position = pos
    }

    func spin() {
        run(infiniteSpin)
        self.runningSpin = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
        guard let touch = touches.first else { return }
        guard let parent = self.parent else { return }
        let location = touch.location(in: parent)
        
        let cEmitter = CookieEmitter()
        cEmitter.position = location
        parent.addChild(cEmitter)
        cEmitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))

        GameData.shared.touchCookie()
    }

    
}



class CookieEmitter: SKEmitterNode {
    override init() {
        super.init()
        particleTexture = SKTexture(imageNamed: "Cookie")
        particleSize = CGSize(width: 50, height: 50)
        particleLifetime = 1.5
        particleAlphaSpeed = -0.75
        particleBirthRate = 50
        particleSpeed = 500
        emissionAngleRange = 1.4
        yAcceleration = -500
        numParticlesToEmit = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
