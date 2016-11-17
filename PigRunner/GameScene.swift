//
//  GameScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 06/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Properties
    var ground: SKNode!
    var player: Player!
    var blocksGenerator: BlocksGenerator!
    let cameraNode = SKCameraNode()
    private let hudNode = SKNode()
    private var hud = HUD()
    
    // Shared Instance
    static let sharedInstance = GameScene()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        setupNodes()
        setupGestures()
    }
    
    // MARK: - Init
    func setupNodes() {
        // Setup World (root) SKScene
        let worldNode = childNode(withName: "World")!
        
        // Setup level generation
        blocksGenerator = BlocksGenerator(withWorldNode: worldNode)
        blocksGenerator.setupInitialLevel()
        
        // Setup player
        player = Player(imageName: "Run_000",
                        pos: CGPoint(x: 0, y: -500),
                        categoryBitMask: ColliderTypes.Player,
                        collisionBitMask: ColliderTypes.Ground | ColliderTypes.Spikes)
        blocksGenerator.fgNode.addChild(player)
        
        // Setup camera
        setCameraPosition(position: CGPoint(x: size.width/2, y: size.height/2))
        addChild(cameraNode)
        camera = cameraNode

        // HUD
        self.cameraNode.addChild(self.hudNode)
        self.hud = HUD(lives: 2, coinsCollected: 0, score: 0)
        self.hudNode.addChild(self.hud)
        
        self.hudNode.zPosition = GameLayer.Interface
    }
    
    func setupGestures() {
        // Setup tap interaction control
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapped))
        view?.addGestureRecognizer(tapGesture)
        
        // Setup slide interaction control
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        updateCamera()
        player.updatePlayer()
        blocksGenerator.updateLevel(withCameraPosition: cameraNode.position)
    }
    
    // MARK: - User Interaction
    func tapped() {
        player.jump()
    }
    
    func swipedDown() {
        player.slide()
    }
    
    // MARK: - Camera
    func overlapAmount() -> CGFloat {
        guard let view = self.view else { return 0 }
        let scale = view.bounds.size.width / self.size.width
        let scaledHeight = self.size.height * scale
        let scaledOverlap = scaledHeight - view.bounds.size.height
        return scaledOverlap / scale
    }
    
    func getCameraPosition() -> CGPoint {
        return CGPoint(x: cameraNode.position.x, y: cameraNode.position.y + overlapAmount()/2)
    }
    
    func setCameraPosition(position: CGPoint) {
        cameraNode.position = CGPoint(x: position.x, y: position.y - overlapAmount()/2)
    }
    
    func updateCamera() {
        let cameraTarget = convert(player.position,
                                   from: blocksGenerator.fgNode)
        let targetPosition = CGPoint(x: cameraTarget.x + (scene!.view!.bounds.width * 0.8),
                                     y: getCameraPosition().y)
        let diff = targetPosition - getCameraPosition()
        let newPosition = getCameraPosition() + diff
        
        setCameraPosition(position: CGPoint(x: newPosition.x, y: size.height/2))
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == ColliderTypes.Player ? contact.bodyB : contact.bodyA
        
        player.collided(withBody: other)
    }
}
