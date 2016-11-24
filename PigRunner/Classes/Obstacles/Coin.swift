//
//  Coin.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    // MARK: - Properties
    var nodeWidth: CGFloat = 0.0
    var nodeToSpawn: SKSpriteNode!
    
    // MARK: - Methods
    func collectedCoin() {
        let shrinkAction = SKAction.scale(to: 0.0, duration: 0.05)
        
        self.run(shrinkAction, completion: {
            self.removeFromParent()
        })
    }
    
    func spawnCoin(block: CoinBlock, at pos: CGPoint, onNode node: SKNode) {
        switch block {
        case .Arrow:
            let scene = SKNode(fileNamed: "CoinArrow")!
            self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode!
            
            self.nodeToSpawn.position = pos
            self.nodeToSpawn.position.y -= 50
            self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
            
            self.nodeToSpawn.removeFromParent()
            node.addChild(self.nodeToSpawn)
        case .SpecialArrow:
            let scene = SKNode(fileNamed: "CoinSpecialArrow")!
            self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode!
            
            self.nodeToSpawn.position = pos
            self.nodeToSpawn.position.y -= 50
            self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
            
            self.nodeToSpawn.removeFromParent()
            node.addChild(self.nodeToSpawn)
        case .Smile:
            let scene = SKNode(fileNamed: "CoinSmile")!
            self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode
            
            self.nodeToSpawn.position = pos
            self.nodeToSpawn.position.y -= 50
            self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
            
            self.nodeToSpawn.removeFromParent()
            node.addChild(self.nodeToSpawn)
        }
    }
}
