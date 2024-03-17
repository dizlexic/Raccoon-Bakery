//
//  DemoScene.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/22/23.
//

import SpriteKit


extension DemoScene: SetupCapable {

    func setup() throws {
        defer { print ("DemoScene Setup Completed") }
        guard let view = self.view else { return }
        let safeArea = view.safeAreaLayoutGuide.layoutFrame.size
        size = CGSize(width: gameConfig.size.width + safeArea.width, height: gameConfig.size.height - 50)
        setupCharacters()
        setupHud()
    }

    func setupHud() {
        addChild(hud)
        try? hud.setup()
    }
    
    func setupRaccoms() {
        defer {
            print("Debug: Raccoms setup complete")
        }
        
        let raccoons = children.filter {
            $0 as? Raccoon != nil
        }
        
        for node in raccoons {
            guard let raccom = node as? Raccoon else { continue }
            raccom.setup()
            node.isUserInteractionEnabled = true
            
            if let manger = ManagerType(rawValue: raccom.name) {
                let data = manger.configData
                raccom.stand(direction: data.facing)
            } else {
                raccom.stand(direction: .down)
            }
            
            characters.append(raccom as SKSpriteNode)
        }
    }

    func setupCharacters() {
        setupRaccoms()
    }
}

class DemoScene: SKScene {
    
    typealias Direction = AppType.Direction
    let hud: HUD = HUD()
    var scoreLabel: ScoreLabel?
    var cookieNode: Cookie?
    var cameraFocus: SKSpriteNode?
    var animatingScale: Bool = false
    var currentScale: CGFloat = 0.50
    var characters: [SKSpriteNode] = []
    var menu: SKSpriteNode? = nil
    var overlay: SKSpriteNode? = nil
    var purchaseOverlay: SKSpriteNode? = nil
    var portraits: [Portrait] = []
    var selectedUpgrade: Upgrade? = nil
    var isSetup: Bool = false
    var setupsToRun: [SetupMethods] = []
    var loadingOverlay: LoadingOverlay
    
    var gameData = GameData.shared
    var gameConfig = GameConfiguration.shared
    
    override func didMove(to view: SKView) {
        backgroundColor = .purple
        if gameData.ownedManagers.count < 1 {
            print ("owns no managers :(")
        }
        
        if let updatedAt = gameData.updatedAt {
            print("\("\(updatedAt)")")
        }
        
        gameData.updatedAt = Date.now
        
        isUserInteractionEnabled = true
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        do {
            try setup()
        } catch {
            print(error)
        }

        cameraFocus = characters.first
        gameData.updateSelectedManagerByCharacter(character: characters.first)
        let overlay = LoadingOverlay(size: size)
        self.loadingOverlay = overlay
        hud.addChild(overlay)

        let nodes = children.compactMap {
            $0 as? SKSpriteNode
        }
        
        for node in nodes {
            node.texture?.filteringMode = .nearest
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        hud.update(timeInterval: currentTime)
        loadingOverlay.update()
        updateCamera()
        updateIncome()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        moveRaccon(location: location)
        if let upgrade = selectedUpgrade {
            print(upgrade.name)
        }
    }
    
    func moveRaccon(location: CGPoint) {
        if let focus = self.cameraFocus {
            let xCheck = focus.position.x - location.x + focus.size.width / 2
            let yCheck = focus.position.y - location.y + focus.size.height / 2
            
            var rightOrLeft: Direction {
                if xCheck > 0 {
                    return .left
                }
                return .right
            }
            
            var upOrDown: Direction {
                print("y check \(yCheck)")
                if yCheck > 0 {
                    return .down
                }
                return .up
            }
            
            var direction: Direction {
                if upOrDown == .up && rightOrLeft == .left {
                    print ("up or left yCheck > xCheck \(yCheck > xCheck)")
                    return yCheck < xCheck * -1 ? .up : .left
                } else if upOrDown == .down && rightOrLeft == .left {
                    print ("down or left yCheck < xCheck * -1 \(yCheck < xCheck * -1)")
                    return yCheck > xCheck ? .down : .left
                } else if upOrDown == .up && rightOrLeft == .right {
                    print ("up or right yCheck > xCheck * -1 \(yCheck > xCheck * -1 )")
                    return yCheck > xCheck ? upOrDown : rightOrLeft
                } else {
                    print ("yCheck < xCheck * -1 else \(yCheck < xCheck * -1)")
                    return yCheck * -1 < xCheck ? upOrDown : rightOrLeft
                }
            }
            
            if let node = focus as? Raccoon {
                node.walkBy(units: 4, in: direction)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        guard let camera = self.camera else {
            return
        }
        camera.position.x += location.x - previousLocation.x
        camera.position.y += location.y - previousLocation.y
    }

    func updateCamera() {
        guard let focus = self.cameraFocus else { return }
        guard let camera = self.camera else { return }
        camera.setScale(currentScale)
        if camera.position != focus.position {
            let vec = CGVector(dx: (focus.position.x - camera.position.x) * 0.1, dy: (focus.position.y - camera.position.y) * 0.1)
            camera.position = CGPoint(x: camera.position.x + vec.dx, y: camera.position.y + vec.dy)
        }
    }
    
    func presentPurchaseOverlay(for manager: Manager) {
        print("presented purchase overlay for manager \(manager.name)")
        let width = min(size.width - 80, 300)
        let height = min(size.height / 2, 200)
        let overlay = PurchaseOverlay(for: manager, size: CGSize(width: width, height: height))
        hud.addChild(overlay)
        self.purchaseOverlay = overlay
    }
    
    func removePurchaseOverlay() {
        guard let purchaseOverlay = purchaseOverlay as? PurchaseOverlay else {
            print("no overlay")
            return
        }
        run(purchaseOverlay.fadeOut, completion: {
            
        })
    }
    
    func updateIncome() {
        for manager in gameData.ownedManagers {
            manager.update()
        }
    }
    
    override init(size: CGSize) {
        self.loadingOverlay = LoadingOverlay(size: size)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.loadingOverlay = LoadingOverlay(size: .zero)
        super.init(coder: aDecoder)
        self.loadingOverlay.size = self.size
    }
}
