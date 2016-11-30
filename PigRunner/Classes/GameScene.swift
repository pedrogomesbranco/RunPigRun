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
    var pauseMenu: PauseMenu!
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
        
        // Pause Menu
        //self.pauseMenu = PauseMenu(fileNamed: "PauseMenu", atPosition: CGPoint(x: self.cameraNode.frame.size.width/2, y: self.cameraNode.frame.size.height/2))
        
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
            
            let gameOverScene = MenuScene(size: size)
            gameOverScene.scaleMode = .fill
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
        let touchLocationHUD = touch.location(in: self.hudNode)
        let touchLocationPauseMenu = touch.location(in: self.pauseMenu.pauseMenu)
        
        if self.hud.hudBackground.contains(touchLocationHUD) { // Pause
            self.pauseButtonPressed()
        } else if self.pauseMenu.playBtn.contains(touchLocationPauseMenu) { // Play
            self.resumeButtonPressed()
        } else if self.pauseMenu.menuBtn.contains(touchLocationPauseMenu) { // Menu
            self.menuButtonPressed()
        } else { // Jump
            player.jump()
        }
    }
    
    private func pauseButtonPressed() {
        self.hud.pauseButton.tappedPauseButton()
        
        self.addChild(self.pauseMenu)
        
        if self.hud.pauseButton.tapped {
            self.isPaused = true
            self.hud.pauseButton.isHidden = true
        }
    }
    
    private func resumeButtonPressed() {
        self.pauseMenu.removeFromParent()
        self.isPaused = false
    }
    
    private func menuButtonPressed() {
        self.pauseMenu.removeFromParent()
        
        let menuScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        self.view?.presentScene(menuScene, transition: transition)
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
    
    func gameOver() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = SKScene(size: CGSize(width: 300, height: 300))
        gameOverScene.backgroundColor = UIColor.black
        
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == ColliderType.Player ? contact.bodyB : contact.bodyA
        
        player.collided(withBody: other)
    }
}
