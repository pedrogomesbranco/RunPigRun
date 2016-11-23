//
//  SpinningWheel.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class SpinningWheel: Obstacle {
    var defaultWheel: SKSpriteNode {
        get {
            let scene = SKNode(fileNamed: "SpinningWheel")!
            let spinningWheel = scene.childNode(withName: "Block") as! SKSpriteNode
            
            spinningWheel.setScale(0.5)
            spinningWheel.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            return spinningWheel
        }
    }
    
    // MARK: - Init
    convenience init(position: CGPoint) {
        self.init()
        
        defaultWheel.position = position
        defaultWheel.position.y = -460.0
    }
    
    // MARK: - Methods
    func trigger() {
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.04)
        let rotateAction = SKAction.repeat(rotate, count: 12)
        
        self.run(rotateAction, completion: {
            let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.04)
            let rotateAction = SKAction.repeat(rotate, count: 20)
            
            self.run(rotateAction)
            self.physicsBody?.velocity.dx = -1200
        })
    }
}
