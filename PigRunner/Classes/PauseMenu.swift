//
//  PauseMenu.swift
//  PigRunner
//
//  Created by Joao Pereira on 29/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class PauseMenu: SKNode {
    // MARK: - Properties
    var playBtn: SKSpriteNode!
    var menuBtn: SKSpriteNode!
    var skScene:  SKNode!
    var pauseMenu: SKNode!
    
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        self.skScene = SKNode(fileNamed: "PauseMenu")!
        self.pauseMenu = skScene.childNode(withName: "Block") as SKNode!
        
        self.playBtn = pauseMenu?.childNode(withName: "playBtn")! as! SKSpriteNode
        self.menuBtn = pauseMenu?.childNode(withName: "menuBtn")! as! SKSpriteNode
    }
    
    // MARK: - Methods
    func createPauseMenu(at pos: CGPoint, onNode node: SKNode) {
        
        self.pauseMenu?.position = pos
        self.pauseMenu?.zPosition = 40
        
        self.pauseMenu?.removeFromParent()
        node.addChild(self.pauseMenu!)
    }
    
    func menuTapped() {
        self.removeFromParent()
        
        let gameOverScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        GameScene.sharedInstance.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func playTapped() {
        self.removeFromParent()
    }
}
