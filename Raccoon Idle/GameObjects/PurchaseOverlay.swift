//
//  PurchaseOverlay.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/30/23.
//

import SpriteKit

class PurchaseOverlay: SKSpriteNode {
    
    var manager: Manager
    var fadeOut: SKAction = SKAction.fadeOut(withDuration: 0.3)

    init(for manager: Manager, size: CGSize) {
        self.manager = manager
        super.init(texture: nil, color: .magenta, size: size)
        let w = size.width / 2 - Constants.UIPadding
        let h = min(size.height / 2 - Constants.UIPadding, 50)
        let buttonSize = CGSize(width: w, height: h)
        let confirm = SKSpriteNode(texture: nil, color: .gray, size: buttonSize)
        let cancel = SKSpriteNode(texture: nil, color: .red, size: buttonSize)
        let label = SKLabelNode()
        label.preferredMaxLayoutWidth = w
        label.lineBreakMode = .byWordWrapping
        label.text = "Purchase \(manager.name) for \n \(manager.price.amount) \(manager.price.type.name)"
        addChild(label)
        label.position.y = label.frame.height
        confirm.name = "Confirm"
        cancel.name = "Cancel"
        isUserInteractionEnabled = true
        addChild(confirm)
        confirm.position.y = confirm.size.height * -1
        confirm.position.x = (confirm.size.width + Constants.UIPadding) / 2
        if GameData.shared.canPurchaseManager(manager: manager) {
            confirm.color = .green
        }
        addChild(cancel)
        cancel.position.y = cancel.size.height * -1
        cancel.position.x = (cancel.size.width + Constants.UIPadding) * -1 / 2
        
    }
    
    func fadeAndRemove() {
        run(fadeOut) {
            self.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let nodes = nodes(at: touch.location(in: self))
        if nodes.contains(where: { $0.name == "Confirm" }) {
            if GameData.shared.canPurchaseManager(manager: manager) {
                GameData.shared.purchaseManager(manager: manager)
                fadeAndRemove()
            }
        }
        
        if nodes.contains(where: { $0.name == "Cancel" }) {
            fadeAndRemove()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder don't work bro :(")
    }
    
    deinit {
        print("Purchase overlay has been deinitilized")
    }
}

