//
//  GameFonts.swift
//  pigrunner
//
//  Created by Joao Pereira on 17/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class GameFonts {
    static let GameFontsSharedInstance = GameFonts()
    
    class var sharedInstance: GameFonts {
        return GameFontsSharedInstance
    }
    
    // MARK: - Private properties
    private var scoreLabel = SKLabelNode()
    private var coinsLabel = SKLabelNode()
    
    // MARK: - Init
    init() {
        self.setupScoreLabel()
        self.setupCoinsLabel()
    }
    
    // MARK: - Setup
    private func setupScoreLabel() {
        self.scoreLabel = SKLabelNode(fontNamed: "BIG CAR Short Gun")
        self.scoreLabel.fontColor = UIColor.black
        self.scoreLabel.fontSize = 105.0
    }
    
    private func setupCoinsLabel() {
        self.coinsLabel = SKLabelNode(fontNamed: "BIG CAR Short Gun")
        self.coinsLabel.fontColor = UIColor.yellow
        self.coinsLabel.fontSize = 105.0
    }
    
    // MARK: - Public Functions
    func createScoreLabel(score: Int) -> SKLabelNode {
        self.scoreLabel.text = String(score)
        
        return self.scoreLabel.copy() as! SKLabelNode
    }
    
    func createCoinsLabel(coins: Int) -> SKLabelNode {
        self.coinsLabel.text = String(coins)
        
        return self.coinsLabel.copy() as! SKLabelNode
    }
}
