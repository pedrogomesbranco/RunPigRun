//
//  BlockSpawner.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class BlockSpawner: SKSpriteNode {
    // MARK: - Properties
    var nodeWidth: CGFloat = 0.0
    var nodeToSpawn: SKSpriteNode!
    
    // MARK: - Methods
    func spawnBlock(_ type: BlockType, at pos: CGPoint, onNode node: SKNode) {
        var blockNode: SKNode!
        
        switch type {
        case .SmileAndTrigger:
            blockNode = SKNode(fileNamed: "SmileAndTrigger")
        case .SpikesAndCoins:
            blockNode = SKNode(fileNamed: "SpikesAndCoins")
        case .TwoTriggers:
            blockNode = SKNode(fileNamed: "TwoTriggers")
        }
        
        self.nodeToSpawn = blockNode.childNode(withName: "Block") as! SKSpriteNode!
        
        self.nodeToSpawn.position = pos
        print(groundHeight)
        self.nodeToSpawn.position.y = groundHeight
        self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
        
        self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
        
        self.nodeToSpawn.removeFromParent()
        node.addChild(self.nodeToSpawn)
    }
}
