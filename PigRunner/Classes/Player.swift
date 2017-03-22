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
    var puff: [SKTexture]!
    
    // Properties
    var isRunning: Bool = true
    var isAlive: Bool = true
    var isInvencible: Bool = false
    var isGliding: Bool = false
    var starPowerup: Bool = false
    var velocityX: Int = playerVelocityX
    var jumpPower: CGFloat = CGFloat(playerJumpPower)
    var jumpsLeft: Int = 2
    var soundEffectPrefs: Bool = true
    let gameScene = GameScene.sharedInstance
    var starTimer: Timer!
    let bodyTexture = SKTexture(imageNamed: "glide")
    var life: Int = 1
    
    // MARK: - Init
    convenience init(imageName: String, pos: CGPoint) {
        self.init(imageName: imageName, pos: pos, categoryBitMask: ColliderType.Player, collisionBitMask: ColliderType.Ground)
    }
    
    init(imageName: String, pos: CGPoint, categoryBitMask: UInt32, collisionBitMask: UInt32) {
        let texture = SKTexture(imageNamed: imageName)
        
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = pos
        self.zPosition = 1
        self.setScale(0.65)
        
        // Load Preferences & Store data
        self.soundEffectPrefs = GamePreferences.sharedInstance.getSoundEffectsPrefs()
        
        // Textures setup
        runTextures = GameTextures.sharedInstance.runTextures
        jumpTextures = GameTextures.sharedInstance.jumpTextures
        slideTextures = GameTextures.sharedInstance.slideTextures
        dieTextures = GameTextures.sharedInstance.dieTextures
        puff = GameTextures.sharedInstance.puff
        
        // Animate the pig's running movement
        self.run(SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: 0.85, resize: false, restore: true)), withKey: "run")
        
        // Setup pig's physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody!.isDynamic = true
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.collisionBitMask = collisionBitMask
        self.physicsBody?.affectedByGravity = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Player methods
    func setPlayerVelocity(to amount: CGFloat) {
        if jumpsLeft == 2{
            self.physicsBody!.velocity.dy = amount
        }
        else {
            self.physicsBody!.velocity.dy = amount + 100
        }
    }
    
    func updatePlayer(_ timeStep: Int) {
        
        if isAlive && self.physicsBody?.velocity.dy == 0.0{
            // Set player's constant velocity
            self.physicsBody?.velocity.dx = CGFloat((kSpeedMultiplier * log(Double(timeStep+1))) + Double(velocityX+400))
        }
        else if isAlive && self.physicsBody?.velocity.dy != 0.0{
            if (self.physicsBody?.velocity.dy)! < CGFloat(0.0){
                self.physicsBody?.velocity.dy = (self.physicsBody?.velocity.dy)!
            }
            self.physicsBody?.velocity.dx = CGFloat(Double(velocityX+400))
        }
        
        // Update player's score
        GameData.sharedInstance.score += Int((self.physicsBody?.velocity.dx)!/CGFloat(velocityX))
        
    }
    
    
    
    // MARK: - Movements
    func jump() {
        if jumpsLeft > 0 {
            

            
            //first jump
            if(jumpsLeft == 2) {
                if soundEffectPrefs {
                    self.run(GameAudio.sharedInstance.soundJump)
                }
                setPlayerVelocity(to: 1200)
                jumpsLeft -= 1
                isRunning = false
                isGliding = false
                changeAnimation(newTextures: jumpTextures, timePerFrame: 0.15, withKey: "jump", restore: false, repeatCount: nil)
            }
                //second jump
            else if (jumpsLeft == 1) {
                if soundEffectPrefs {
                    self.run(GameAudio.sharedInstance.soundDoubleJump)
                }
                
                setPlayerVelocity(to: 1100)
                jumpsLeft -= 1
                isRunning = false
                isGliding = false
                changeAnimation(newTextures: jumpTextures, timePerFrame: 0.15, withKey: "jump", restore: false, repeatCount: nil)
            }
        }
    }
    
    func glide() {
        if jumpsLeft == 0 {
            self.run(GameAudio.sharedInstance.soundJump)
            changeAnimation(newTextures: runTextures, timePerFrame: 0.08, withKey: "run", restore: false, repeatCount: nil)
            self.alpha = 1.0
            self.physicsBody!.velocity.dy = self.physicsBody!.velocity.dy/1.15
        }
    }
    
    func land() {
        if isAlive {
            jumpsLeft = 2
            isRunning = true
            isGliding = false
            changeAnimation(newTextures: runTextures, timePerFrame: 0.08, withKey: "run", restore: false, repeatCount: nil)
        }
    }
    
    func die() {
        self.run(GameAudio.sharedInstance.soundDeath)
        self.physicsBody?.velocity.dx = 0.0
        jumpsLeft = 0
        life = 0
        isRunning = false
        isGliding = false
        isAlive = false
    }
    
    func revive() {
        self.life = 3
        self.isAlive = true
        self.isHidden = false
        self.run(SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: 0.1, resize: false, restore: true)), withKey: "run")
    }
    
    func changeAnimation(newTextures: [SKTexture], timePerFrame: TimeInterval, withKey key: String, restore: Bool, repeatCount: Int?) {
        if restore {
            self.run(SKAction.repeat(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: true), count: repeatCount!))
        } else {
            self.run(SKAction.repeatForever(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: false)), withKey: key)
        }
    }
    
    func getCurrentLife() -> Int {
        return self.life
    }
    
    // MARK: - Collision Handling
    func collided(withBody body: SKPhysicsBody) {
        switch body.categoryBitMask {
            
        // Player - Knife Boxes Collision
        case ColliderType.KnifesBox:
            if !isInvencible {
                life -= 1
                self.run(GameAudio.sharedInstance.soundHurt)
                makePlayerInvencible()
            }
            
        // Player - Net Trap Collision
        case ColliderType.NetTrap:
            if !isInvencible {
                life -= 1
                self.run(GameAudio.sharedInstance.soundHurt)
                makePlayerInvencible()
            }
            
        // Player - Hydrant Collision
        case ColliderType.Hydrant:
            if !isInvencible {
                life -= 1
                self.run(GameAudio.sharedInstance.soundHurt)
                makePlayerInvencible()
            }
            
        // Player - Bear Trap
        case ColliderType.BearTrap:
            if !isInvencible {
                life -= 1
                self.run(GameAudio.sharedInstance.soundHurt)
                makePlayerInvencible()
            }
            
        // Player - Barbecue Collision
        case ColliderType.Barbecue:
            if !isInvencible {
                life -= 1
                self.run(GameAudio.sharedInstance.soundHurt)
                makePlayerInvencible()
            }
            
        // Player - Ground Collision
        case ColliderType.Ground:
            self.land()
            
        case ColliderType.Trigger:
            if let steamroller = body.node?.parent?.childNode(withName: "steamroller") as? Steamroller {
                steamroller.trigger()
            }
            
        case ColliderType.Steamroller:
            if let steamroller = body.node?.parent?.childNode(withName: "steamroller") as? Steamroller {
                if starPowerup {
                    steamroller.removeFromParent()
                    break
                }
                if !isInvencible {
                    self.life -= 1
                    self.run(GameAudio.sharedInstance.soundHurt)
                    makePlayerInvencible()
                }
            }
            
        case ColliderType.Life:
            if let lifeNode = body.node?.parent?.childNode(withName: "apple") {
                lifeNode.removeFromParent()
                if life < 3 {
                    life += 1
                    self.run(GameAudio.sharedInstance.soundExtraLife)
                }
            }
        default:
            break
        }
    }
    
    private func makePlayerInvencible() {
        self.isInvencible = true
        self.physicsBody?.collisionBitMask = ColliderType.Ground
        self.land()
        
        let blinkAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),
                                             SKAction.fadeIn(withDuration: 0.1)])
        let blinkForTime = SKAction.repeat(blinkAction, count: 6)
        
        self.run(blinkForTime, completion: {
            self.isInvencible = false
            self.physicsBody?.collisionBitMask = ColliderType.Ground
                | ColliderType.KnifesBox
                | ColliderType.NetTrap
                | ColliderType.Hydrant
                | ColliderType.BearTrap
                | ColliderType.Life
                | ColliderType.Steamroller
        })
    }
}
