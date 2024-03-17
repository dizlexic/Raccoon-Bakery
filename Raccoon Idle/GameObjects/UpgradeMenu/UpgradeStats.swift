//
//  UpgradeStats.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/16/23.
//

import SpriteKit
import Combine

fileprivate class StatsLabel: SKLabelNode {
    init(text: String) {
        super.init()
        self.text = text
        self.fontName = "SanFranciscoRounded-Medium"
        self.fontSize = 18
        self.horizontalAlignmentMode = .center
        self.verticalAlignmentMode = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class UpgradeStats: SKSpriteNode {
    let container: SKNode = SKNode()

    private var cancellables = Set<AnyCancellable>()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: nil, color: .magenta, size: size)
        zPosition = Constants.zPositions.UIObjects1
        addChild(container)
        subscribeToUpdates()
    }
    
    func subscribeToUpdates() {
        GameData.shared.updateManagerPublisher
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let parent = self?.parent as? UpgradeMenu else { return }
                self?.update(for: parent.manager)
            }.store(in: &cancellables)
    }
    
    func update(for manager: Manager?) {
        guard let manager = manager else { return }
        
        print("Status Update")
        let ipt = manager.incomePerTick // Currency
        let cps = manager.calcCPSecond() // Decimal :O
        let cpsText = cps.formatted(.number.precision(.fractionLength(2)))
        container.removeAllChildren()
        
        let iptLabel = StatsLabel(text: "\(ipt.displayValue) / CPT")
        iptLabel.position = .zero
        iptLabel.position.y += size.height / 2 - Constants.UIPadding
        container.addChild(iptLabel)
        
        let cpsLabel = StatsLabel(text: "\(cpsText) / CPS")
        cpsLabel.position = .zero
        cpsLabel.position.y = iptLabel.position.y - iptLabel.frame.size.height
        container.addChild(cpsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        zPosition = Constants.zPositions.UIObjects1
        addChild(container)
        subscribeToUpdates()
    }
}
