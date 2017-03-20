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
        case .Ob1:
            blockNode = SKNode(fileNamed: "Ob1")
        case .Ob2:
            blockNode = SKNode(fileNamed: "Ob2")
        case .Ob3:
            blockNode = SKNode(fileNamed: "Ob3")
        case .Ob4:
            blockNode = SKNode(fileNamed: "Ob4")
        case .Ob5:
            blockNode = SKNode(fileNamed: "Ob5")
        case .Ob6:
            blockNode = SKNode(fileNamed: "Ob6")
        case .Ob7:
            blockNode = SKNode(fileNamed: "Ob7")
        }
        
        self.nodeToSpawn = blockNode.childNode(withName: "Block") as! SKSpriteNode!
        
        self.nodeToSpawn.position = pos
        self.nodeToSpawn.position.y = groundHeight
        self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
        
        self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
        
        self.nodeToSpawn.removeFromParent()
        node.addChild(self.nodeToSpawn)
    }
}
