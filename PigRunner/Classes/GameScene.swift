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
    var player: Player!
    var blocksGenerator: BlocksGenerator!
    var hud = HUD()
    
    let cameraNode = SKCameraNode()
    let hudNode = SKNode()
    let gameOver = GameOver()
    let pauseMenu = PauseMenu()
    
    private var timeStep = 0
    
    // Shared Instance
    static let GameSceneSharedInstance = GameScene()
    
    class var sharedInstance: GameScene {
        return GameSceneSharedInstance
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Reset GameData for current game
        GameData.sharedInstance.reset()
        setupNodes()
    }
    
    // MARK: - Init
    func setupNodes() {
        // Setup World (root) SKScene
        let worldNode = childNode(withName: "World")!
        
        // Apply ground height to variable (used to position each block on the correct Y value)
        let groundNode = worldNode.childNode(withName: "Background")!.childNode(withName: "Block")!.childNode(withName: "Ground")! as! SKSpriteNode
        groundHeight = groundNode.size.height
        
        // Setup level generation
        blocksGenerator = BlocksGenerator(withWorldNode: worldNode)
        blocksGenerator.setupInitialLevel()
        
        // Setup player
        player = Player(imageName: "Run_000",
                        pos: CGPoint(x: 0, y: -550),
                        categoryBitMask: ColliderType.Player,
                        collisionBitMask: ColliderType.Ground | ColliderType.Spikes)
        blocksGenerator.fgNode.addChild(player)
        
        // Setup camera
        setCameraPosition(position: CGPoint(x: size.width/2, y: size.height/2))
        addChild(cameraNode)
        camera = cameraNode
        
        // HUD
        self.cameraNode.addChild(self.hudNode)
        self.hud = HUD(lives: player.life, coinsCollected: GameData.sharedInstance.coins, score: 0)
        self.hudNode.addChild(self.hud)
        
        self.hudNode.zPosition = GameLayer.Interface
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        checkDeath()
        
        player.updatePlayer(timeStep)
        updateCamera()
        
        self.hud.updateCoinsCollected(GameData.sharedInstance.coins)
        self.hud.updateScore(score: GameData.sharedInstance.score)
        
        blocksGenerator.updateLevel(withCameraPosition: cameraNode.position)
        
        timeStep += 1
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchLocationHUD = touch.location(in: self.hudNode)
        let touchLocationPauseMenu = touch.location(in: self.pauseMenu.pauseMenuNode)
        let touchLocationGameOver = touch.location(in: self.gameOver.gameOverNode)
        
        if self.hud.hudBackground.contains(touchLocationHUD) { // Pause
            self.pauseButtonPressed()
        } else if self.pauseMenu.playBtn.contains(touchLocationPauseMenu) { // Play (Pause)
            self.pauseMenu.tappedButton()
            self.isPaused = false
            self.hud.pauseButton.isHidden = false
        } else if self.pauseMenu.menuBtn.contains(touchLocationPauseMenu) { // Menu (Pause)
            self.pauseMenu.tappedButton()
            self.updateGameData()
            self.goToMenu()
        } else if self.gameOver.restartBtn.contains(touchLocationGameOver) { // Restart (GameOver)
            self.gameOver.tappedButton()
            self.updateGameData()
            self.restartGame()
        } else if self.gameOver.menuBtn.contains(touchLocationGameOver) { // Menu (GameOver)
            self.gameOver.tappedButton()
            self.updateGameData()
            self.goToMenu()
        } else if self.gameOver.continueBtn.contains(touchLocationGameOver) { // Continue (GameOver)
            self.gameOver.tappedButton()
            self.continueGame()
        } else { // Jump
            player.jump()
        }
    }
    
    private func pauseButtonPressed() {
        self.hud.pauseButton.tappedPauseButton()
        pauseMenu.show(at: CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2), onNode: self.cameraNode)
        self.cameraNode.addChild(pauseMenu)
        self.pauseMenu.position = CGPoint(x: self.cameraNode.calculateAccumulatedFrame().width/2, y: self.cameraNode.calculateAccumulatedFrame().height/2)
        
        if self.hud.pauseButton.tapped {
            self.isPaused = true
            self.hud.pauseButton.isHidden = true
        }
    }
    
    private func goToMenu() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = .fill
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    private func continueGame() {
        if GameData.sharedInstance.totalCoins >= 1000 {
            GameData.sharedInstance.totalCoins -= 1000
            GameData.sharedInstance.save()
            self.player.revive()
        }
    }
    
    private func restartGame() {
        let gameScene = GameScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene)
    }
    
    private func updateGameData() {
        GameData.sharedInstance.highScore = max(GameData.sharedInstance.highScore, GameData.sharedInstance.score)
        GameData.sharedInstance.totalCoins += GameData.sharedInstance.coins
        
        GameData.sharedInstance.save()
    }
    
    private func checkDeath() {
        if player.life <= 0 {
            player.die()
            
            // Display GameOver Overlay
            gameOver.show(at: CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2), onNode: self.cameraNode)
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
        let targetPosition = CGPoint(x: cameraTarget.x + (scene!.view!.bounds.width * 1.1),
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
