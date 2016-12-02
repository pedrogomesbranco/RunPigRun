//
//  GameOver.swift
//  PigRunner
//
//  Created by Joao Pereira on 01/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class GameOver: SKNode {
    // MARK: - Properties
    var gameOverNode: SKNode!
    var continueBtn: SKSpriteNode!
    var menuBtn: SKSpriteNode!
    var restartBtn: SKSpriteNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.gameOverNode = SKNode(fileNamed: "GameOver")!.childNode(withName: "Overlay")
        
        self.restartBtn = self.gameOverNode.childNode(withName: "restartBtn") as! SKSpriteNode
        self.menuBtn = self.gameOverNode.childNode(withName: "menuBtn") as! SKSpriteNode
        self.continueBtn = self.gameOverNode.childNode(withName: "continueBtn") as! SKSpriteNode
    }
    
    // MARK: - Methods
    func show(at pos: CGPoint, onNode node: SKNode) {
        self.gameOverNode.position = pos
        self.gameOverNode.removeFromParent()
        self.gameOverNode.zPosition = GameLayer.Interface
        
        node.addChild(self.gameOverNode)
    }
    
    func tappedButton() {
        self.gameOverNode.removeFromParent()
    }
}
