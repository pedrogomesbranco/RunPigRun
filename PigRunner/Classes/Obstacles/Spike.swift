//
//  Spike.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class Spike: SKSpriteNode {
    // MARK: - Properties
    var nodeWidth: CGFloat = 0.0
    var nodeToSpawn: SKSpriteNode!
    
    // MARK: - Methods
    func spawnSpike(at pos: CGPoint, onNode node: SKNode) {
        let scene = SKNode(fileNamed: "Spikes")!
        self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode!
        
        self.nodeToSpawn.position = pos
        self.nodeToSpawn.position.y = -500
        self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
        
        self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
        
        self.nodeToSpawn.removeFromParent()
        node.addChild(self.nodeToSpawn)
    }
}
