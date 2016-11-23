//
//  SpinningWheel.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class SpinningWheel: SKSpriteNode {
    var defaultWheel: SKSpriteNode {
        get {
            let spinningWheel = SKSpriteNode(fileNamed: "SpinningWheel")!
            
            spinningWheel.setScale(0.5)
            spinningWheel.physicsBody?.contactTestBitMask = ColliderTypes.Player | ColliderTypes.GarbageCollector
            
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
