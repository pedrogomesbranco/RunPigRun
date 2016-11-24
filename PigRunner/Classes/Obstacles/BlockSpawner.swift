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
    func spawnBlock(at pos: CGPoint, onNode node: SKNode) {
        let scene = SKNode(fileNamed: "SmileAndTrigger")!
        self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode!
        
        self.nodeToSpawn.position = pos
        self.nodeToSpawn.position.y += 190
        self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
        
        self.nodeWidth = self.nodeToSpawn.size.width
        
        self.nodeToSpawn.removeFromParent()
        node.addChild(self.nodeToSpawn)
    }
}
