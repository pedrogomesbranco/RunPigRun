//
//  Player.swift
//  PigRunner
//
//  Created by Joao Pereira on 07/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    // MARK: - Properties
    // Textures
    var runTextures: [SKTexture]!
    var jumpTextures: [SKTexture]!
    var slideTextures: [SKTexture]!
    var dieTextures: [SKTexture]!
    
    // Properties
    var isRunning: Bool = true
    var isAlive: Bool = true
    var isInvencible: Bool = false
    var life: Int = 3
    var velocityX: Int = playerVelocityX
    var jumpPower: CGFloat = CGFloat(playerJumpPower)
    var jumpsLeft: Int = 2
    let gameScene = GameScene.sharedInstance
    
    // MARK: - Init
    convenience init(imageName: String, pos: CGPoint) {
        self.init(imageName: imageName, pos: pos, categoryBitMask: ColliderType.Player, collisionBitMask: ColliderType.Ground)
    }
    
    init(imageName: String, pos: CGPoint, categoryBitMask: UInt32, collisionBitMask: UInt32) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = position
        self.zPosition = GameLayer.Player
        self.setScale(0.3)
        
        // Textures setup
        runTextures = GameTextures.sharedInstance.runTextures
        jumpTextures = GameTextures.sharedInstance.jumpTextures
        slideTextures = GameTextures.sharedInstance.slideTextures
        dieTextures = GameTextures.sharedInstance.dieTextures
        
        // Animate the pig's running movement
        self.run(SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: 0.1, resize: false, restore: true)), withKey: "run")
        
        // Setup pig's physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody!.isDynamic = true
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.collisionBitMask = collisionBitMask
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Player methods
    func setPlayerVelocity(to amount: CGFloat) {
        self.physicsBody!.velocity.dy =
            max(self.physicsBody!.velocity.dy, amount * CGFloat(jumpPower))
    }
    
    func updatePlayer(_ timeStep: Int) {
        if isAlive {
            // Set player's constant velocity
            self.physicsBody?.velocity.dx = CGFloat((kSpeedMultiplier * log(Double(timeStep+1))) + Double(velocityX))
            
            // Update player's score
            GameData.sharedInstance.score += Int((self.physicsBody?.velocity.dx)!/CGFloat(velocityX))
        }
    }
    
    // MARK: - Movements
    func jump() {
        if jumpsLeft > 0 {
            setPlayerVelocity(to: 700.0)
            jumpsLeft -= 1
            isRunning = false
            changeAnimation(newTextures: jumpTextures, timePerFrame: 0.15, withKey: "jump", restore: false, repeatCount: nil)
        }
    }
    
    func land() {
        if isAlive {
            jumpsLeft = 2
            isRunning = true
            changeAnimation(newTextures: runTextures, timePerFrame: 0.1, withKey: "run", restore: false, repeatCount: nil)
        }
    }
    
    func die() {
        self.physicsBody?.velocity.dx = 0.0
        jumpsLeft = 0
        life = 0
        isRunning = false
        isAlive = false
        let dieAction = SKAction.animate(with: dieTextures, timePerFrame: 0.1, resize: true, restore: false)
        self.run(dieAction)
        self.removeAllActions()
    }
    
    func revive() {
        self.life = 3
        self.isAlive = true
    }
    
    // MARK: Power Ups
    func collectedMagnet() {
    }
    
    func changeAnimation(newTextures: [SKTexture], timePerFrame: TimeInterval, withKey key: String, restore: Bool, repeatCount: Int?) {
        self.setScale(0.3)
        
        if restore {
            self.run(SKAction.repeat(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: true), count: repeatCount!))
        } else {
            self.run(SKAction.repeatForever(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: false)), withKey: key)
        }
    }
    
    
    // MARK: - Collision Handling
    func collided(withBody body: SKPhysicsBody) {
        switch body.categoryBitMask {
        // Player - Coin Collision
        case ColliderType.CoinNormal:
            if let coin = body.node as? Coin {
                GameData.sharedInstance.coins += 1
                coin.collectedCoin()
            }
            
        // Player - Special Coin Collision
        case ColliderType.CoinSpecial:
            if let specialCoin = body.node as? Coin {
                GameData.sharedInstance.coins += (GameData.sharedInstance.specialCoinMultiplier) * 5
                specialCoin.collectedCoin()
            }
            
        // Player - Spike Collision
        case ColliderType.Spikes:
            guard let _ = body.node as? SKSpriteNode else { break }
            
            if isInvencible == false {
                self.life -= 1
                self.makePlayerInvencible()
            }
            
        // Player - Ground Collision
        case ColliderType.Ground:
            self.land()
            
        case ColliderType.Trigger:
            if let spinningWheel = body.node?.parent?.childNode(withName: "sawblade") as? SpinningWheel {
                spinningWheel.trigger()
            }
            
        case ColliderType.SpinningWheel:
            self.life = 0
            
        case ColliderType.Magnet:
            if let magnet = body.node as? SKSpriteNode {
                self.collectedMagnet()
                magnet.removeFromParent()
            }
            
        default:
            break
        }
    }
    
    private func makePlayerInvencible() {
        self.isInvencible = true
        
        let blinkAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),
                                             SKAction.fadeIn(withDuration: 0.1)])
        let blinkForTime = SKAction.repeat(blinkAction, count: 6)
        
        self.run(blinkForTime, completion: {
            self.isInvencible = false
        })
    }
}
