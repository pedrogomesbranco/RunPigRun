//
//  StoreScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 30/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class StoreScene: SKScene {
    // MARK: - Properties
    var coinButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    var coinsLabel: SKLabelNode!
    
    // MARK: - Initialization
    override func didMove(to view: SKView) {
        self.coinButton = self.childNode(withName: "coinButton") as! SKSpriteNode
        self.menuButton = self.childNode(withName: "menuButton") as! SKSpriteNode
        self.coinsLabel = self.childNode(withName: "coinsLabel") as! SKLabelNode
        
        updateScene()
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        if coinButton.contains(touchLocation) {
            buySpecialCoinBonus()
        } else if menuButton.contains(touchLocation) {
            goToMenu()
        }
    }
    
    // MARK: - Methods
    private func goToMenu() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = .fill
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    private func updateScene() {
        self.coinsLabel.text = "\(GameData.sharedInstance.totalCoins)c"
    }
    
    private func buySpecialCoinBonus() {
        GameData.sharedInstance.totalCoins -= 50
        GameData.sharedInstance.specialCoinMultiplier = 2
        GameData.sharedInstance.save()
    }
}
