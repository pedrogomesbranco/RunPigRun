////
////  StoreScene.swift
////  PigRunner
////
////  Created by Joao Pereira on 30/11/16.
////  Copyright © 2016 João Pereira. All rights reserved.
////
//
//import SpriteKit
//
//class StoreScene: SKNode {
//    // MARK: - Properties
//    var storeNode: SKNode!
//    
//    var coinButton: SKSpriteNode!
//    var starButton: SKSpriteNode!
//    var lifeButton: SKSpriteNode!
//    var menuButton: SKSpriteNode!
//    var coinsLabel: SKLabelNode!
//    
//    var extraLifeData: Bool = false
//    var specialCoin: Bool = false
//    var starTime: Bool = false
//    
//    // MARK: - Init
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init() {
//        super.init()
//        
//        self.storeNode = SKNode(fileNamed: "StoreScene")!.childNode(withName: "Overlay")
//        
//        self.coinButton = self.storeNode.childNode(withName: "coinButton") as! SKSpriteNode
//        self.starButton = self.storeNode.childNode(withName: "starButton") as! SKSpriteNode
//        self.lifeButton = self.storeNode.childNode(withName: "lifeButton") as! SKSpriteNode
//        self.menuButton = self.storeNode.childNode(withName: "menuButton") as! SKSpriteNode
//        self.coinsLabel = self.storeNode.childNode(withName: "coinsLabel") as! SKLabelNode
//        
//        self.coinButton.zPosition = GameLayer.Interface
//        self.menuButton.zPosition = GameLayer.Interface
//        self.coinsLabel.zPosition = GameLayer.Interface
//        
//        self.extraLifeData = GameData.sharedInstance.extraLife
//        
//        if GameData.sharedInstance.starExtraTime != 0 {
//            self.starTime = true
//        } else {
//            self.starTime = false
//        }
//        
//        if GameData.sharedInstance.specialCoinMultiplier != 1 {
//            self.specialCoin = true
//        } else {
//            self.specialCoin = false
//        }
//        
//        updateScene()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let touchLocation = touch.location(in: self)
//        
//        if coinButton.contains(touchLocation) {
//            buySpecialCoinBonus()
//        } else if lifeButton.contains(touchLocation) {
//            buyExtraLife()
//        } else if starButton.contains(touchLocation) {
//            buyExtraStarTime()
//        } else if menuButton.contains(touchLocation) {
//            goToMenu()
//        }
//    }
//    
//    // MARK: - Methods
//    func show(at pos: CGPoint, onScene scene: SKScene) {
//        GameAudio.sharedInstance.pauseBackgroundMusic()
//        
//        self.storeNode.position = pos
//        self.storeNode.removeFromParent()
//        self.storeNode.zPosition = GameLayer.Interface
//        
//        scene.addChild(self.storeNode)
//    }
//    
//    // MARK: - Methods
//    func goToMenu() {
//        self.removeFromParent()
//    }
//    
//    private func updateScene() {
//        self.coinsLabel.text = "\(GameData.sharedInstance.totalCoins)c"
//        
//        self.extraLifeData = GameData.sharedInstance.extraLife
//        
//        if extraLifeData {
//            self.lifeButton.alpha = 0.5
//        } else {
//            self.lifeButton.alpha = 1.0
//        }
//        
//        if specialCoin {
//            self.coinButton.alpha = 0.5
//        } else {
//            self.coinButton.alpha = 1.0
//        }
//        
//        if starTime {
//            self.starButton.alpha = 0.5
//        } else {
//            self.starButton.alpha = 1.0
//        }
//    }
//    
//    func buySpecialCoinBonus() {
//        if (!specialCoin && GameData.sharedInstance.totalCoins >= 600) {
//            GameData.sharedInstance.totalCoins -= 600
//            GameData.sharedInstance.specialCoinMultiplier = 2
//            GameData.sharedInstance.save()
//            
//            self.run(GameAudio.sharedInstance.soundPurchase)
//            
//            self.updateScene()
//        }
//    }
//    
//    func buyExtraLife() {
//        if (!extraLifeData && GameData.sharedInstance.totalCoins >= 100) {
//            GameData.sharedInstance.totalCoins -= 100
//            GameData.sharedInstance.extraLife = true
//            GameData.sharedInstance.save()
//            
//            self.run(GameAudio.sharedInstance.soundPurchase)
//            
//            self.updateScene()
//        }
//    }
//    
//    func buyExtraStarTime() {
//        if (!starTime && GameData.sharedInstance.totalCoins >= 600) {
//            GameData.sharedInstance.totalCoins -= 600
//            GameData.sharedInstance.starExtraTime = 5
//            GameData.sharedInstance.save()
//            
//            self.run(GameAudio.sharedInstance.soundPurchase)
//            
//            self.updateScene()
//        }
//    }
//}
