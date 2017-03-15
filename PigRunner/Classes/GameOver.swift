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
    var menuBtn: SKSpriteNode!
    var restartBtn: SKSpriteNode!
    var totalCoinsLbl: SKLabelNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.gameOverNode = SKNode(fileNamed: "GameOver")!.childNode(withName: "Overlay")
        self.restartBtn = self.gameOverNode.childNode(withName: "restartBtn") as! SKSpriteNode
        self.menuBtn = self.gameOverNode.childNode(withName: "menuBtn") as! SKSpriteNode
        self.totalCoinsLbl = self.gameOverNode.childNode(withName: "totalCoinsLbl") as! SKLabelNode
    }
    
    // MARK: - Methods
    func show(at pos: CGPoint, onNode node: SKNode, withCoins coins: Int) {
        GameAudio.sharedInstance.pauseBackgroundMusic()
        self.run(GameAudio.sharedInstance.soundGameOver)
        
        let whiteBg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: kViewSizeWidth, height: kViewSizeHeight))
        whiteBg.position = CGPoint(x: 0, y: 0)
        whiteBg.fillColor = UIColor.white
        whiteBg.zPosition = GameLayer.Interface-1
        GameData.sharedInstance.totalCoins += Int(coins)
        GameData.sharedInstance.save()
        
        self.totalCoinsLbl.text = String(GameData.sharedInstance.totalCoins)
        self.gameOverNode.position = pos
        self.gameOverNode.zPosition = GameLayer.Interface
        self.gameOverNode.setScale(0)
        
        node.addChild(self.gameOverNode)
        
        self.gameOverNode.run(SKAction.scale(to: 1.1, duration: 0.5))
    }
    
    func tappedButton() {
        self.gameOverNode.removeFromParent()
    }
}
