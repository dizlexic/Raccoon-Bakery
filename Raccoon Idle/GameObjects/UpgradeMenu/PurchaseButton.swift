//
//  PurchaseButton.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/10/23.
//

import SpriteKit

class PurchaseButton: SKSpriteNode {
    let manager: Manager?

    init(for manager: Manager?, of size: CGSize) {
        self.manager = manager
        super.init(texture: nil, color: .magenta, size: size)
        self.name = "PurchaseButton"
        self.zPosition = Constants.zPositions.UIObjects1
        self.update()
        self.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        guard let manager = self.manager else { return }
        if ( GameData.shared.canPurchaseManager(manager: manager) ) {
            GameData.shared.purchaseManager(manager: manager)
            update()
        }
    }
    
    func update() {
        guard let manager = self.manager else { return }
        
        let owned = manager.owned
        let price = manager.adjustedPrice
        let priceText = price.displayValue
        let currencyName = price.type.name
        removeAllChildren()
        let circle = SKShapeNode(circleOfRadius: size.height / 2)
        circle.position = .zero
        circle.position.x -= (size.width - circle.frame.width) / 2
        circle.fillColor = .black
        circle.strokeColor = .yellow
        circle.lineWidth = 10
        addChild(circle)
        let ownedLabel = SKLabelNode(text: owned.formatted(.number.precision(.fractionLength(0))))
        ownedLabel.position = .zero
        ownedLabel.verticalAlignmentMode = .center
        ownedLabel.preferredMaxLayoutWidth = circle.frame.width
        ownedLabel.fontSize = 28
        ownedLabel.numberOfLines = 0
        ownedLabel.lineBreakMode = .byTruncatingHead
        circle.addChild(ownedLabel)
        let text = owned > 0 ? "an additional" : "a"
        let purchaseLabel = SKLabelNode(text: "Purchase \(text) \(manager.name) for \(priceText) \(currencyName)")
        purchaseLabel.position = .zero
        purchaseLabel.position.x += circle.frame.width / 2 // maybe
        purchaseLabel.verticalAlignmentMode = .center
        purchaseLabel.preferredMaxLayoutWidth = size.width - circle.frame.width - Constants.UIPadding
        purchaseLabel.fontName = "SanFranciscoRounded-Medium"
        purchaseLabel.fontSize = 18
        purchaseLabel.lineBreakMode = .byWordWrapping
        purchaseLabel.numberOfLines = 0
        addChild(purchaseLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
