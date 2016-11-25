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
        self.scoreLabel = SKLabelNode(fontNamed: "comic andy")
        self.scoreLabel.fontColor = UIColor.black
        self.scoreLabel.fontSize = 180.0
    }
    
    private func setupCoinsLabel() {
        self.coinsLabel = SKLabelNode(fontNamed: "comic andy")
        self.coinsLabel.fontColor = UIColor(red: 248.0/255.0, green: 194.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        self.coinsLabel.fontSize = 180.0
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
