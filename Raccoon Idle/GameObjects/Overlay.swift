//
//  Overlay.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/26/23.
//

import SpriteKit

enum MenuBackground: String {
    case yellow

    var name: String {
        switch self {
            case .yellow:
                return "yellowmenubg"
        }
    }

    var texture: SKTexture? {
        SKTexture(imageNamed: self.name)
    }
    
    var uiColor: UIColor {
        switch self {
            default: return .clear
        }
    }

}

class Overlay: Sprite {

    enum OverlayType: String {
        case Setting, Statistic, Upgrade
        var name: String {
            "\(self.rawValue)Overlay"
        }

        var menuBackground: MenuBackground {
            MenuBackground(rawValue: self.rawValue) ?? .yellow
        }
    }

    var type: OverlayType
    var selected: Manager?
    var score: ScoreDisplay?
    var title: OverlayTitle?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromParent()
        GameData.shared.activeOverlay = nil
    }


    
    func update() {
        // TODO make this scene agnostic or at least be aware of this
        if let scene = scene as? DemoScene {
            guard let current = scene.hud.childNode(withName: "ScoreDisplay") as? ScoreDisplay else {
                print("this didn't work :(")
                return
            }
            score?.removeFromParent()
            score = ScoreDisplay(size: current.size)
            score?.update()
            score?.position.y = title?.position.y ?? size.height - (score?.size.height ?? .zero)
            score?.position.x += size.width / 2 - (score?.size.width ?? .zero)
            if let score = self.score {
                addChild(score)
            }
        }
    }
    
    init(
        ofType type: OverlayType,
        ofSize size: CGSize,
        atPosition position: CGPoint = .zero
    ) {
        self.type = type
        super.init(texture: type.menuBackground.texture, color: type.menuBackground.uiColor, size: size)
        self.name = type.name
        self.position = position
        self.zPosition = Constants.zPositions.UIMenus3
        self.isUserInteractionEnabled = true
        
        print("Selected Manager \(GameData.shared.selectedManager?.name ?? "None")")
        
        self.selected = GameData.shared.selectedManager
        
        let title = OverlayTitle(text: selected?.name ?? type.name, size: CGSize(width: size.width / 2, height: Constants.ButtonFrameBaseSize.height))
        title.scaleLabel()
        title.position.y = size.height / 2 - title.frame.height - Constants.UIPadding
        title.position.x = (size.width / 2 - title.frame.width) * -1
        
        addChild(title)
        self.title = title
        
        var menu: SKSpriteNode
        let menuSize = CGSize(width: size.width - Constants.UIPadding * 8, height: size.height - title.size.height - Constants.UIPadding * 8)
        guard let selected = selected else { return }
        switch type {
            case .Upgrade:
                menu = UpgradeMenu(for: selected, size: menuSize)
            default:
                menu = StatisticsMenu(size: menuSize)
        }
        
        print("selected \(selected.name)")
        menu.position = .zero
        menu.position.y -= title.size.height / 2
        addChild(menu)
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = .Setting
        super.init(coder: aDecoder)
    }
    
}

class OverlayTitle: SKSpriteNode {
    let label: SKLabelNode = SKLabelNode(text: "Overlay Title")

    init(text: String = "", size: CGSize = .zero) {
        super.init(texture: nil, color: .magenta, size: size)
        addChild(label)
        label.text = text
        label.zPosition = Constants.zPositions.UIObjects1
        label.horizontalAlignmentMode = .right
        label.verticalAlignmentMode = .center
        label.fontName = "SanFranciscoRounded-Medium"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addChild(label)
    }
    
    func scaleLabel() {
        guard let w = NumberFormatter().number(from: String(format: "%0.5f", size.width / label.frame.width)) else { return }
        guard let h = NumberFormatter().number(from: String(format: "%0.5f", size.height / label.frame.height)) else { return }
        let scale = min(CGFloat(truncating: w), CGFloat(truncating: h))
        let newSize = (label.fontSize * scale) - label.fontSize
        if newSize > 1 || newSize < -1 {
            label.fontSize *= scale
        }
    }
    
    deinit {
        print("\(label.text ?? "unknown") is deinit")
    }
}
