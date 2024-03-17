//
//  Character.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/24/23.
//

import SpriteKit


enum CharacterAction {
    case walk, idle, flair
}

class CharacterNode: Sprite {
    typealias Direction = AppType.Direction
    typealias ActionFrame = (CharacterAction, [(Direction, [SKTexture])])
    typealias MoveAction = () -> [CGPoint]?

    private var isRunningSequence: Bool = false
    
    var actionFrames: [ActionFrame?] = []
    var moveActions: [MoveAction] = []

    var flairIntervalRange: ClosedRange<Int> = 10...30

    var flairInterval: Int {
        guard let random = flairIntervalRange.randomElement() else {
            print("Random failed? It's OVER 9000!")
            return 9001
        }
        return random
    }

    var startPosition: CGPoint = .zero
    /// Direction the character is facing
    var facing: Direction?
    var portrait: String = "raccoon_00"
    /// Avalible directions that this character can move
    let moveDirections: [Direction] = [.up, .down, .left, .right]
    /// Avalible directions that this character can idle in
    let idleDirections: [Direction] = [.up, .down, .left, .right]

    /// Could be named is moving because idle ignores this

    var frameChunks: [[SKTexture]] {
        frames.chunked(into: 2)
    }

    var walking = false

    var direction: Direction? {
        facing
    }

    var atlas: SKTextureAtlas?

    func setup() {
        
    }
    
    func runFlair() {
        let action = buildActionAnimation(for: .flair, in: facing ?? .down, repeat: false)
        runLock(sequence: [action])
    }
    
    func runLock(sequence: [SKAction], override: Bool = false) {
        if override { isRunningSequence = false } // This shouldn't be a thing
        guard isRunningSequence == false else {
            print("Debug: Character is already running sequence")
            return
        }
        let action = SKAction.sequence(sequence)
        
        isRunningSequence = true
        run(action, completion: { [weak self] in
            guard let self = self else { return }
            self.isRunningSequence = false
            self.stand(direction: self.direction ?? .down)
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(flairInterval))) { [weak self] in
                self?.runFlair()
            }
        })
    }

    func buildAnimation(frames: [SKTexture], repeatForever: Bool = true, tpf: CGFloat = 0.3) -> SKAction {
        var action = SKAction.animate(with: frames, timePerFrame: tpf, resize: false, restore: false)
        if repeatForever {
            action = SKAction.repeatForever(action)
        }
        return action
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene as? DemoScene else { return }
        scene.cameraFocus = self as SKSpriteNode
        stand(direction: Direction.allCases.randomElement()!)
    }
    
    func buildActionAnimation(for action: CharacterAction,in direction: Direction, repeat forever: Bool = true) -> SKAction {
        guard let actionSet = actionFrames.compactMap( { $0 } ).first(where: { $0.0 == action }) else { return SKAction() }
        guard let textures = actionSet.1.first(where: {$0.0 == direction })?.1 else { return SKAction() }
        return buildAnimation(frames: textures, repeatForever: forever, tpf: 0.6)
    }
    
    func stand(direction: Direction) {
        walking = false
        self.facing = direction
        let animation = buildActionAnimation(for: .idle, in: direction)
        run(animation)
    }
    
    func walkBy(units: Int, in direction: Direction) {
        guard !walking else { return }
        walking = true
        let dUnits = Double(units)
        let duration = Constants.CharacterMoveDuration * dUnits
        let animation = buildActionAnimation(for: .walk, in: direction)
        run(animation)
        run(SKAction.move(
            by: CGVector(dx: direction.cgVector.dx * Constants.GameCellUnit * dUnits, dy: direction.cgVector.dy * Constants.GameCellUnit * dUnits),
            duration: duration))
        { [weak self] in
            self?.stand(direction: direction)
        }
    }
}
