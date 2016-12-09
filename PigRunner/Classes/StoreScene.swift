//
//  StoreScene.swift
//  PigRunner
//
//  Created by Joao Pereira on 30/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class StoreScene: SKNode {
    // MARK: - Properties
    var storeNode: SKNode!
    
    var coinButton: SKSpriteNode!
    var starButton: SKSpriteNode!
    var lifeButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    var coinsLabel: SKLabelNode!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.storeNode = SKNode(fileNamed: "StoreScene")!.childNode(withName: "Overlay")
        
        self.coinButton = self.storeNode.childNode(withName: "coinButton") as! SKSpriteNode
        self.starButton = self.storeNode.childNode(withName: "starButton") as! SKSpriteNode
        self.lifeButton = self.storeNode.childNode(withName: "lifeButton") as! SKSpriteNode
        self.menuButton = self.storeNode.childNode(withName: "menuButton") as! SKSpriteNode
        self.coinsLabel = self.storeNode.childNode(withName: "coinsLabel") as! SKLabelNode
        
        self.coinButton.zPosition = GameLayer.Interface
        self.menuButton.zPosition = GameLayer.Interface
        self.coinsLabel.zPosition = GameLayer.Interface
        
        updateScene()
    }
    
    // MARK: - User Interaction
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
    
    // MARK: - Methods
    func show(at pos: CGPoint, onScene scene: SKScene) {
        GameAudio.sharedInstance.pauseBackgroundMusic()
        
        self.storeNode.position = pos
        self.storeNode.removeFromParent()
        self.storeNode.zPosition = GameLayer.Interface
        
        scene.addChild(self.storeNode)
    }
    
    // MARK: - Methods
    private func goToMenu() {
//        let menuScene = MenuScene(size: size)
//        menuScene.scaleMode = .fill
//        let transition = SKTransition.fade(with: UIColor.black, duration: 0.25)
//        
//        self.view?.presentScene(menuScene, transition: transition)
        self.removeFromParent()
    }
    
    private func updateScene() {
        self.coinsLabel.text = "\(GameData.sharedInstance.totalCoins)c"
    }
    
    private func buySpecialCoinBonus() {
        GameData.sharedInstance.totalCoins -= 1
        GameData.sharedInstance.specialCoinMultiplier = 2
        GameData.sharedInstance.save()
    }
    
    private func buyExtraLife() {
        GameData.sharedInstance.totalCoins -= 1
        GameData.sharedInstance.extraLife = true
        GameData.sharedInstance.save()
    }
    
    private func buyExtraStarTime() {
        GameData.sharedInstance.totalCoins -= 1
        GameData.sharedInstance.starExtraTime = 2
        GameData.sharedInstance.save()
    }
}
