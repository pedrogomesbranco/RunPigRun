//
//  BlocsGenerator.swift
//  PigRunner
//
//  Created by Joao Pereira on 07/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation
import SpriteKit

class BlocksGenerator: SKNode {
    // MARK: - Properties
    var background: SKNode!
    //var backImage: SKSpriteNode!
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
        
        //self.backImage = self.background.childNode(withName: "bg_1") as! SKSpriteNode!
        
        self.backWidth = self.background.calculateAccumulatedFrame().width.rounded()
        
        self.fgNode = worldNode.childNode(withName: "Foreground")!
        
//        self.image = self.imageWithImage(source: UIImage(named: "full-background")!, rotatedByHue: CGFloat(arc4random()))
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
        
        lastItemWidth = width/2
    }
    
    func addRandomBlockNode() {
        let random = Int.random(min: 1, max: 100)
        
        if random <= 33 {
            createBigBlockNode(type: .SmileAndTrigger)
        } else if random <= 66 {
            createBigBlockNode(type: .SpikesAndCoins)
        } else {
            createBigBlockNode(type: .TwoTriggers)
        }
    }
    
    func updateLevel(withCameraPosition cameraPos: CGPoint) {
        if cameraPos.x > levelX - 1300 {
            createBackgroundNode()
            
            while lastItemPosition.x < levelX {
                addRandomBlockNode()
            }
        }
    }
    
    // MARK: - Background
    func createBackgroundNode() {
//        DispatchQueue.main.async {
//            self.changeBackground()
//        }
        
        let backNode = background.copy() as! SKNode
        backNode.position = CGPoint(x: levelX, y: 0.0)
        bgNode.addChild(backNode)
        levelX += backWidth
    }
 
//    func changeBackground(){
//        DispatchQueue.global(qos: .background).async {
//            self.backImage.texture = SKTexture(image: self.image)
//        }
//    }
    
//    func imageWithImage(source: UIImage, rotatedByHue: CGFloat) -> UIImage {
//        let sourceCore = CIImage(cgImage: source.cgImage!)
//        let hueAdjust = CIFilter(name: "CIHueAdjust")
//        
//        hueAdjust?.setDefaults()
//        hueAdjust?.setValue(sourceCore, forKey: "inputImage")
//        hueAdjust?.setValue(CGFloat(rotatedByHue), forKey: "inputAngle")
//        
//        let resultCore = hueAdjust?.value(forKey: "outputImage") as! CIImage!
//        let context = CIContext(options: nil)
//        let resultRef = context.createCGImage(resultCore!, from: resultCore!.extent)
//        let result = UIImage(cgImage: resultRef!)
//        
//        return result
//    }
}
