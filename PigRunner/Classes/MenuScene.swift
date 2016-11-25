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
        background.position = CGPoint.zero
        self.addChild(background)
        
        let title = SKSpriteNode(imageNamed: "menu_title")
        title.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + title.size.height*2)
        title.zPosition = 5
        self.addChild(title)
        
        playButton = SKSpriteNode(imageNamed: "play_btn")
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        playButton.zPosition = 5
        self.addChild(playButton)
        
        let playBtnScaleUp = SKAction.scale(to: 1.1, duration: 0.3)
        let playBtnScaleDown = SKAction.scale(to: 1.0, duration: 0.3)
        let playBtnAnimation = SKAction.sequence([playBtnScaleUp, playBtnScaleDown])
        
        playButton.run(SKAction.repeatForever(playBtnAnimation))
        
        pig = SKSpriteNode(imageNamed: "Run_000")
        pig.setScale(0.3)
        pig.position = CGPoint(x: self.size.width/2 - 600, y: self.size.height/2 - 450)
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
