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
    
    // MARK: - Init
    init(withWorldNode worldNode: SKNode) {
        super.init()
        
        // Setup initial scene nodes variables
        bgNode = worldNode.childNode(withName: "Background")!
        
        background = bgNode.childNode(withName: "Block")!.copy() as! SKNode
        
        backImage = background.childNode(withName: "bg_1") as! SKSpriteNode!
        
        backWidth = background.calculateAccumulatedFrame().width.rounded()
        
        fgNode = worldNode.childNode(withName: "Foreground")!
        
        DispatchQueue.global(qos: .background).async {
            self.image = self.imageWithImage(source: UIImage(named: "full-background")!, rotatedByHue: CGFloat(arc4random()))
        }
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
    
    func createCoinNode(block: CoinBlock) {
        let coinNode = Coin(block: block, position: lastItemPosition)
        
        updateLastItem(withPosition: coinNode.position, andWidth: coinNode.coinSpecialArrow.size.width)
        
        fgNode.addChild(coinNode)
    }
    
    func createSpinningWheelNode() {
        let spinningWheel = SpinningWheel(position: lastItemPosition)
        
        updateLastItem(withPosition: spinningWheel.position, andWidth: spinningWheel.defaultWheel.size.width)
        
        fgNode.addChild(spinningWheel)
    }
    
    func createSpikeNode() {
        let spikes = Spike(position: lastItemPosition)
        
        updateLastItem(withPosition: spikes.position, andWidth: spikes.defaultSpike.size.width)
        
        fgNode.addChild(spikes)
    }
    
    func createBigBlockOneNode() {
        let platform = BlockSpawner(position: lastItemPosition)
        
        updateLastItem(withPosition: platform.position, andWidth: platform.smileAndTriggerBlock.size.width)
        
        fgNode.addChild(platform)
    }
    
    private func updateLastItem(withPosition position: CGPoint, andWidth width: CGFloat) {
        lastItemPosition.x = lastItemPosition.x + (lastItemWidth + (width/2.0))
        
        lastItemWidth = width/2.0
    }
    
    func addRandomBlockNode() {
        let coinBlock: CoinBlock!
        let random = Int.random(min: 1, max: 100)
        
        if random <= spikesPercentage {
            createSpikeNode()
        } else if random <= coinsPercentage {
            if Int.random(min: 1, max: 100) <= specialCoinPercentage {
                coinBlock = CoinBlock.SpecialArrow
            } else {
                coinBlock = CoinBlock.Arrow
            }
            createCoinNode(block: coinBlock)
        } else {
            createBigBlockOneNode()
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
        self.changeBackground()
        
        let backNode = background.copy() as! SKNode
        backNode.position = CGPoint(x: levelX, y: 0.0)
        bgNode.addChild(backNode)
        levelX += backWidth
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
}
