//
//  SpinningWheel.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class SpinningWheel: SKSpriteNode {
    // MARK: - Properties
    var nodeWidth: CGFloat = 0.0
    var nodeToSpawn: SKSpriteNode!
    
    // MARK: - Methods
    func trigger() {
        let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI), duration: 0.04)
        let rotateAction = SKAction.repeat(rotate, count: 12)
        
        self.run(rotateAction, completion: {
            let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI), duration: 0.04)
            let rotateAction = SKAction.repeat(rotate, count: 50)
            
            self.run(rotateAction)
            self.physicsBody?.velocity.dx = -2000
        })
    }

    func spawnSpinningWheel(at pos: CGPoint, onNode node: SKNode) {
        let scene = SKNode(fileNamed: "SpinningWheel")!
        self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode!
        
        self.nodeToSpawn.position = pos
        self.nodeToSpawn.position.y = -460.0
        self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
        
        self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
        
        self.nodeToSpawn.removeFromParent()
        node.addChild(self.nodeToSpawn)
    }
}
