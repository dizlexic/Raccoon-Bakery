//
//  ScoreLabel.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit

class ScoreDisplay: SKSpriteNode {
    var label: ScoreLabel
    var labels: [ScoreLabel]
    var scale: CGFloat = 1.0
    let gameData: GameData = GameData.shared
    
    init(size: CGSize) {
        self.label = ScoreLabel(at: .zero)
        self.labels = []
        let texture = SKTexture(imageNamed: "icon_06")
        super.init(texture: texture, color: .clear, size: size)
        self.name = "ScoreDisplay"

        zPosition = Constants.zPositions.UIObjects1
        // for currency in GameData.shared.wallet {
        let node = SKSpriteNode()
        node.size.height = size.height
        node.size.width = texture.size().width // / CGFloat(GameData.shared.wallet.count)
        
        node.position.y = .zero
        node.position.x = .zero
        addChild(node)
        let label = ScoreLabel()
        let held = GameData.shared.wallet.held(.Cookies)
        let amount = held?.displayValue ?? "0"
        let name = held?.type.name ?? "MissingNo"

        label.name = name
        label.text = amount // label.text = "\(currency.amount)"
        label.position.y = .zero
        label.position.x = .zero
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.preferredMaxLayoutWidth = node.size.width
        labels.append(label)
        node.addChild(label)
        // }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        for label in labels {
            guard let currency = GameData.shared.wallet.held(CurrencyType(name: label.name)) else { continue }
            label.update(text: currency.displayValue)
        }
    }
}

class ScoreLabel: SKLabelNode {
    let roundingBehavior = NSDecimalNumberHandler(
        roundingMode: .plain,
        scale: 3,
        raiseOnExactness: false,
        raiseOnOverflow: false,
        raiseOnUnderflow: false,
        raiseOnDivideByZero: true
    )
    let baseFontSize: CGFloat = 8.0
    let minFontSize: CGFloat = 6.0
    
    var width: Double {
        self.frame.width
    }
    
    var height: Double {
        self.frame.height
    }
    
    func update(text: String) {
        if self.text != text {
            self.text = text
            self.scale()
        }
    }
    
    func scale() {
        guard let parent = parent as? SKSpriteNode else {
            print("Warn: No parent to scale from. This shouldn't be being called.")
            return
        }

        let tempLabel = SKLabelNode(fontNamed: self.fontName)
        tempLabel.fontSize = baseFontSize
        tempLabel.text = self.text
        let naturalWidth = tempLabel.frame.width
        let naturalHeight = tempLabel.frame.height

        if naturalWidth == 0 || naturalHeight == 0 { return }
        if parent.size.width == 0 || parent.size.height == 0 { return }

        let roundingRule = FloatingPointRoundingRule.toNearestOrEven
        let scaleX = parent.size.width / naturalWidth
        let scaleY = parent.size.height / naturalHeight
        let scale = min(scaleX, scaleY).rounded(roundingRule)

        self.fontSize = max(minFontSize, baseFontSize * scale)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        guard let scene = scene as? GameScene else { return }
        guard let overlay = scene.overlay else { return }
        scene.hud.addChild(overlay)
    }

    required init(at position: CGPoint?) {
        super.init()
        self.verticalAlignmentMode = .baseline
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = 1
        self.zPosition = 1
        self.fontName = "SanFranciscoRounded-Medium"
        self.fontSize = 8
        self.horizontalAlignmentMode = .center
        self.text = "0"
        guard let pos = position else { return }
        self.position = pos
    }
    
    convenience override init() {
        self.init(at: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
