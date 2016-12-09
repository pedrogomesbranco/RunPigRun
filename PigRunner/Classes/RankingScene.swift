//
//  RankingScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 09/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class RankingScene: SKNode {
    // MARK: - Properties
    var rankingNode: SKNode!
    
    var menuButton: SKSpriteNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.rankingNode = SKNode(fileNamed: "RankingScene")!.childNode(withName: "Overlay")
        self.menuButton = self.rankingNode.childNode(withName: "menuButton") as! SKSpriteNode
        
        self.menuButton.zPosition = GameLayer.Interface
    }
    
    // MARK: - Methods
    func show(at pos: CGPoint, onScene scene: SKScene) {
        GameAudio.sharedInstance.pauseBackgroundMusic()
        
        self.rankingNode.position = pos
        self.rankingNode.removeFromParent()
        self.rankingNode.zPosition = GameLayer.Interface+1
        self.rankingNode.setScale(0)
        
        scene.addChild(self.rankingNode)
        
        self.rankingNode.run(SKAction.scale(to: 1.1, duration: 0.25))
    }
    
    // MARK: - Methods
    func goToMenu() {
        self.removeFromParent()
    }
}
