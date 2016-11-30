//
//  StoreScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 30/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class StoreScene: SKScene {
    var coinButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.coinButton = self.childNode(withName: "coinButton") as! SKSpriteNode
        self.menuButton = self.childNode(withName: "menuButton") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        if coinButton.contains(touchLocation) {
            coinBonus = 100
        } else if menuButton.contains(touchLocation) {
            goToMenu()
        }
    }
    
    private func goToMenu() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = .fill
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        self.view?.presentScene(menuScene, transition: transition)
    }
}
