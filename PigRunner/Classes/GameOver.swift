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
        GameAudio.sharedInstance.pauseBackgroundMusic()
        
        let whiteBg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: kViewSizeWidth, height: kViewSizeHeight))
        whiteBg.position = CGPoint(x: 0, y: 0)
        whiteBg.fillColor = UIColor.white
        whiteBg.zPosition = GameLayer.Interface-1
        
        let bloodSpatter = SKSpriteNode(imageNamed: "blood_spatter")
        bloodSpatter.size = node.calculateAccumulatedFrame().size
        bloodSpatter.setScale(0)
        bloodSpatter.position = pos
        bloodSpatter.zPosition = GameLayer.Interface-1
        
        node.addChild(bloodSpatter)
        
        let scaleX = SKAction.scaleX(to: 2.0, duration: 0.08)
        let scaleY = SKAction.scaleY(to: 3.5, duration: 0.08)
        let scaleSequence = SKAction.sequence([scaleX, scaleY])
        bloodSpatter.run(scaleSequence, completion: {
            self.gameOverNode.position = pos
            self.gameOverNode.removeFromParent()
            self.gameOverNode.zPosition = GameLayer.Interface
            self.gameOverNode.setScale(0)
            
            node.addChild(self.gameOverNode)
            
            self.gameOverNode.run(SKAction.scale(to: 1.0, duration: 0.5))
        })
    }
    
    func tappedButton() {
        self.gameOverNode.removeFromParent()
    }
}
