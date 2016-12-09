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
        
        GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundMusic)
    }
    
    // MARK: - Setup
    private func setupMenuScene() {
        let musicPrefs = GamePreferences.sharedInstance.getBackgroundMusicPrefs()
        let soundEffectPrefs = GamePreferences.sharedInstance.getSoundEffectsPrefs()
        
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
        settingsButton.size.height = 280
        settingsButton.size.width = 240
        self.addChild(settingsButton)
        
        storeButton = SKSpriteNode(imageNamed: "storeButton")
        storeButton.position = CGPoint(x: 860, y: self.size.height/2 - 400)
        storeButton.setScale(4)
        storeButton.zPosition = GameLayer.Interface
        storeButton.size.height = 280
        storeButton.size.width = 240
        self.addChild(storeButton)
        
        rankingButton = SKSpriteNode(imageNamed: "rankingsbutton")
        rankingButton.position = CGPoint(x: 580, y: self.size.height/2 - 400)
        rankingButton.setScale(4)
        rankingButton.zPosition = GameLayer.Interface
        rankingButton.size.height = 280
        rankingButton.size.width = 240
        self.addChild(rankingButton)

        if soundEffectPrefs {
            soundButton = SKSpriteNode(imageNamed: "soundButtonon")
        } else {
            soundButton = SKSpriteNode(imageNamed: "soundButtonoff")
        }
        soundButton.position = settingsButton.position
        soundButton.zPosition = GameLayer.Interface
        soundButton.setScale(4)
        soundButton.size.height = 280
        soundButton.size.width = 240
        
        if musicPrefs {
            musicButton = SKSpriteNode(imageNamed: "musicButtonon")
        } else {
            musicButton = SKSpriteNode(imageNamed: "musicButtonoff")
        }
        
        musicButton.position = settingsButton.position
        musicButton.zPosition = GameLayer.Interface
        musicButton.setScale(4)
        musicButton.size.height = 280
        musicButton.size.width = 240
        
        let playBtnScaleUp = SKAction.scale(to: 1.3, duration: 0.5)
        let playBtnScaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let playBtnAnimation = SKAction.sequence([playBtnScaleUp, playBtnScaleDown])
        
        playButton.run(SKAction.repeatForever(playBtnAnimation))
        
        pig = SKSpriteNode(imageNamed: "Idle_000")
        pig.setScale(0.4)
        pig.position = CGPoint(x: self.size.width/2 + 800, y: self.size.height/2 - 420)
        pig.zPosition = 5
        
        // Animate the pig's running movement
        pig.run(SKAction.repeatForever(SKAction.animate(with: GameTextures.sharedInstance.idleTextures, timePerFrame: 0.1, resize: true, restore: true)), withKey: "menu_idle")
        
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
        } else if self.soundButton.contains(touchLocation) {
            self.soundButtonTapped()
        } else if self.musicButton.contains(touchLocation) {
            self.musicButtonTapped()
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
            self.addChild(musicButton)
            self.addChild(soundButton)
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
            self.soundButton.run(soundMoveAction, completion: {
                self.soundButton.removeFromParent()
            })
            self.musicButton.run(musicMoveAction, completion: {
                self.musicButton.removeFromParent()
            })
        }
    }
    
    private func soundButtonTapped() {
        let currentPreference = GamePreferences.sharedInstance.getSoundEffectsPrefs()
        
        if currentPreference == true {
            GamePreferences.sharedInstance.saveSoundEffectsPrefs(false)
            self.soundButton.texture = SKTexture(imageNamed: "soundButtonoff")
        } else {
            GamePreferences.sharedInstance.saveSoundEffectsPrefs(true)
            self.soundButton.texture = SKTexture(imageNamed: "soundButtonon")
        }
    }
    
    private func musicButtonTapped() {
        let currentPreference = GamePreferences.sharedInstance.getBackgroundMusicPrefs()
        
        if currentPreference == true {
            GamePreferences.sharedInstance.saveBackgroundMusicPrefs(false)
            self.musicButton.texture = SKTexture(imageNamed: "musicButtonoff")
            GameAudio.sharedInstance.stopBackgroundMusic()
        } else {
            GamePreferences.sharedInstance.saveBackgroundMusicPrefs(true)
            self.musicButton.texture = SKTexture(imageNamed: "musicButtonon")
            GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundMusic)
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
