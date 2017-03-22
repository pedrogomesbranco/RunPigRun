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
  private var lifesLabel: SKLabelNode!
  private var lifeNode = SKSpriteNode()

  
  // MARK: - Public Properties
  internal let pauseButton = PauseButton()
  
  // MARK: - Init
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init() {
    super.init()
  }
  
  convenience init(coinsCollected: Int, score: Int, lifes: Int) {
    self.init()
    
    self.zPosition = 3
    
    self.setupHUDBackground()
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
  
  private func setupHUDScore(score: Int) {
    self.scoreLabel = GameFonts.sharedInstance.createScoreLabel(score: 0)
    
    let offsetX = self.hudBackground.size.width/2
    let offsetY = self.hudBackground.size.height/2 - 60
    
    self.scoreLabel.position = CGPoint(x: offsetX, y: offsetY)
    
    self.hudBackground.addChild(self.scoreLabel)
  }
  
  private func setupCurrentLife(lifes: Int) {
    let xPosition = self.coinsCollected.position.x + self.currentLife.size.width/10 - 60
    let yPosition = self.coinsCollected.position.y - 20
    self.lifeNode = SKSpriteNode(imageNamed: "Apple 03")
    self.lifeNode.anchorPoint = .zero
    self.lifeNode.setScale(0.25)
    self.lifeNode.zPosition = GameLayer.Interface
    
    self.lifesLabel = SKLabelNode(fontNamed: "Space Comics")
    self.lifesLabel.fontSize = 52
    self.lifesLabel.text = "X\(lifes)"
    self.lifesLabel.position = CGPoint(x: lifeNode.position.x+lifeNode.frame.width - 100, y: lifeNode.position.y + 20)
    self.lifesLabel.zPosition = GameLayer.Interface
    
    self.lifeNode.position = CGPoint(x: xPosition, y: yPosition)
    self.hudBackground.addChild(lifeNode)
    self.hudBackground.addChild(lifesLabel)
  }
  
  private func currentLife(lifes: Int) {
    if lifes < 0 {
      return
    }
    
    lifesLabel.text = "X\(lifes)"
  }
  
  private func setupPauseButton() {
    let offsetX = self.hudBackground.size.width * 0.98
    let offsetY = self.hudBackground.size.height/2 + 55
    
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
    self.pauseButton.isHidden = true
//    self.lifesLabel.isHidden = true
    self.lifeNode.isHidden = true
  }
  
  func showAll() {
    self.scoreLabel.isHidden = false
    self.coinsCollected.isHidden = false
    self.coinsLabel.isHidden = false
    self.pauseButton.isHidden = false
    self.lifesLabel.isHidden = false
    self.lifeNode.isHidden = false
  }
  
  func updateScore(score: Int) {
    self.scoreLabel.text = String(score)
  }
  
  func updateLife(life: Int) {
    self.currentLife(lifes: life)
  }
}
