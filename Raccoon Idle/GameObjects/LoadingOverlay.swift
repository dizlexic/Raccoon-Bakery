//
//  LoadingOverlay.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/29/23.
//

import SpriteKit

class LoadingOverlay: SKSpriteNode {
    var gameData = GameData.shared
    var removing = false
    var removeAction = SKAction.fadeOut(withDuration: 0.3)

    init(size: CGSize) {
        super.init(texture: MenuBackground.yellow.texture, color: .magenta, size: size)
        self.position = .zero
        self.size = CGSize(width: size.width + 50, height: size.height+100)
        self.isUserInteractionEnabled = true
        self.zPosition = Constants.zPositions.Announce
    }
    
    func setup() {

    }
    
    func removeLoader() {
        run(removeAction, completion: {[weak self] in
            self?.removeFromParent()
        })
    }
    
    func update() {
        guard let _ = parent else { return }
        guard !removing else { return }
        guard GameController.shared.gameLoaded else { return }
        run(removeAction, completion: {[weak self] in
            self?.removeFromParent()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched :D")
        gameData.isLoading = false
        run(removeAction, completion: {[weak self] in
            self?.removeFromParent()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
