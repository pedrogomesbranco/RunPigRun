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
    var pauseMenu: SKNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        self.playBtn = self.childNode(withName: "playBtn")! as! SKSpriteNode
        self.menuBtn = self.childNode(withName: "menuBtn")! as! SKSpriteNode
        
//        self.position = CGPoint(x: self.cameraNode.frame.size.width/2, y: self.cameraNode.frame.size.height/2)
        self.zPosition = GameLayer.Interface
        
        self.removeFromParent()
    }
    
    // MARK: - Methods
    //    func createPauseMenu(at pos: CGPoint, onNode node: SKNode) {
    //        self.pauseMenu?.position = pos
    //        self.pauseMenu?.zPosition = GameLayer.Interface
    //
    //        self.pauseMenu?.removeFromParent()
    //        node.addChild(self.pauseMenu!)
    //    }
    
    func menuTapped() {
        self.removeFromParent()
        
        let gameOverScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
        
        GameScene.sharedInstance.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func playTapped() {
        self.removeFromParent()
        
        GameScene.sharedInstance.isPaused = false
    }
}
