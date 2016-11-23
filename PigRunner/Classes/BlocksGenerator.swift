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
    var backImage: SKSpriteNode!
    var backWidth: CGFloat = 0.0
    var lastItemPosition = CGPoint.zero
    var lastItemWidth: CGFloat = 0.0
    var levelX: CGFloat = 0.0
    
    var image = UIImage()
    
    var bgNode = SKNode()
    var fgNode = SKNode()
    
    let gameScene = GameScene.sharedInstance
    
    // MARK: Block Scenes
    var spikesTwo: SKSpriteNode!
    var coinArrow: SKSpriteNode!
    var coinSpecialArrow: SKSpriteNode!
    var spinningWheel: SKSpriteNode!
    var bigBlockOne: SKSpriteNode!
    
    init(withWorldNode worldNode: SKNode) {
        super.init()
        
        // Setup initial scene nodes variables
        bgNode = worldNode.childNode(withName: "Background")!
        
        background = bgNode.childNode(withName: "Block")!.copy() as! SKNode
        
        backImage = background.childNode(withName: "bg_1") as! SKSpriteNode!
        
        backWidth = background.calculateAccumulatedFrame().width.rounded()-1
        
        fgNode = worldNode.childNode(withName: "Foreground")!

        DispatchQueue.global(qos: .background).async {
            self.image = self.imageWithImage(source: UIImage(named: "full-background")!, rotatedByHue: CGFloat(arc4random()))
        }
        
        // Load Obstacle's scene files
        loadObstacles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeBackground(){
        backImage.texture = SKTexture(image: image)
    }
    
    func imageWithImage(source: UIImage, rotatedByHue: CGFloat) -> UIImage {
        let sourceCore = CIImage(cgImage: source.cgImage!)
        let hueAdjust = CIFilter(name: "CIHueAdjust")
        hueAdjust?.setDefaults()
        hueAdjust?.setValue(sourceCore, forKey: "inputImage")
        hueAdjust?.setValue(CGFloat(rotatedByHue), forKey: "inputAngle")
        let resultCore = hueAdjust?.value(forKey: "outputImage") as! CIImage!
        let context = CIContext(options: nil)
        let resultRef = context.createCGImage(resultCore!, from: resultCore!.extent)
        let result = UIImage(cgImage: resultRef!)
        return result
    }
    
    
    func setupInitialLevel() {
        // Fill level with random blocks (coins and obstacles)
        levelX = bgNode.childNode(withName: "Block")!.position.x + backWidth
        while lastItemPosition.x < levelX {
            addRandomBlockNode()
        }
    }
    
    func loadBlockNode(fileName: String) -> SKSpriteNode {
        let blockScene = SKScene.init(fileNamed: fileName)!
        let contentTemplateNode = blockScene.childNode(withName: "Block")
        
        return contentTemplateNode as! SKSpriteNode
    }
    
    func loadObstacles() {
        spikesTwo = loadBlockNode(fileName: "Spikes_Two")
        coinArrow = loadBlockNode(fileName: "CoinArrow")
        coinSpecialArrow = loadBlockNode(fileName: "CoinSpecialArrow")
        spinningWheel = loadBlockNode(fileName: "SpinningWheel")
        bigBlockOne = loadBlockNode(fileName: "BigBlockOne")
    }
    
    func createCoinNode(_ nodeType: SKSpriteNode, flipX: Bool) {
        let platform = nodeType.copy() as! SKSpriteNode
        
        lastItemPosition.x = lastItemPosition.x +
            (lastItemWidth + (platform.size.width / 2.0))
        
        lastItemWidth = platform.size.width / 2.0
        platform.position = lastItemPosition
        platform.position.y -= 50
        platform.setScale(0.8)
        
        platform.physicsBody?.contactTestBitMask = ColliderTypes.Player | ColliderTypes.GarbageCollector
        
        if flipX == true {
            platform.xScale = -1.0
        }
        
        fgNode.addChild(platform)
    }
    
    func createSpikeNode(_ nodeType: SKSpriteNode, flipX: Bool) {
        let platform = nodeType.copy() as! SKSpriteNode
        
        lastItemPosition.x = lastItemPosition.x +
            (lastItemWidth + (platform.size.width / 2.0))
        
        lastItemWidth = platform.size.width / 2.0
        platform.position = lastItemPosition
        platform.position.y = -490.0
        
        platform.physicsBody?.contactTestBitMask = ColliderTypes.Player | ColliderTypes.GarbageCollector
        
        if flipX == true {
            platform.xScale = -1.6
        }
        
        fgNode.addChild(platform)
    }
    
    func createSpinningWheelNode(_ nodeType: SKSpriteNode, flipX: Bool) {
        let platform = SpinningWheel(position: lastItemPosition)
        
        fgNode.addChild(platform)
    }
    
    func createBigBlockOneNode(_ nodeType: SKSpriteNode, flipX: Bool) {
        let platform = nodeType.copy() as! SKSpriteNode
        
        lastItemPosition.x = lastItemPosition.x +
            (lastItemWidth + (platform.size.width / 2.0))
        
        lastItemWidth = platform.size.width / 2.0
        platform.position = lastItemPosition
        platform.position.y += 190
        
        platform.physicsBody?.contactTestBitMask = ColliderTypes.Player | ColliderTypes.GarbageCollector
        
        if flipX == true {
            platform.xScale = -1.6
        }
        
        fgNode.addChild(platform)
    }
    
    private func updateLastItem(withPosition position: CGPoint, andWidth width: CGFloat) {
        lastItemPosition.x = lastItemPosition.x + (lastItemWidth + (width/2.0))
        
        lastItemWidth = width/2.0
    }
    
    func addRandomBlockNode() {
        let blockSprite: SKSpriteNode!
        let random = Int.random(min: 1, max: 100)
        if random <= spikesPercentage {
            blockSprite = spikesTwo
            createSpikeNode(blockSprite, flipX: false)
        } else if random <= coinsPercentage {
            if Int.random(min: 1, max: 100) <= specialCoinPercentage {
                blockSprite = coinSpecialArrow
            } else {
                blockSprite = coinArrow
            }
            createCoinNode(blockSprite, flipX: false)
        } else {
            createBigBlockOneNode(bigBlockOne, flipX: false)
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
    
    // Background
    
    func createBackgroundNode() {
            DispatchQueue.main.async {
                self.changeBackground()
            }
        let backNode = background.copy() as! SKNode
        backNode.position = CGPoint(x: levelX, y: 0.0)
        bgNode.addChild(backNode)
        levelX += backWidth
    }
}
