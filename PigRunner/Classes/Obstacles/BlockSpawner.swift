//
//  BlockSpawner.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class BlockSpawner: Obstacle {
    var smileAndTriggerBlock: SKSpriteNode {
        get {
            let scene = SKNode(fileNamed: "SmileAndTrigger")!
            let node = scene.childNode(withName: "Block") as! SKSpriteNode
            
            node.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            return node
        }
    }
    
    // MARK: - Init
    convenience init(position: CGPoint) {
        self.init()
        
        smileAndTriggerBlock.position = position
        smileAndTriggerBlock.position.y += 190
    }
}
