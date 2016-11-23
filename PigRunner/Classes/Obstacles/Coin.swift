//
//  Coin.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class Coin: Obstacle {
    var coinArrow: SKSpriteNode {
        get {
            let scene = SKNode(fileNamed: "CoinArrow")!
            let coinArrow = scene.childNode(withName: "Block") as! SKSpriteNode
            
            coinArrow.setScale(0.8)
            coinArrow.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            return coinArrow
        }
    }
    
    var coinSpecialArrow: SKSpriteNode {
        get {
            let scene = SKNode(fileNamed: "CoinSpecialArrow")!
            let coinSpecialArrow = scene.childNode(withName: "Block") as! SKSpriteNode
            
            coinSpecialArrow.setScale(0.8)
            coinSpecialArrow.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            return coinSpecialArrow
        }
    }
    
    var coinSmile: SKSpriteNode {
        get {
            let scene = SKNode(fileNamed: "CoinSmile")!
            let coinSmile = scene.childNode(withName: "Block") as! SKSpriteNode
            
            coinSmile.setScale(0.8)
            coinSmile.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
            
            return coinSmile
        }
    }
    
    // MARK: - Init
    convenience init(block: CoinBlock, position: CGPoint) {
        self.init()
        
        switch block {
        case CoinBlock.Arrow:
            coinArrow.position = position
            coinArrow.position.y -= 50
        case CoinBlock.SpecialArrow:
            coinSpecialArrow.position = position
            coinSpecialArrow.position.y -= 50
        case CoinBlock.Smile:
            coinSmile.position = position
            coinSmile.position.y -= 50
        }
    }
    
    // MARK: - Methods
    func collectedCoin() {
        let shrinkAction = SKAction.scale(to: 0.0, duration: 0.05)
        
        self.run(shrinkAction, completion: {
            self.removeFromParent()
        })
    }
}
