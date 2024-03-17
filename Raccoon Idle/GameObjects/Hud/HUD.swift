//
//  UpgradeButton.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/28/23.
//

import SpriteKit

class HUD: SKNode, SetupCapable, UpdateCapable {
    var size: CGSize = .zero
    var lastInterval: TimeInterval = 0.0
    var delta_time: TimeInterval = 0.0
    var scoreLabel: SKNode?
    var scoreDisplay: ScoreDisplay?
    var portraits: [Portrait] = []
    var ownedPortraits: [Portrait] = []
    var cookie: Cookie?
    var activeOverlay: Overlay?

    // the limit for less vital ui updates in seconds
    let updateTimeInterval: TimeInterval = 2

    internal var updateCounter: TimeInterval = 0
    
    private let gameData: GameData = GameData.shared
    private let constants = Constants.self

    internal var isSetup: Bool = false
    lazy var setupsToRun: [()->Void] = [
        setupCookie.self,
        setupScoreDisplay.self,
        setupPortraits.self,
        setupNavButtons.self,
    ]

    func setup() throws {
        guard !isSetup else { return }
        guard let scene = scene else { return }
        guard let camera = scene.camera else { return }
        defer { isSetup = true }
        /// Mark: Z Position
        self.zPosition = constants.zPositions.UIObjects1
        /// Mark: Size
        self.size = CGSize(width: scene.size.width - constants.UIPadding,
                           height: scene.size.height - constants.UIPadding)

        for componentSetup in setupsToRun {
            componentSetup()
        }

        /// This line exists because I didn't plan well :D
        /// I add the hud to the scene to get all the scenes measurements in the setup
        /// but i need to remove it to add it as a child of the camera go figure
        // wackadoo hack a doo?
        if let _ = self.parent {
            removeFromParent()
        }
        camera.addChild(self)
    }
    
    func updateOwnedPortraits() {
        /// **exasperated infomercial actor**
        /// `There's gotta be a better way`
        guard ownedPortraits.count != gameData.frameList.count else { return }
        print("Debug: Updating portraits owned: \(ownedPortraits.count) != \(gameData.frameList.count)")
        
        let nodes = portraits.filter({ portrait in
            gameData.frameList.contains {
                guard let characterName = portrait.character?.name else {
                    print("no protrait character name")
                    return false
                }
                let name = "\($0.name) Manager"
                print(name)
                return name  == characterName
            }
        })

        enumerateChildNodes(withName: "portrait", using: { node, _ in
            node.removeFromParent()
        })
        print("nodes count \(nodes.count)")
        for node in nodes {
            addChild(node)
        }
        ownedPortraits = nodes
    }

    func updateOverlay() {
        guard let overlayType = Overlay.OverlayType(rawValue: GameData.shared.activeOverlay ?? "") else {
            activeOverlay = nil // scary? idk i need to look at how spritekit handles nil on children
            return
        }
        if let current = self.activeOverlay {
            guard current.type.name != overlayType.name else { return }
        }
        let overlay = Overlay(ofType: overlayType, ofSize: size)
        self.activeOverlay = overlay
        addChild(overlay)
    }
    
    func update(timeInterval: TimeInterval) {
        scoreDisplay?.update()
        updateOwnedPortraits()
        updateOverlay()
        activeOverlay?.update()
        guard updateTick(timeInterval: timeInterval) else { return }
        /// mark limited updates can go here
    }

    func updateTick(timeInterval: TimeInterval) -> Bool {
        delta_time = lastInterval == 0 ? 0 : timeInterval - lastInterval
        lastInterval = timeInterval
        updateCounter -= self.delta_time
        if updateCounter <= 0 {
            updateCounter = updateTimeInterval
            return true
        }
        return false
    }

    
}

extension HUD {
    func setupCookie() {
        let padding: CGFloat = 20.0
        let cookie = Cookie(size: CGSize(width: size.width / 2, height: size.width / 2))
        cookie.zPosition = constants.zPositions.UIObjects1
        cookie.isUserInteractionEnabled = true
        cookie.position = CGPoint(x: 0, y: (size.height / 2 - cookie.size.height / 2) * -1 + padding)
        cookie.spin()
        self.cookie = cookie
        addChild(cookie)
    }
    
    func setupScoreDisplay() {
        let scoreDisplay = ScoreDisplay(size: CGSize(width: size.width * 0.3, height: constants.ButtonFrameBaseSize.height - constants.UIPadding))
        scoreDisplay.zPosition = constants.zPositions.UIObjects1
        scoreDisplay.position =  CGPoint(x: size.width / 2 - constants.UIPadding - scoreDisplay.size.width / 2,
                                         y: size.height / 2 - constants.UIPadding - scoreDisplay.size.height)
        self.scoreDisplay = scoreDisplay
        addChild(scoreDisplay)
    }
    
    func setupNavButtons() {
        var buttons = [
            NavButton(type: .Upgrade),
            NavButton(type: .Statistic),
            NavButton(type: .Setting)
        ]
        
        repeat {
            guard let button = buttons.popLast() else { return }
            let offset: CGFloat = (Constants.ButtonFrameBaseSize.height + Constants.UIPadding) * CGFloat(buttons.count + 2)
            button.position = CGPoint(x: (size.width / 2 - Constants.UIPadding - 20),
                                       y: size.height / 2 - offset)
            button.isUserInteractionEnabled = true
            addChild(button)
        } while buttons.count > 0
        
    }

    func setupPortraits() {
        guard let scene = parent as? DemoScene else { return }
        for character in scene.characters {
            let portrait = Portrait(size: Constants.ButtonFrameBaseSize)
            portrait.name = "portrait"
            portrait.character = character as? CharacterNode
            portraits.append(portrait)
            let offset: CGFloat = (Constants.ButtonFrameBaseSize.height + Constants.UIPadding) * CGFloat(portraits.count)
            portrait.position = CGPoint(x: (size.width / 2 - Constants.UIPadding - 20) * -1,
                                        y: size.height / 2 - offset)
            portrait.zPosition = Constants.zPositions.UIObjects1
            portrait.setup()
            if ( gameData.frameList.contains(where: { manager in
                guard let charName = portrait.character?.name else { return false }
                let managerName = "\(manager.name) Manager"
                return managerName == charName
            })) {
                ownedPortraits.append(portrait)
                addChild(portrait)
            }
        }
    }
}
