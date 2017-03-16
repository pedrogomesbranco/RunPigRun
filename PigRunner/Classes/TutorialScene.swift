//
//  TutorialScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 09/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class TutorialScene: SKNode {
    // MARK: - Properties
    var tutorialNode: SKNode!
    var gotItButton: SKSpriteNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.tutorialNode = SKNode(fileNamed: "TutorialScene")!.childNode(withName: "Overlay")
        self.gotItButton = self.tutorialNode.childNode(withName: "gotItButton") as! SKSpriteNode
        self.gotItButton.zPosition = GameLayer.Interface
    }
    
    // MARK: - Methods
    func show(at pos: CGPoint, onScene scene: SKScene) {
        GameAudio.sharedInstance.pauseBackgroundMusic()
        
        self.tutorialNode.position = pos
        self.tutorialNode.removeFromParent()
        self.tutorialNode.zPosition = GameLayer.Interface+1
        self.tutorialNode.setScale(0)
        
        scene.addChild(self.tutorialNode)
        
        self.tutorialNode.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
}
