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
    private var soundButton = SKSpriteNode()
    private var musicButton = SKSpriteNode()
    private var coinsLabel = SKLabelNode()
    private var pig = SKSpriteNode()
    
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
        
        let background = SKSpriteNode(imageNamed: "full-background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: -100, y: 0)
        self.addChild(background)
        
        let title = SKSpriteNode(imageNamed: "menu_title")
        title.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + title.size.height*2)
        title.zPosition = 5
        self.addChild(title)
        
        playButton = SKSpriteNode(imageNamed: "play_btn")
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 30)
        playButton.zPosition = 5
        self.addChild(playButton)
        
        settingsButton = SKSpriteNode(imageNamed: "settingsButton")
        settingsButton.position = CGPoint(x: 300, y: self.size.height/2 - 400)
        settingsButton.zPosition = 5
        settingsButton.setScale(4)
        self.addChild(settingsButton)
        
        soundButton = SKSpriteNode(imageNamed: "soundButtonon")
        soundButton.position = CGPoint(x: 300, y: self.size.height/2 + 140)
        soundButton.zPosition = 5
        soundButton.setScale(3.8)
        self.addChild(soundButton)
        
        musicButton = SKSpriteNode(imageNamed: "musicButtonon")
        musicButton.position = CGPoint(x: 300, y: self.size.height/2 - 120)
        musicButton.zPosition = 5
        musicButton.setScale(3.8)
        self.addChild(musicButton)
        
        storeButton = SKSpriteNode(imageNamed: "storeButton")
        storeButton.position = CGPoint(x: 820, y: self.size.height/2 - 400)
        storeButton.setScale(4)
        storeButton.zPosition = 5
        self.addChild(storeButton)
        
//        coinsLabel.text = "\(1234) coins"
//        coinsLabel.fontName = "Comic_Andy"
//        coinsLabel.fontColor = UIColor.white
//        coinsLabel.fontSize = 120
//        coinsLabel.zPosition = 6
//        coinsLabel.position = CGPoint(x: 850, y: self.size.height/2 - 400)
//        self.addChild(coinsLabel)
        
        let playBtnScaleUp = SKAction.scale(to: 1.1, duration: 0.3)
        let playBtnScaleDown = SKAction.scale(to: 1.0, duration: 0.3)
        let playBtnAnimation = SKAction.sequence([playBtnScaleUp, playBtnScaleDown])
        
        playButton.run(SKAction.repeatForever(playBtnAnimation))
        
        pig = SKSpriteNode(imageNamed: "Run_000")
        pig.setScale(0.5)
        pig.position = CGPoint(x: self.size.width/2 + 800, y: self.size.height/2 - 390)
        pig.zPosition = 5
        
        // Animate the pig's running movement
        pig.run(SKAction.repeatForever(SKAction.animate(with: GameTextures.sharedInstance.idleTextures, timePerFrame: 0.1, resize: true, restore: true)), withKey: "menu_idle")
        
        self.addChild(pig)
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.loadGameScene()
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
}