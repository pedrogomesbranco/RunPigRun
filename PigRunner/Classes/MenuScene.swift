//
//  MenuScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 25/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    // MARK: - Properties
    private var playButton = SKSpriteNode()
    private var storeButton = SKSpriteNode()
    private var settingsButton = SKSpriteNode()
    private var rankingButton = SKSpriteNode()
    private var soundButton = SKSpriteNode()
    private var musicButton = SKSpriteNode()
    private var coinsLabel = SKLabelNode()
    private var pig = SKSpriteNode()
    
    let background = SKSpriteNode(imageNamed: "full-background")
    let background2 = SKSpriteNode(imageNamed: "full-background")
    var cameraNode = SKCameraNode()

    
    private var touchSettings = false
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        self.setupMenuScene()
    }
    
    // MARK: - Setup
    private func setupMenuScene() {
        self.backgroundColor = UIColor.black
        
        self.addChild(cameraNode)
        
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        self.addChild(background)
        
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background.frame.width, y: 0)
        self.addChild(background2)
        
        let title = SKSpriteNode(imageNamed: "menu_title")
        title.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + title.size.height*2)
        title.zPosition = GameLayer.Interface
        self.addChild(title)
        
        playButton = SKSpriteNode(imageNamed: "play_btn")
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 30)
        playButton.zPosition = GameLayer.Interface
        self.addChild(playButton)
        
        settingsButton = SKSpriteNode(imageNamed: "settingsButton")
        settingsButton.position = CGPoint(x: 300, y: self.size.height/2 - 400)
        settingsButton.zPosition = GameLayer.Interface + 1
        settingsButton.setScale(4)
        self.addChild(settingsButton)
        
        soundButton = SKSpriteNode(imageNamed: "soundButtonon")
        soundButton.position = settingsButton.position
        soundButton.zPosition = GameLayer.Interface
        soundButton.setScale(3.8)
        self.addChild(soundButton)
        
        musicButton = SKSpriteNode(imageNamed: "musicButtonon")
        musicButton.position = settingsButton.position
        musicButton.zPosition = GameLayer.Interface
        musicButton.setScale(3.8)
        self.addChild(musicButton)
        
        storeButton = SKSpriteNode(imageNamed: "store 2")
        storeButton.position = CGPoint(x: 860, y: self.size.height/2 - 400)
        storeButton.setScale(4)
        storeButton.zPosition = GameLayer.Interface
        self.addChild(storeButton)
        
        rankingButton = SKSpriteNode(imageNamed: "rankingsbutton")
        rankingButton.position = CGPoint(x: 580, y: self.size.height/2 - 400)
        rankingButton.setScale(4)
        rankingButton.zPosition = GameLayer.Interface
        self.addChild(rankingButton)
        
        let playBtnScaleUp = SKAction.scale(to: 1.3, duration: 0.5)
        let playBtnScaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let playBtnAnimation = SKAction.sequence([playBtnScaleUp, playBtnScaleDown])
        
        playButton.run(SKAction.repeatForever(playBtnAnimation))
        
        pig = SKSpriteNode(imageNamed: "Idle_000")
        pig.setScale(0.5)
        pig.position = CGPoint(x: self.size.width/2 + 800, y: self.size.height/2 - 375)
        pig.zPosition = 5
        
        // Animate the pig's running movement
        pig.run(SKAction.repeatForever(SKAction.animate(with: GameTextures.sharedInstance.idleTextures, timePerFrame: 0.1, resize: true, restore: true)), withKey: "menu_run")
        
        self.addChild(pig)
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        if self.storeButton.contains(touchLocation) {
            self.loadStoreScene()
        } else if self.settingsButton.contains(touchLocation) {
            self.loadSettingsMenu()
        }
        else {
            self.loadGameScene()
        }
    }
    
    // MARK: - Switch scenes
    private func loadGameScene() {
        let runAction = SKAction.moveBy(x: 1600, y: 0, duration: 0.8)
        pig.run(SKAction.repeatForever(SKAction.animate(with: GameTextures.sharedInstance.runTextures, timePerFrame: 0.1, resize: true, restore: true)), withKey: "menu_run")
        
        pig.run(runAction, completion: {
            self.run(SKAction.run {
                let gameScene = GameScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
                
                self.view?.presentScene(gameScene, transition: transition)
            })
        })
    }
    
    private func loadStoreScene() {
        let storeScene = StoreScene(fileNamed: "Store")
        storeScene?.scaleMode = .fill
        
        self.view?.presentScene(storeScene)
    }
    
    private func loadSettingsMenu() {
        if(touchSettings == false){
            touchSettings = true
            let soundMoveAction = SKAction.move(to: CGPoint(x: 300, y: self.size.height/2 + 140), duration: 0.25)
            let musicMoveAction = SKAction.move(to: CGPoint(x: 300, y: self.size.height/2 - 120), duration: 0.25)
            self.soundButton.run(soundMoveAction)
            self.musicButton.run(musicMoveAction)
            
        }
        else{
            touchSettings = false
            let soundMoveAction = SKAction.move(to: CGPoint(x: 300, y: self.size.height/2 - 400), duration: 0.25)
            let musicMoveAction = SKAction.move(to: CGPoint(x: 300, y: self.size.height/2 - 400), duration: 0.25)
            self.soundButton.run(soundMoveAction)
            self.musicButton.run(musicMoveAction)
        }
        
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        updateBackground()
//        self.pig.position.x += 10
//        self.cameraNode.position.x = self.pig.position.x
//    }
    
    func updateBackground(){
        if(self.cameraNode.position.x > background.position.x + background.size.width) {
            background.position = CGPoint(x: background2.position.x, y: background.position.y)
        }
        if(self.cameraNode.position.x > background2.position.x + background2.size.width) {
            background2.position = CGPoint(x: background.position.x, y: background2.position.y)
        }
    }
}
