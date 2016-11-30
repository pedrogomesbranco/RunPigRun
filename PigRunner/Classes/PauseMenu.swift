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
    var pauseMenuNode: SKNode!
    var playBtn: SKSpriteNode!
    var menuBtn: SKSpriteNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - Methods
    func setupPauseMenu(fileNamed filename: String) {
        self.pauseMenuNode = SKNode(fileNamed: filename)
        
        self.playBtn = self.pauseMenuNode.childNode(withName: "playBtn") as! SKSpriteNode
        self.menuBtn = self.pauseMenuNode.childNode(withName: "menuBtn") as! SKSpriteNode
        
        self.addChild(self.pauseMenuNode)
    }
    
    func menuTapped() {
        self.pauseMenuNode.removeFromParent()
        
        let gameOverScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        GameScene.sharedInstance.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func playTapped() {
        self.pauseMenuNode.removeFromParent()
    }
}
