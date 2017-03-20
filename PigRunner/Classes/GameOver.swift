//
//  GameOver.swift
//  PigRunner
//
//  Created by Joao Pereira on 01/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit
import FBSDKCoreKit

class GameOver: SKNode {
    // MARK: - Properties
    var gameOverNode: SKNode!
    var menuBtn: SKSpriteNode!
    var restartBtn: SKSpriteNode!
    var totalCoinsLbl: SKLabelNode!
    var fbConnection: FacebookConnection!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.gameOverNode = SKNode(fileNamed: "GameOver")!.childNode(withName: "Overlay")
        self.restartBtn = self.gameOverNode.childNode(withName: "restartBtn") as! SKSpriteNode
        self.menuBtn = self.gameOverNode.childNode(withName: "menuBtn") as! SKSpriteNode
        self.totalCoinsLbl = self.gameOverNode.childNode(withName: "totalCoinsLbl") as! SKLabelNode
    }
    
    // MARK: - Methods
    func show(at pos: CGPoint, onNode node: SKNode, withCoins coins: Int) {
        GameAudio.sharedInstance.pauseBackgroundMusic()
        self.run(GameAudio.sharedInstance.soundGameOver)
        
        GameData.sharedInstance.totalCoins += Int(coins)
        GameData.sharedInstance.save()
        
        self.totalCoinsLbl.text = String(GameData.sharedInstance.score)
        
        self.gameOverNode.position = pos
        self.gameOverNode.removeFromParent()
        self.gameOverNode.zPosition = GameLayer.Interface
        self.gameOverNode.setScale(1)
        
        //Salva no GameData o maior score
        let a = GameData.sharedInstance.score
        let b = UserDefaults.standard.value(forKey: "high") as! Int
        if GameData.sharedInstance.score > UserDefaults.standard.value(forKey: "high") as! Int{
            UserDefaults.standard.set(GameData.sharedInstance.score, forKey: "high")
            let c = UserDefaults.standard.value(forKey: "high") as! Int
            // Graph Request para asalvar no facebook o maior score
            if (FBSDKAccessToken.current() != nil){
                fbConnection.sendScore(score: UserDefaults.standard.value(forKey: "high") as! Int)
                fbConnection.loggedUser?.userScore = UserDefaults.standard.value(forKey: "high") as! Int
            }
        }
        else {
            GameData.sharedInstance.highScore = UserDefaults.standard.value(forKey: "high") as! Int
            if (FBSDKAccessToken.current() != nil){
                fbConnection.sendScore(score: UserDefaults.standard.value(forKey: "high") as! Int)
                fbConnection.loggedUser?.userScore = UserDefaults.standard.value(forKey: "high") as! Int
            }
        }

        
        node.addChild(self.gameOverNode)
        
        self.gameOverNode.run(SKAction.scale(to: 1.1, duration: 0.5))
    }
    
    func tappedButton() {
        self.gameOverNode.removeFromParent()
    }
}
