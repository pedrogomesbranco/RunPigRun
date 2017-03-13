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
    var rollerTextures: [SKTexture]!
    
    // MARK: - Methods
//    func trigger() {
//        let move = SKAction.moveBy(x: 100, y: 0, duration: 0.5)
//        let moveAction = SKAction.repeat(move, count: 2)
//        rollerTextures = GameTextures.sharedInstance.roller
//
//        self.run(moveAction, completion: {
//             self.changeAnimation(newTextures: self.rollerTextures, timePerFrame: 0.15, withKey: "jump", restore: false, repeatCount: nil)
//        })
//    }

    func spawnSpinningWheel(at pos: CGPoint, onNode node: SKNode) {
        let scene = SKNode(fileNamed: "Ob5")!
        self.nodeToSpawn = scene.childNode(withName: "Block") as! SKSpriteNode!
        
        self.nodeToSpawn.position = pos
        self.nodeToSpawn.position.y = -460.0
        self.nodeToSpawn.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.GarbageCollector
        
        self.nodeWidth = self.nodeToSpawn.calculateAccumulatedFrame().width
        
        self.nodeToSpawn.removeFromParent()
        node.addChild(self.nodeToSpawn)
    }
    
    func changeAnimation(newTextures: [SKTexture], timePerFrame: TimeInterval, withKey key: String, restore: Bool, repeatCount: Int?) {
        
        if restore {
            self.run(SKAction.repeat(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: true), count: repeatCount!))
        } else {
            self.run(SKAction.repeatForever(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: false)), withKey: key)
        }
    }
}
