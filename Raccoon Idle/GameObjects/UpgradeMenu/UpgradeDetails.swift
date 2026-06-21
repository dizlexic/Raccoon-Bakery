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
                   color: canPurchase ? DesignTokens.Colors.buttonHighlight : DesignTokens.Colors.buttonDisabled,
                   size: size)
        name = "UpgradeDetails"
        zPosition = Constants.zPositions.UIMenus3
        position = point

        // Ico
        let icon = SKSpriteNode(texture: upgrade.texture,
                                color: .black,
                                size: Constants.ButtonFrameBaseSize)
        icon.position = .zero
        icon.position.y += (size.height - icon.size.height) / 2 - DesignTokens.Spacing.uiPadding
        icon.position.x -= (size.width - icon.size.width) / 2 - DesignTokens.Spacing.uiPadding
        addChild(icon)
        
        // Name
        let label = SKLabelNode(text: "")
        label.fontName = DesignTokens.Fonts.medium
        label.fontSize = DesignTokens.Fonts.largeSize
        label.position = .zero // Zero is default I just do this for consistency (it's habit)
        label.position.y += (size.width - label.frame.height) / 2 - label.fontSize - DesignTokens.Spacing.uiPadding
        label.verticalAlignmentMode = .center
        addChild(label)

        // price
        let price = SKLabelNode(text: upgrade.adjustedPrice.displayValue)
        price.fontName = DesignTokens.Fonts.medium
        price.fontSize = DesignTokens.Fonts.defaultSize
        price.position = .zero // Zero is default I just do this for consistency (it's habit)
        price.position.y += icon.position.y
        price.position.x += (size.width - price.frame.width) / 2 - price.fontSize - DesignTokens.Spacing.uiPadding
        price.verticalAlignmentMode = .center
        price.horizontalAlignmentMode = .center
        addChild(price)
        
        // about
        let about = SKLabelNode(text: upgrade.about)
        about.fontName = DesignTokens.Fonts.medium
        about.fontSize = DesignTokens.Fonts.defaultSize
        about.lineBreakMode = .byWordWrapping
        about.preferredMaxLayoutWidth = 300
        about.numberOfLines = 0
        about.position = .zero
        about.verticalAlignmentMode = .center
        addChild(about)
        
        // PurchaseUpgradeButton
        let purchaseSize = CGSize(width: size.width, height: Constants.ButtonFrameBaseSize.height)
        let purchase = SKSpriteNode(texture: nil,
                                    color: canPurchase ? DesignTokens.Colors.buttonPrimary : DesignTokens.Colors.buttonDisabled,
                                    size: purchaseSize)
        purchase.position = .zero
        purchase.name = "PurchaseUpgrade"
        purchase.position.y -= (size.height - purchase.size.height) / 2
        isUserInteractionEnabled = true
        // PurchaseText
        let purchaseText = SKLabelNode(text: canPurchase ? "Purchase" : "Not enough cookies")
        purchaseText.fontName = DesignTokens.Fonts.medium
        purchaseText.fontSize = DesignTokens.Fonts.defaultSize
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
