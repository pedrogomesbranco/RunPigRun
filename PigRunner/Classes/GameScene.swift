//
//  GameScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 06/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit
import FBSDKCoreKit

class GameScene: SKScene {
    
    // MARK: - Properties
    var player: Player!
    var blocksGenerator: BlocksGenerator!
    var hud = HUD()
    var gamePaused: Bool = false
    
    let cameraNode = SKCameraNode()
    let hudNode = SKNode()
    let parallax = SKSpriteNode()
    let gameOver = GameOver()
    let pauseMenu = PauseMenu()
    var cdNode = SKLabelNode()
    
    let whiteBg =  SKSpriteNode(imageNamed: "Rectangle 2-2")
    
    private var timeStep = 0
    
    // View Controller
    var viewController: GameViewController!
    
    // Facebook Configuration
    var fbConnection: FacebookConnection!
    
    //Timer
    var timer: Timer!
    var counter = 3
    
    // Shared Instance
    static let GameSceneSharedInstance = GameScene()
    
    class var sharedInstance: GameScene {
        return GameSceneSharedInstance
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -15.0)
        
        gameOver.fbConnection = self.fbConnection
        
        print(self.fbConnection)
        
        // Reset GameData for current game
        GameData.sharedInstance.reset()
        setupNodes()
        countdownNode()
    }
    
    func countdownNode (){
        self.whiteBg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.whiteBg.position = CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2)
        self.whiteBg.alpha = 1
        self.whiteBg.zPosition = 5
        self.cameraNode.addChild(whiteBg)
        
        self.isPaused = true
        self.gamePaused = true
        self.hud.pauseButton.isHidden = true
        self.hud.hideAll()
        
        //        var cdNode = SKLabelNode()
        cdNode = SKLabelNode(fontNamed: "Space Comics")
        cdNode.position = CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2)
        cdNode.text = "3"
        cdNode.fontSize = 150
        cdNode.alpha = 1
        cdNode.zPosition = 7
        cdNode.fontColor = SKColor.black
        
        self.whiteBg.addChild(cdNode)
        
        timer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func updateCounter (){
        if counter == 0{
            cdNode.text = "RUN!"
            self.run(GameAudio.sharedInstance.soundPurchase)
        }
        else{
            cdNode.text = String (counter)
        }
        
        if(counter == -1){
            timer.invalidate()
            self.whiteBg.removeFromParent()
            self.isPaused = false
            self.gamePaused = false
            self.hud.pauseButton.isHidden = false
            self.hud.showAll()
            self.cdNode.isHidden = true
        }
        counter -= 1
    }
    
    // MARK: - Init
    func setupNodes() {
        // GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundMusic)
        // Setup World (root) SKScene
        let worldNode = childNode(withName: "World")!
        
        self.whiteBg.size = self.size
        // Apply ground height to variable (used to position each block on the correct Y value)
        let groundNode = worldNode.childNode(withName: "Background")!.childNode(withName: "Block")!.childNode(withName: "Ground")! as! SKSpriteNode
        groundHeight = groundNode.size.height
        
        // Setup level generation
        blocksGenerator = BlocksGenerator(withWorldNode: worldNode)
        blocksGenerator.setupInitialLevel()
        
        // Setup player
        player = Player(imageName: "Running 01",
                        pos: CGPoint(x: groundHeight, y: -376.929382324219),
                        categoryBitMask: ColliderType.Player,
                        collisionBitMask: ColliderType.Ground
                            | ColliderType.KnifesBox
                            | ColliderType.NetTrap
                            | ColliderType.Hydrant
                            | ColliderType.BearTrap
                            | ColliderType.Life
                            | ColliderType.Steamroller)
        blocksGenerator.fgNode.addChild(player)
        
        // Setup camera
        updateCamera()
        addChild(cameraNode)
        camera = cameraNode
        
        // HUD
        self.cameraNode.addChild(self.hudNode)
        self.hud = HUD(coinsCollected: GameData.sharedInstance.coins, score: 0, lifes: self.player.life)
        self.hudNode.addChild(self.hud)
        self.hud.showAll()
        self.hud.updateLife(life: player.life)
        self.hudNode.zPosition = 1
        
        self.cameraNode.zPosition = -1
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        if !checkpause(){
            checkDeath()
            
            player.updatePlayer(timeStep)
            
            updateCamera()
            
            //      self.hud.updateCoinsCollected(GameData.sharedInstance.coins)
            self.hud.updateScore(score: GameData.sharedInstance.score)
            self.hud.updateLife(life: player.life)
            if self.player.isGliding {
                self.player.glide()
            }
            
            blocksGenerator.updateLevel(withCameraPosition: cameraNode.position, player: player)
            
            timeStep += 1
        }
        else {
            self.isPaused = true
            self.gamePaused = true
        }
        speedSet()
    }
    
    func speedSet(){
        if player.velocityX < 1400 {
            player.velocityX = Int(0.15094 * Double(GameData.sharedInstance.score) + Double(600))
        }
        else{
            player.velocityX = 1400
        }
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchLocationHUD = touch.location(in: self.hudNode)
        let touchLocationPauseMenu = touch.location(in: self.pauseMenu.pauseMenuNode)
        let touchLocationGameOver = touch.location(in: self.gameOver.gameOverNode)
        
        if self.hud.hudBackground.contains(touchLocationHUD) { // Pause
            if !gamePaused {
                self.pauseButtonPressed()
            }
        } else if self.pauseMenu.playBtn.contains(touchLocationPauseMenu) { // Play (Pause Menu)
            self.pauseMenu.tappedButton()
            self.whiteBg.removeFromParent()
            self.isPaused = false
            self.gamePaused = false
            self.hud.pauseButton.isHidden = false
            self.hud.showAll()
        } else if self.pauseMenu.menuBtn.contains(touchLocationPauseMenu) { // Menu (Pause Menu)
            self.pauseMenu.tappedButton()
            self.updateGameData()
            self.goToMenu()
        } else if self.gameOver.restartBtn.contains(touchLocationGameOver) { // Restart (GameOver)
            self.gameOver.tappedButton()
            self.restartGame()
        } else if self.gameOver.menuBtn.contains(touchLocationGameOver) { // Menu (GameOver)
            self.gameOver.tappedButton()
            self.goToMenu()
        } else { // Jump | Glide
            if self.player.jumpsLeft > 0 {
                player.jump()
            } else{
                player.isGliding = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.player.isGliding = false
    }
    
    func checkpause() -> Bool{
        if !gamePaused{
            return false
        }
        else{
            return true
        }
    }
    
    func pauseButtonPressed() {
        if !gamePaused{
            whiteBg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            whiteBg.position = CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2)
            whiteBg.alpha = 1
            whiteBg.zPosition = 5
            self.cameraNode.addChild(whiteBg)
            
            self.isPaused = true
            self.gamePaused = true
            self.hud.pauseButton.isHidden = true
            self.hud.hideAll()
            self.hud.pauseButton.tappedPauseButton()
            pauseMenu.show(at: CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2), onNode: self.cameraNode)
            self.cameraNode.addChild(pauseMenu)
            self.pauseMenu.position = CGPoint(x: self.cameraNode.calculateAccumulatedFrame().width/2, y: self.cameraNode.calculateAccumulatedFrame().height/2)
        }
    }
    
    private func goToMenu() {
        self.whiteBg.removeFromParent()
//        let menuScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
//        self.view?.presentScene(menuScene)
        self.viewController.viewWillAppear(true)

    }
    
    
    private func restartGame() {
        self.whiteBg.removeFromParent()
//        let gameScene = GameScene(fileNamed: "GameScene")!
//        gameScene.scaleMode = .aspectFill
//        
//        self.view?.presentScene(gameScene)
        let gameScene = GameScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        gameScene.viewController = self.viewController
        gameScene.fbConnection = self.fbConnection
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        self.view?.presentScene(gameScene, transition: transition)
        self.removeFromParent()
    }
    
    private func updateGameData() {
        GameData.sharedInstance.highScore = max(GameData.sharedInstance.highScore, GameData.sharedInstance.score)
        //    GameData.sharedInstance.totalCoins += GameData.sharedInstance.coins
        
        GameData.sharedInstance.save()
    }
    
    private func checkDeath() {
        if player.life <= 0 {
            if !gamePaused {
                player.die()
                player.run(SKAction.animate(with: player.puff, timePerFrame: 0.1, resize: true, restore: false), completion: {
                    // Display GameOver Overlay
                    self.gameOver.show(at: CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2), onNode: self.cameraNode, withCoins: GameData.sharedInstance.coins)
                    self.gameOver.zPosition = GameLayer.Interface
                    self.hud.hideAll()
                    self.whiteBg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    self.whiteBg.position = CGPoint(x: self.cameraNode.frame.width/2, y: self.cameraNode.frame.height/2)
                    self.whiteBg.alpha = 1
                    self.whiteBg.zPosition = GameLayer.Interface
                    self.whiteBg.removeFromParent()
                    self.cameraNode.addChild(self.whiteBg)
                    GameData.sharedInstance.extraLife = false
                    GameData.sharedInstance.save()
                    self.gamePaused = true
                })
            }
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
        let targetPosition = CGPoint(x: cameraTarget.x + (scene!.view!.bounds.width * 1.5),
                                     y: getCameraPosition().y)
        let diff = targetPosition - getCameraPosition()
        let newPosition = getCameraPosition() + diff
        
        setCameraPosition(position: CGPoint(x: newPosition.x - UIScreen.main.bounds.width / 3.5, y: size.height/2 + player.position.y/10 + 85))
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == ColliderType.Player ? contact.bodyB : contact.bodyA
        player.collided(withBody: other)
    }
}
