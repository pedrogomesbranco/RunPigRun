//
//  MenuScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 25/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit
import FBSDKLoginKit

class MenuScene: SKScene {
    // MARK: - Properties
    private var playButton = SKSpriteNode()
    private var facebookButton = SKSpriteNode()
    private var settingsButton = SKSpriteNode()
    private var rankingButton = SKSpriteNode()
    private var helpButton = SKSpriteNode()
    private var soundButton = SKSpriteNode()
    private var musicButton = SKSpriteNode()
    private var coinsLabel = SKLabelNode()
    private var title = SKSpriteNode()
    private var isLoaded = false
    //    private var pig = SKSpriteNode()
    //    let rankingScene = RankingScene()
    let tutorialScene = TutorialScene()
    
    let background = SKSpriteNode(imageNamed: "Background 01")
    let whiteBg = SKSpriteNode(imageNamed: "whiteBg")
    //    var cameraNode = SKCameraNode()
    
    var rankingIsActive: Bool = false
    var facebookIsActive: Bool = false
    var tutorialIsActive: Bool = false
    
    private var touchSettings = false
    
    // View Controller
    var viewController : GameViewController!
    
    // Facebook Configuration
    var fbConnection : FacebookConnection!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        if(!isLoaded){
            self.setupMenuScene()
            isLoaded = true
        }
        resetActives()
        GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundMusic)
    }
    
    private func resetActives(){
        rankingIsActive = false
        facebookIsActive = false
        tutorialIsActive = false
    }
    
    // MARK: - Setup
    private func setupMenuScene() {
        let musicPrefs = GamePreferences.sharedInstance.getBackgroundMusicPrefs()
        let soundEffectPrefs = GamePreferences.sharedInstance.getSoundEffectsPrefs()
        
        self.backgroundColor = UIColor.black
        
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        self.addChild(background)
        
        title = SKSpriteNode(imageNamed: "menu_title")
        title.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + title.size.height*2)
        title.zPosition = GameLayer.Interface
        self.addChild(title)
        
        playButton = SKSpriteNode(imageNamed: "playzao")
        playButton.position = CGPoint(x: 1900, y: self.size.height/2 - 400)
        playButton.zPosition = GameLayer.Interface
        self.addChild(playButton)
        
        settingsButton = SKSpriteNode(imageNamed: "settingsButton-2")
        settingsButton.position = CGPoint(x: 270, y: self.size.height/2 - 400)
        settingsButton.zPosition = GameLayer.Interface + 1
        settingsButton.setScale(4)
        settingsButton.size.height = 280
        settingsButton.size.width = 240
        self.addChild(settingsButton)
        
        if (FBSDKAccessToken.current()) == nil {
            facebookButton = SKSpriteNode(imageNamed: "facebook")
            facebookButton.position = CGPoint(x: 550, y: self.size.height/2 - 400)
            facebookButton.setScale(4)
            facebookButton.zPosition = GameLayer.Interface
            facebookButton.size.height = 280
            facebookButton.size.width = 240
            self.addChild(facebookButton)
        }
        else{
            rankingButton = SKSpriteNode(imageNamed: "rankingsbutton-1")
            rankingButton.position = CGPoint(x: 550, y: self.size.height/2 - 400)
            rankingButton.setScale(4)
            rankingButton.zPosition = GameLayer.Interface
            rankingButton.size.height = 280
            rankingButton.size.width = 240
            self.addChild(rankingButton)
        }
        
        helpButton = SKSpriteNode(imageNamed: "help")
        helpButton.position = CGPoint(x: 830, y: self.size.height/2 - 400)
        helpButton.setScale(4)
        helpButton.zPosition = GameLayer.Interface
        helpButton.size.height = 280
        helpButton.size.width = 240
        self.addChild(helpButton)
        
        
        if soundEffectPrefs {
            soundButton.alpha = 1
        } else {
            soundButton.alpha = 0.4
        }
        soundButton = SKSpriteNode(imageNamed: "soundButtonon-1")
        soundButton.position = settingsButton.position
        soundButton.zPosition = GameLayer.Interface
        soundButton.setScale(4)
        soundButton.size.height = 280
        soundButton.size.width = 240
        
        if musicPrefs {
            musicButton.alpha = 1
        } else {
            musicButton.alpha = 0.4
        }
        
        musicButton = SKSpriteNode(imageNamed: "musicButtonon-1")
        musicButton.position = settingsButton.position
        musicButton.zPosition = GameLayer.Interface
        musicButton.setScale(4)
        musicButton.size.height = 280
        musicButton.size.width = 240
        
        let playBtnScaleUp = SKAction.scale(to: 3, duration: 0.5)
        let playBtnScaleDown = SKAction.scale(to: 3.3, duration: 0.5)
        let playBtnAnimation = SKAction.sequence([playBtnScaleUp, playBtnScaleDown])
        
        playButton.run(SKAction.repeatForever(playBtnAnimation))
        
    }
    
    //show either facebook button or ranking button
    func changeRankingButtonToFacebookButton(){
        self.rankingButton.removeFromParent()
        facebookButton = SKSpriteNode(imageNamed: "facebook")
        facebookButton.position = CGPoint(x: 550, y: self.size.height/2 - 400)
        facebookButton.setScale(4)
        facebookButton.zPosition = GameLayer.Interface
        facebookButton.size.height = 280
        facebookButton.size.width = 240
        self.addChild(facebookButton)
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchLocationInTutorial = touch.location(in: self.tutorialScene.tutorialNode)
        
        if tutorialIsActive {
            if self.tutorialScene.gotItButton.contains(touchLocationInTutorial) {
                self.tutorialScene.tutorialNode.removeFromParent()
                self.whiteBg.removeFromParent()
                self.loadGameScene()
            }
        }
            
        else{
            if (self.rankingButton.contains(touchLocation) && FBSDKAccessToken.current() != nil) {
                self.viewController.showRanking()
                self.rankingIsActive = true
            }
            else if (self.facebookButton.contains(touchLocation) && FBSDKAccessToken.current() == nil) {
                self.viewController.fbConnection.loginFromViewController(viewController: self.viewController, completion: ({
                    if(FBSDKAccessToken.current() != nil){
                        self.facebookButton.removeFromParent()
                        self.rankingButton = SKSpriteNode(imageNamed: "rankingsbutton-1")
                        self.rankingButton.position = CGPoint(x: 550, y: self.size.height/2 - 400)
                        self.rankingButton.setScale(4)
                        self.rankingButton.zPosition = GameLayer.Interface
                        self.rankingButton.size.height = 280
                        self.rankingButton.size.width = 240
                        self.addChild(self.rankingButton)
                    }
                }))
                
            } else if self.settingsButton.contains(touchLocation) {
                self.loadSettingsMenu()
            } else if self.soundButton.contains(touchLocation) {
                self.soundButtonTapped()
            } else if self.musicButton.contains(touchLocation) {
                self.musicButtonTapped()
            }
                
            else {
                self.whiteBg.removeFromParent()
                self.loadGameScene()
            }
        }
    }
    
    // MARK: - Switch scenes
    private func loadGameScene() {
        let gameScene = GameScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        gameScene.viewController = self.viewController
        gameScene.fbConnection = self.fbConnection
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    private func loadTutorialScene() {
        whiteBg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        whiteBg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        whiteBg.alpha = 0.3
        whiteBg.zPosition = GameLayer.Interface
        self.addChild(whiteBg)
        self.tutorialIsActive = true
        tutorialScene.show(at: CGPoint(x: self.size.width/2, y: self.size.height/2), onScene: self)
        tutorialScene.zPosition = GameLayer.Interface+2
    }
    
    private func loadSettingsMenu() {
        if(touchSettings == false){
            self.addChild(musicButton)
            self.addChild(soundButton)
            touchSettings = true
            let soundMoveAction = SKAction.move(to: CGPoint(x: 270, y: self.size.height/2 + 140), duration: 0.25)
            let musicMoveAction = SKAction.move(to: CGPoint(x: 270, y: self.size.height/2 - 120), duration: 0.25)
            self.soundButton.run(soundMoveAction)
            self.musicButton.run(musicMoveAction)
            
        }
        else{
            touchSettings = false
            let soundMoveAction = SKAction.move(to: CGPoint(x: 270, y: self.size.height/2 - 400), duration: 0.25)
            let musicMoveAction = SKAction.move(to: CGPoint(x: 270, y: self.size.height/2 - 400), duration: 0.25)
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
            self.soundButton.alpha = 0.4
        } else {
            GamePreferences.sharedInstance.saveSoundEffectsPrefs(true)
            self.soundButton.alpha = 1
        }
    }
    
    private func musicButtonTapped() {
        let currentPreference = GamePreferences.sharedInstance.getBackgroundMusicPrefs()
        
        if currentPreference == true {
            GamePreferences.sharedInstance.saveBackgroundMusicPrefs(false)
            self.musicButton.alpha = 0.4
            GameAudio.sharedInstance.stopBackgroundMusic()
        } else {
            GamePreferences.sharedInstance.saveBackgroundMusicPrefs(true)
            self.musicButton.alpha = 1
            GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundMusic)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
