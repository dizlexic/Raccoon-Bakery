//
//  UpgradeMenu.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/28/23.
//

import SpriteKit
import Combine

class UpgradeMenu: SKSpriteNode {
    var selected: Upgrade?
    var displayed: Upgrade?
    var manager: Manager
    var list: UpgradeList
    var stats: UpgradeStats
    
    private var cancellables = Set<AnyCancellable>()
    
    func update() {
        stats.update(for: manager)
        list.update(selected: selected)
    }
    
    func drawOwnedButton() {
        let h = min(size.height * 0.3, 100)
        let w = size.width
        let purchaseButton = PurchaseButton(for: manager, of: CGSize(width: w, height: h))
        purchaseButton.position = .zero
        purchaseButton.position.y += purchaseButton.size.height + Constants.UIPadding
        addChild(purchaseButton)
    }
    
    func drawStatistics() {

    }
    
    func drawUpgradeDetails(for upgrade: Upgrade?) {
        guard let upgrade = upgrade else {
            print("no selected")
            return
        }

        guard let list = childNode(withName: "UpgradeList") as? UpgradeList else {
            print("Unable to find child node UpgradeList")
            return
        }
        
        if let details = childNode(withName: "UpgradeDetails") {
            print("removing previous upgrade details")
            details.removeFromParent()
        }
        
        defer { displayed = upgrade }

        var detailSize = CGSize.zero
        detailSize.height = size.height / 2 - list.size.height
        detailSize.width = size.width

        var detailOrigin: CGPoint = list.position
        detailOrigin.y -= (detailSize.height + list.size.height + Constants.UIPadding) / 2 
        
        let details = UpgradeDetails(for: upgrade, at: detailOrigin, of: detailSize)
        addChild(details)
    }
    
    init(for manager: Manager, size: CGSize) {
        self.manager = GameData.shared.ownedManagers.first(where: { $0.type == manager.type }) ?? manager /// DIRRRTY
        let listh = min(size.height * 0.3, 100)
        let listw = size.width
        list = UpgradeList(for: manager, size: CGSize(width: listw, height: listh))
        list.setup()

        let stats = UpgradeStats(texture: nil, color: .magenta, size: CGSize(width: size.width, height: size.height * 0.22))
        stats.zPosition = Constants.zPositions.UIObjects1
        stats.position = .zero
        stats.position.y += (size.height - stats.size.height) / 2
        self.stats = stats
        
        super.init(texture: nil, color: .magenta, size: size)
        
        addChild(list)
        addChild(stats)
        // Setup the first as selected
        if let selected = list.rows.first?.upgrade {
            drawUpgradeDetails(for: selected)
        } // this could be buggy
        drawOwnedButton()
        drawStatistics()
        GameData.shared.updateManagerPublisher
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.update()
            })
            .store(in: &cancellables)
        
        selected = list.selected
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {

        list = UpgradeList(for: Manager(name: "No Manager"), size: .zero)
        list.setup()
        
        let stats = UpgradeStats(texture: nil, color: .magenta, size: .zero)
        stats.zPosition = Constants.zPositions.UIObjects1
        stats.position = .zero
        self.stats = stats
        
        self.manager = Manager(name: "Manager")
        super.init(coder: aDecoder)
    }
}
