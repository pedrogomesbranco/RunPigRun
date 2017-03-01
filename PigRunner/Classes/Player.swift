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
    var isGliding: Bool = false
    var starPowerup: Bool = false
    var life: Int = 3
    var velocityX: Int = playerVelocityX
    var jumpPower: CGFloat = CGFloat(playerJumpPower)
    var jumpsLeft: Int = 2
    var soundEffectPrefs: Bool = true
    var emitter: SKEmitterNode!
    let gameScene = GameScene.sharedInstance
    var starTimer: Timer!
    
    // MARK: - Init
    convenience init(imageName: String, pos: CGPoint) {
        self.init(imageName: imageName, pos: pos, categoryBitMask: ColliderType.Player, collisionBitMask: ColliderType.Ground)
    }
    
    init(imageName: String, pos: CGPoint, categoryBitMask: UInt32, collisionBitMask: UInt32) {
        let texture = SKTexture(imageNamed: imageName)
        let untypedEmitter: AnyObject = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "FartEmitter", ofType: "sks")!) as AnyObject
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.emitter = untypedEmitter as! SKEmitterNode
        
        self.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.position = pos
        self.zPosition = GameLayer.Player
        self.setScale(0.3)
        self.addChild(emitter)
        
        emitter.particlePosition.x += self.size.width + 30
        emitter.particlePosition.y -= self.size.height
        
        emitter.isHidden = true
        
        // Load Preferences & Store data
        self.soundEffectPrefs = GamePreferences.sharedInstance.getSoundEffectsPrefs()
        
        if GameData.sharedInstance.extraLife {
            self.life = 4
        }
        
        // Textures setup
        runTextures = GameTextures.sharedInstance.runTextures
        jumpTextures = GameTextures.sharedInstance.jumpTextures
        slideTextures = GameTextures.sharedInstance.slideTextures
        dieTextures = GameTextures.sharedInstance.dieTextures
        
        // Animate the pig's running movement
        self.run(SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: 0.1, resize: false, restore: true)), withKey: "run")
        
        // Setup pig's physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/1.15, height: self.size.height/1.15))
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
            emitter.isHidden = false
            
            let delayInSeconds = 0.4
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                self.emitter.isHidden = true
            }
            
            if soundEffectPrefs {
                self.run(GameAudio.sharedInstance.soundJump)
            }
            
            setPlayerVelocity(to: 700.0)
            jumpsLeft -= 1
            isRunning = false
            isGliding = false
            changeAnimation(newTextures: jumpTextures, timePerFrame: 0.15, withKey: "jump", restore: false, repeatCount: nil)
        }
    }
    
    func glide() {
        if jumpsLeft == 0 {
            self.emitter.isHidden = false
            self.run(GameAudio.sharedInstance.soundJump)
            self.removeAllActions()
            self.texture = SKTexture(imageNamed: "Run_000")
            self.alpha = 1.0
            self.physicsBody!.velocity.dy = self.physicsBody!.velocity.dy/1.1
        }
    }
    
    func land() {
        if isAlive {
            self.emitter.isHidden = true
            jumpsLeft = 2
            isRunning = true
            isGliding = false
            changeAnimation(newTextures: runTextures, timePerFrame: 0.1, withKey: "run", restore: false, repeatCount: nil)
        }
    }
    
    func die() {
        self.isHidden = true
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
        self.setScale(0.3)
        
        if restore {
            self.run(SKAction.repeat(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: true), count: repeatCount!))
        } else {
            self.run(SKAction.repeatForever(SKAction.animate(with: newTextures, timePerFrame: timePerFrame, resize: true, restore: false)), withKey: key)
        }
    }
    
    // MARK: Power Ups
    func collectedStar() {
        let musicPrefs = GamePreferences.sharedInstance.getBackgroundMusicPrefs()
        
        if musicPrefs {
            GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundStarMusic)
        }
        
        self.isInvencible = true
        self.starPowerup = true
        
        let blinkAction1 = SKAction.colorize(with: UIColor.yellow, colorBlendFactor: 0.6, duration: 0.2)
        let blinkAction2 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0.6, duration: 0.2)
        
        let blinkSequence = SKAction.sequence([blinkAction1, blinkAction2])
        let blinkAction = SKAction.repeat(blinkSequence, count: 20) // 9 seconds duration
        
        self.run(blinkAction)
        
        let time = 9+GameData.sharedInstance.starExtraTime
        
        self.starTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { (_) in
            self.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 0.1))
            self.isInvencible = false
            self.starPowerup = false
            if musicPrefs {
                GameAudio.sharedInstance.playBackgroundMusic(filename: Music.BackgroundMusic)
            }
        })
    }
    
    // MARK: - Collision Handling
    func collided(withBody body: SKPhysicsBody) {
        switch body.categoryBitMask {
        // Player - Coin Collision
        case ColliderType.CoinNormal:
            if let coin = body.node as? Coin {
                if soundEffectPrefs {
                    coin.run(GameAudio.sharedInstance.soundCoin)
                }
                GameData.sharedInstance.coins += 1
                coin.collected()
            }
            
        // Player - Special Coin Collision
        case ColliderType.CoinSpecial:
            if let specialCoin = body.node as? Coin {
                if soundEffectPrefs {
                    specialCoin.run(GameAudio.sharedInstance.soundBigCoin)
                }
                GameData.sharedInstance.coins += (GameData.sharedInstance.specialCoinMultiplier) * 5
                specialCoin.collected()
            }
            
        // Player - Spike Collision
        case ColliderType.Spikes:
            guard let spike = body.node as? SKSpriteNode else { break }
            
            if starPowerup {
                spike.removeFromParent()
                break
            }
            
            if soundEffectPrefs {
                spike.run(GameAudio.sharedInstance.soundHurt)
            }
            
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
            if let spinningWheel = body.node?.parent?.childNode(withName: "sawblade") as? SpinningWheel {
                if starPowerup {
                    spinningWheel.removeFromParent()
                    break
                }
                
                if !isInvencible {
                    self.life = 0
                }
            }
            
        case ColliderType.Star:
            if let star = body.node as? SKSpriteNode {
                if soundEffectPrefs {
                    star.run(GameAudio.sharedInstance.soundStar)
                }
                self.collectedStar()
                star.removeFromParent()
            }
            
        case ColliderType.Life:
            if let lifeNode = body.node as? SKSpriteNode {
                if life < 4 {
                    self.life += 1
                }
                lifeNode.removeFromParent()
            }
            
        default:
            break
        }
    }
    
    private func makePlayerInvencible() {
        self.isInvencible = true
        self.land()
        
        let blinkAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),
                                             SKAction.fadeIn(withDuration: 0.1)])
        let blinkForTime = SKAction.repeat(blinkAction, count: 6)
        
        self.run(blinkForTime, completion: {
            self.isInvencible = false
        })
    }
}
