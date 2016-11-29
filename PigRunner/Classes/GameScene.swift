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
    var garbageCollector: SKShapeNode!
    var ground: SKNode!
    var player: Player!
    var blocksGenerator: BlocksGenerator!
    let cameraNode = SKCameraNode()
    let hudNode = SKNode()
    var hud = HUD()
    
    private var timeStep = 0
    
    // Shared Instance
    static let GameSceneSharedInstance = GameScene()
    
    class var sharedInstance: GameScene {
        return GameSceneSharedInstance
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        setupNodes()
        //setupGestures()
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
                        categoryBitMask: ColliderType.Player,
                        collisionBitMask: ColliderType.Ground | ColliderType.Spikes)
        blocksGenerator.fgNode.addChild(player)
        
        // Setup camera
        setCameraPosition(position: CGPoint(x: size.width/2, y: size.height/2))
        addChild(cameraNode)
        camera = cameraNode
        
        // HUD
        self.cameraNode.addChild(self.hudNode)
        self.hud = HUD(lives: player.life, coinsCollected: player.coins, score: 0)
        self.hudNode.addChild(self.hud)
        
        self.hudNode.zPosition = GameLayer.Interface
        
        // Garbage Collector
        self.garbageCollector = SKShapeNode(rect: CGRect(x: -1100, y: -(kViewSizeHeight/2), width: 20, height: kViewSizeHeight))
        self.garbageCollector.physicsBody?.collisionBitMask = ColliderType.GarbageCollector
        self.garbageCollector.zPosition = 40
        
        //self.cameraNode.addChild(self.garbageCollector)
    }
    
    //    func setupGestures() {
    //        // Setup tap interaction control
    //        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapped))
    //        view?.addGestureRecognizer(tapGesture)
    //
    //        // Setup slide interaction control
    //        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown))
    //        swipeDown.direction = .down
    //        view?.addGestureRecognizer(swipeDown)
    //    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayer(timeStep)
        updateCamera()
        
        self.hud.updateCoinsCollected(self.player.coins)
        self.hud.updateScore(score: player.score)
        
        blocksGenerator.updateLevel(withCameraPosition: cameraNode.position)
        
        if player.life <= 0{
            player.die()
            self.removeAllChildren()
            self.removeAllActions()
            
            let gameOverScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
            let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
            
            self.view?.presentScene(gameOverScene, transition: transition)
        }
        
        timeStep += 1
    }
    
    // MARK: - User Interaction
    //    func tapped() {
    //        player.jump()
    //    }
    //
    //    func swipedDown() {
    //        player.slide()
    //    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchLocation = touch.location(in: self.hudNode)
        
        if self.hud.hudBackground.contains(touchLocation) {
            print("PAUSED")
            self.pauseButtonPressed()
        } else {
            player.jump()
        }
    }
    
    private func pauseButtonPressed() {
        self.hud.pauseButton.tappedPauseButton()
        
        if self.hud.pauseButton.tapped {
            self.isPaused = true
            self.hud.pauseButton.texture = SKTexture(imageNamed: "play")
        } else {
            self.isPaused = false
            self.hud.pauseButton.texture = SKTexture(imageNamed: "pause")
        }
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
        let other = contact.bodyA.categoryBitMask == ColliderType.Player ? contact.bodyB : contact.bodyA
        
        player.collided(withBody: other)
    }
}
