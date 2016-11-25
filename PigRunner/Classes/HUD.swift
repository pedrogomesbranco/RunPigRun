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
    private var coinsCollected = SKSpriteNode()
    private var scoreLabel = SKLabelNode()
    private var coinsLabel = SKLabelNode()
    
    // MARK: - Public Properties
    internal let pauseButton = PauseButton()
    
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
        self.setupHUDCoins(collected: coinsCollected)
        self.setupHUDScore(score: score)
        self.setupPauseButton()
    }
    
    // MARK: - Setup Functions
    private func setupHUDBackground() {
        let hudBackgroundSize = CGSize(width: kViewSizeWidth, height: kViewSizeHeight * 0.1)
        
        self.hudBackground = SKSpriteNode(color: SKColor.clear, size: hudBackgroundSize)
        
        self.hudBackground.anchorPoint = CGPoint.zero
        self.hudBackground.position = CGPoint(x: -(kViewSizeWidth/2), y: 460)
        
        self.addChild(hudBackground)
    }
    
    private func setupHUDCoins(collected: Int) {
        // Coins Sprite
        self.coinsCollected = SKSpriteNode(imageNamed: "moedao")
        self.coinsCollected.size.height *= 2
        self.coinsCollected.size.width *= 2
        
        let coinOffsetX = self.coinsCollected.size.width - 150
        let coinOffsetY = self.hudBackground.size.height/2
        
        self.coinsCollected.position = CGPoint(x: coinOffsetX, y: coinOffsetY)
        
        // Coins Collected Label
        self.coinsLabel = GameFonts.sharedInstance.createCoinsLabel(coins: 0)
        
        let labelOffsetX = coinOffsetX + 120
        let labelOffsetY = coinOffsetY - self.coinsCollected.size.height/8
        
        self.coinsLabel.position = CGPoint(x: labelOffsetX, y: labelOffsetY)
        
        self.hudBackground.addChild(self.coinsCollected)
        self.hudBackground.addChild(self.coinsLabel)
    }
    
    private func setupHUDScore(score: Int) {
        self.scoreLabel = GameFonts.sharedInstance.createScoreLabel(score: 0)
        
        let offsetX = self.coinsCollected.position.x + self.coinsCollected.size.width/2
        let offsetY = self.coinsCollected.position.y - self.scoreLabel.frame.size.height - 80
        
        self.scoreLabel.position = CGPoint(x: offsetX, y: offsetY)
        
        self.hudBackground.addChild(self.scoreLabel)
    }
    
    private func setupPauseButton() {
        let offsetX = self.hudBackground.size.width * 0.95
        let offsetY = self.hudBackground.size.height/2 + 30
        
        self.pauseButton.position = CGPoint(x: offsetX, y: offsetY)
        
        self.hudBackground.addChild(self.pauseButton)
    }
    
    func updateCoinsCollected(_ coins: Int) {
        self.coinsLabel.text = String(coins)
        
        // Animation for label text
        let scaleUp = SKAction.scale(to: 0.3, duration: 0.12)
        let scaleNormal = SKAction.scale(to: 0.2, duration: 0.12)
        let scaleSequence = SKAction.sequence([scaleUp, scaleNormal])
        
        self.coinsCollected.run(scaleSequence)
    }
    
    func updateScore(score: Int) {
        self.scoreLabel.text = String(score)
    }
}
