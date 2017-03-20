//
//  BlocsGenerator.swift
//  PigRunner
//
//  Created by Joao Pereira on 07/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation
import SpriteKit
import CoreImage

class BlocksGenerator: SKNode {
    // MARK: - Properties
    var background: SKNode!
    var backWidth: CGFloat = 0.0
    var lastItemPosition = CGPoint.zero
    var lastItemWidth: CGFloat = 0.0
    var levelX: CGFloat = 0.0
    
    var image = UIImage()
    
    var bgNode = SKNode()
    var fgNode = SKNode()
    
    let gameScene = GameScene.sharedInstance
    
    // MARK: - Init
    init(withWorldNode worldNode: SKNode) {
        super.init()
        
        // Setup initial scene nodes variables
        self.bgNode = worldNode.childNode(withName: "Background")!
        self.background = self.bgNode.childNode(withName: "Block")!.copy() as! SKNode
        self.backWidth = self.background.calculateAccumulatedFrame().width.rounded()
        self.fgNode = worldNode.childNode(withName: "Foreground")!
        
        // Set initial value for 'lastItemPosition' to create an initial empty space
        // on the start of a level.
        self.lastItemPosition.x = self.backWidth * 0.4
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitialLevel() {
        // Fill level with random blocks (coins and obstacles)
        levelX = bgNode.childNode(withName: "Block")!.position.x + backWidth
        while lastItemPosition.x < levelX {
            addRandomBlockNode()
        }
    }
    
    func createBigBlockNode(type: BlockType) {
        let block = BlockSpawner()
        block.spawnBlock(type, at: lastItemPosition, onNode: fgNode)
        updateLastItem(width: block.nodeWidth)
    }
    
    private func updateLastItem(width: CGFloat) {
        lastItemPosition.x = lastItemPosition.x + width
        lastItemWidth = width
    }
    
    func addRandomBlockNode() {
        let random = Int.random(min: 1, max: 70)
        
        if random <= 10 {
            createBigBlockNode(type: .Ob1)
        } else if random <= 20 {
            createBigBlockNode(type: .Ob2)
        } else if random <= 30 {
            createBigBlockNode(type: .Ob3)
        } else if random <= 40 {
            createBigBlockNode(type: .Ob4)
        } else if random <= 50 {
            createBigBlockNode(type: .Ob5)
        } else if random <= 60 {
            createBigBlockNode(type: .Ob6)
        } else if random <= 70 {
            createBigBlockNode(type: .Ob7)
        }
    }
    
    func addRandomBlockNodeWithoutLife() {
        let random = Int.random(min: 1, max: 60)
        if random <= 10 {
            createBigBlockNode(type: .Ob1)
        } else if random <= 20 {
            createBigBlockNode(type: .Ob2)
        } else if random <= 30 {
            createBigBlockNode(type: .Ob3)
        } else if random <= 40 {
            createBigBlockNode(type: .Ob4)
        } else if random <= 50 {
            createBigBlockNode(type: .Ob5)
        } else if random <= 60 {
            createBigBlockNode(type: .Ob6)
        }
    }
    
    func updateLevel(withCameraPosition cameraPos: CGPoint, player: Player) {
        if cameraPos.x > levelX - 1300 {
            createBackgroundNode()
            
            while lastItemPosition.x < levelX {
                if player.getCurrentLife() < 3{
                    addRandomBlockNode()
                } else{
                    addRandomBlockNodeWithoutLife()
                }
            }
        }
    }
    
    // MARK: - Background
    func createBackgroundNode() {
        let backNode = background.copy() as! SKNode
        backNode.position = CGPoint(x: levelX, y: 0.0)
        bgNode.addChild(backNode)
        levelX += backWidth
    }
}
