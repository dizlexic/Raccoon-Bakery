//
//  UpgradeList.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/26/23.
//

import SpriteKit

fileprivate let defaultUpgradePrice = Currency(type: .Cookies, amount: 0)
fileprivate let defaultExpensiveUpgradePrice = Currency(type: .Cookies, amount: 100)
fileprivate let defaultUpgradeCPT = Currency(type: .Cookies, amount: 0.1)

class UpgradeList: Sprite {
    var selected: Upgrade?
    var list = SKSpriteNode(color: .clear, size: .zero)
    var cropNode = SKCropNode()
    var manager: Manager
    var maskNode: SKSpriteNode
    var rows: [UpgradeRow] = []
    var upgrades: [Upgrade] = []
    
    init(for manager: Manager, size: CGSize) {
        self.manager = manager
        self.maskNode = SKSpriteNode(color: .magenta, size: size)
        super.init(texture: nil, color: .clear, size: size)
        self.name = "UpgradeList"
        self.isUserInteractionEnabled = true
        self.zPosition = Constants.zPositions.UIMenus3
        self.position = CGPoint.zero
        self.upgrades = manager.upgrades
        list.size = size
        cropNode.addChild(list)
        cropNode.name = "CropNode"
        addChild(cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.maskNode = SKSpriteNode(color: .magenta, size: .zero)
        self.manager = Manager(name: "No Manager")
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let size =  CGSize(width: 100, height: 100)
        let offset: CGFloat = 20.0 + size.height
        list.removeAllChildren()
        let sorted = upgrades.sorted(by: {$0.adjustedPrice <= $1.adjustedPrice })
        for upgrade in sorted {
            let row = UpgradeRow(upgrade: upgrade, for: manager, size: size)
            row.position = CGPoint(x: (size.width * -1) + offset * CGFloat(rows.count), y: 0)
            list.addChild(row)
            rows.append(row)
        }
        cropNode.maskNode = maskNode
    }
    
    func update(selected: Upgrade?) {
        rows = []
        setup()
        guard let parent = self.parent as? UpgradeMenu else {
            print("Warn: Upgrade List node parent was not an Upgrade Menu node!")
            return
        }
        parent.selected = selected ?? manager.sortedUpgrades.first
        parent.drawUpgradeDetails(for: parent.selected)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let upgradeNode = nodes(at: touch.location(in: self)).first(where: { ($0 as? UpgradeRow) != nil }) as? UpgradeRow else {
            print("not an upgrade?")
            return
        }
        
        guard let parent = self.parent as? UpgradeMenu else {
            print("Warn: Upgrade List node parent was not an Upgrade Menu node!")
            return
        }

        guard let upgrade = upgradeNode.upgrade else {
            print("Warn: Upgrade nodes upgrade is nil!")
            return
        }
        update(selected: upgrade)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        let currentPosition = list.position
        let maxX = CGFloat((rows.count - 2) * -120)
        let newPosition = CGPoint(x: currentPosition.x + location.x - previous.x, y: currentPosition.y)
        if newPosition.x <= 0 && newPosition.x >= maxX {
            list.position = newPosition
        }
        
        print(list.position.x, list.size.width)
        print("\(location.y - previous.y)")
    }
}


class UpgradeRow: Sprite {
    var upgrade: Upgrade?
    var manager: Manager?
    
    init(upgrade: Upgrade, for manager: Manager?, size: CGSize) {
        var texture: SKTexture?
        if GameData.shared.canPurchaseUpgrade(upgrade: upgrade) {
            texture = upgrade.icons[0]
        } else {
            texture = upgrade.icons[1]
        }
        
        super.init(texture: texture, color: .gray, size: size)
        self.upgrade = upgrade
        self.manager = manager
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
