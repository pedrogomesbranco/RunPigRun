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
    internal var hudBackground: SKSpriteNode!
    private var coinsCollected = SKSpriteNode()
    private var currentLife = SKSpriteNode()
    private var scoreLabel = SKLabelNode()
    private var coinsLabel = SKLabelNode()
    private var lastLifeX: CGFloat = 0.0
    private var lifesNodes = [SKSpriteNode(imageNamed: "life"),SKSpriteNode(imageNamed: "life"),SKSpriteNode(imageNamed: "life"), SKSpriteNode(imageNamed: "life")]
    
    // MARK: - Public Properties
    internal let pauseButton = PauseButton()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(lives: Int, coinsCollected: Int, score: Int, lifes: Int) {
        self.init()
        
        self.zPosition = GameLayer.Interface
        
        self.setupHUDBackground()
        self.setupHUDCoins(collected: coinsCollected)
        self.setupHUDScore(score: score)
        self.setupPauseButton()
        self.setupCurrentLife(lifes: lifes)
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
        self.coinsCollected.size.height *= 2.2
        self.coinsCollected.size.width *= 2.2
        
        let coinOffsetX = self.coinsCollected.size.width - 350
        let coinOffsetY = self.hudBackground.size.height/2 - 15
        
        self.coinsCollected.position = CGPoint(x: coinOffsetX, y: coinOffsetY)
        
        // Coins Collected Label
        self.coinsLabel = GameFonts.sharedInstance.createCoinsLabel(coins: 0)
        
        let labelOffsetX = coinOffsetX + 80
        let labelOffsetY = coinOffsetY - 35
        
        self.coinsLabel.position = CGPoint(x: labelOffsetX, y: labelOffsetY)
        self.coinsLabel.horizontalAlignmentMode = .left
        
        self.hudBackground.addChild(self.coinsCollected)
        self.hudBackground.addChild(self.coinsLabel)
    }
    
    private func setupHUDScore(score: Int) {
        self.scoreLabel = GameFonts.sharedInstance.createScoreLabel(score: 0)
        
        let offsetX = self.hudBackground.size.width/2
        let offsetY = self.hudBackground.size.height/2 - 80
        
        self.scoreLabel.position = CGPoint(x: offsetX, y: offsetY)
        
        self.hudBackground.addChild(self.scoreLabel)
    }
    
    private func setupCurrentLife(lifes: Int){
        lastLifeX = 0
        
        for j in 0..<lifes {
            let offsetX = self.coinsCollected.position.x + self.currentLife.size.width/8 + lastLifeX
            let offsetY = self.coinsCollected.position.y - 115
            self.lastLifeX = offsetX
            lifesNodes[j].position = CGPoint(x: offsetX, y: offsetY)
            self.hudBackground.addChild(lifesNodes[j])
        }
    }
    
    private func currentLife(lifes: Int) {
        if lifes < 0 {
            return
        }
        
        for lifeNode in lifesNodes {
            lifeNode.removeFromParent()
        }
        
        lastLifeX = 0
        
        if lifes > 0 {
            for j in 0..<lifes {
                self.enumerateChildNodes(withName: "lifeNode", using: { (node, _) in
                    node.removeFromParent()
                })
                
                let offsetX = self.coinsCollected.position.x + self.currentLife.size.width/8 + lastLifeX
                let offsetY = self.coinsCollected.position.y - 115
                self.lastLifeX = offsetX
                lifesNodes[j].position = CGPoint(x: offsetX, y: offsetY)
                self.hudBackground.addChild(lifesNodes[j])
            }
        }
    }
    
    private func setupPauseButton() {
        let offsetX = self.hudBackground.size.width * 0.98
        let offsetY = self.hudBackground.size.height/2 + 40
        
        self.pauseButton.position = CGPoint(x: offsetX, y: offsetY)
        self.pauseButton.setScale(4)
        
        self.hudBackground.addChild(self.pauseButton)
    }
    
    func updateCoinsCollected(_ coins: Int) {
        self.coinsLabel.text = String(coins)
        
        // Animation for label text
        let scaleUp = SKAction.scale(to: 0.3, duration: 0.05)
        let scaleNormal = SKAction.scale(to: 0.2, duration: 0.05)
        let scaleSequence = SKAction.sequence([scaleUp, scaleNormal])
        
        self.coinsCollected.run(scaleSequence)
    }
    
    func hideAll() {
        self.scoreLabel.isHidden = true
        self.coinsCollected.isHidden = true
        self.coinsLabel.isHidden = true
    }
    
    func showAll() {
        self.scoreLabel.isHidden = false
        self.coinsCollected.isHidden = false
        self.coinsLabel.isHidden = false
    }
    
    func updateScore(score: Int) {
        self.scoreLabel.text = String(score)
    }
    
    func updateLife(life: Int) {
        self.currentLife(lifes: life)
    }
}
