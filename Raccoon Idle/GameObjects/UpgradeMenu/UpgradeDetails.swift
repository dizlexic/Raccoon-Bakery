//
//  UpgradeDetails.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/9/23.
//

import SpriteKit

// Here is some perfect CTRL+C CTRL+V programic Sprite view init and forget it
class UpgradeDetails: SKSpriteNode {
    
    init(for upgrade: Upgrade, at point: CGPoint, of size: CGSize) {
        // can purchase flag
        let canPurchase = GameData.shared.canPurchaseUpgrade(upgrade: upgrade)

        super.init(texture: nil,
                   color: canPurchase ? .magenta : .gray,
                   size: size)
        name = "UpgradeDetails"
        zPosition = Constants.zPositions.UIMenus3
        position = point

        // Ico
        let icon = SKSpriteNode(texture: upgrade.texture,
                                color: .black,
                                size: Constants.ButtonFrameBaseSize)
        icon.position = .zero
        icon.position.y += (size.height - icon.size.height) / 2 - Constants.UIPadding
        icon.position.x -= (size.width - icon.size.width) / 2 - Constants.UIPadding
        addChild(icon)
        
        // Name
        let label = SKLabelNode(text: "")
        label.fontName = "SanFranciscoRounded-Medium"
        label.fontSize = 24
        label.position = .zero // Zero is default I just do this for consistency (it's habit)
        label.position.y += (size.width - label.frame.height) / 2 - label.fontSize - Constants.UIPadding
        label.verticalAlignmentMode = .center
        addChild(label)

        // price
        let price = SKLabelNode(text: upgrade.adjustedPrice.displayValue)
        price.fontName = "SanFranciscoRounded-Medium"
        price.fontSize = 18
        price.position = .zero // Zero is default I just do this for consistency (it's habit)
        price.position.y += icon.position.y
        price.position.x += (size.width - price.frame.width) / 2 - price.fontSize - Constants.UIPadding
        price.verticalAlignmentMode = .center
        price.horizontalAlignmentMode = .center
        addChild(price)
        
        // about
        let about = SKLabelNode(text: upgrade.about)
        about.fontName = "SanFranciscoRounded-Medium"
        about.fontSize = 18
        about.lineBreakMode = .byWordWrapping
        about.preferredMaxLayoutWidth = 300
        about.numberOfLines = 0
        about.position = .zero
        about.verticalAlignmentMode = .center
        addChild(about)
        
        // PurchaseUpgradeButton
        let purchaseSize = CGSize(width: size.width, height: Constants.ButtonFrameBaseSize.height)
        let purchase = SKSpriteNode(texture: nil,
                                    color: canPurchase ? .green : .gray,
                                    size: purchaseSize)
        purchase.position = .zero
        purchase.name = "PurchaseUpgrade"
        purchase.position.y -= (size.height - purchase.size.height) / 2
        isUserInteractionEnabled = true
        // PurchaseText
        let purchaseText = SKLabelNode(text: canPurchase ? "Purchase" : "Not enough cookies")
        purchaseText.fontName = "SanFranciscoRounded-Medium"
        purchaseText.fontSize = 18
        purchaseText.numberOfLines = 1
        purchaseText.position = .zero
        purchaseText.verticalAlignmentMode = .center
        purchase.addChild(purchaseText)
        addChild(purchase)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let parent = parent as? UpgradeMenu else { return }
        guard let upgrade = parent.selected else { return }
        guard let _ = nodes(at: touch.location(in: self)).first(where: {
            $0.name == "PurchaseUpgrade"
        }) else { return }
        print("Attempting to purchase \(upgrade.name) for \(upgrade.price.displayValue)")
        GameData.shared.purchaseUpgrade(upgrade: upgrade, for: parent.manager)
        parent.list.update(selected: parent.selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // TODO ;)
        fatalError("init(coder:) has not been implemented")
    }
}
