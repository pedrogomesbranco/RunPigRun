//
//  HUD.swift
//  pigrunner
//
//  Created by Joao Pereira on 13/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    // MARK: - Private Properties
    private var hudBackground: SKSpriteNode!
    private var coinsCollectedLabel = SKLabelNode()
    private var coinsCollected = SKSpriteNode()
    private var scoreLabel = SKLabelNode()
    private var coinsLabel = SKLabelNode()
    
    // MARK: - Public Properties
//    internal let pauseButton = PauseButton()
    
    // Shared Instance
    static let sharedInstance = HUD()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(lives: Int, coinsCollected: Int, score: Int) {
        self.init()
        
        self.zPosition = GameLayer.Interface
        
        self.setupHUDBackground()
        self.setupHUDCoinsCollected(collected: coinsCollected)
        self.setupHUDScore(score: score)
    }
    
    // MARK: - Setup Functions
    private func setupHUDBackground() {
        let hudBackgroundSize = CGSize(width: kViewSizeWidth, height: kViewSizeHeight * 0.1)
        
        self.hudBackground = SKSpriteNode(color: SKColor.clear, size: hudBackgroundSize)
        
        self.hudBackground.anchorPoint = CGPoint.zero
        self.hudBackground.position = CGPoint(x: -(kViewSizeWidth/2), y: 460)
        
        self.addChild(hudBackground)
    }
    
    private func setupHUDCoinsCollected(collected: Int) {
        // Coins Sprite
        self.coinsCollected = GameTextures.sharedInstance.spriteWithName(name: SpriteName.CoinsCollected)
        self.coinsCollected.setScale(0.2)
        
        let coinOffsetX = self.coinsCollected.size.width*2
        let coinOffsetY = self.hudBackground.size.height/2
        
        self.coinsCollected.position = CGPoint(x: coinOffsetX, y: coinOffsetY)
        
        // Coins Collected Label
        self.coinsLabel = GameFonts.sharedInstance.createCoinsLabel(coins: 0)
        
        
        let labelOffsetX = coinOffsetX + 100
        let labelOffsetY = coinOffsetY
        
        self.coinsLabel.position = CGPoint(x: labelOffsetX, y: labelOffsetY - self.coinsCollected.size.height/2 + 5)
        
        self.hudBackground.addChild(self.coinsCollected)
        self.hudBackground.addChild(self.coinsLabel)
    }
    
    private func setupHUDScore(score: Int) {
        self.scoreLabel = SKLabelNode(text: "\(score)")
        self.scoreLabel.fontName = "Arial"
        self.scoreLabel.fontSize = 120.0
        self.scoreLabel.fontColor = SKColor.black
        
        let offsetX = self.hudBackground.size.width * 0.7
        let offsetY = self.hudBackground.size.height/2
        
        self.scoreLabel.position = CGPoint(x: offsetX, y: offsetY)
        
        self.hudBackground.addChild(self.scoreLabel)
    }
    
    func updateCoinsCollectedWithCoins(_ coins: Int, score: Int) {
        self.coinsLabel.text = String(coins)
        
        // Animation for label text
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.12)
        let scaleNormal = SKAction.scale(to: 1.0, duration: 0.12)
        let scaleSequence = SKAction.sequence([scaleUp, scaleNormal])
        
        self.coinsCollected.run(scaleSequence)
        self.scoreLabel.run(scaleSequence)
        
        self.updateScore(score: score)
    }
    
    func updateScore(score: Int) {
        self.scoreLabel.text = "\(score)"
    }
}
