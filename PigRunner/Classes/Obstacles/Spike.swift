//
//  Spike.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class Spike: Obstacle {
    var defaultSpike: SKSpriteNode {
        get {
            let scene = SKNode(fileNamed: "Spikes")!
            let spikes = scene.childNode(withName: "Block") as! SKSpriteNode
            
            spikes.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            return spikes
        }
    }
    
    // MARK: - Init
    convenience init(position: CGPoint) {
        self.init()
        
        defaultSpike.position = position
        defaultSpike.position.y = -490
    }
}
