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
    
    print(texture.size())
    
    self.emitter = untypedEmitter as! SKEmitterNode
    
    self.anchorPoint = CGPoint(x: 0, y: 0.5)
    self.position = pos
    self.zPosition = 1
    self.setScale(0.5)
    
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
    self.run(SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: 0.15, resize: false, restore: true)), withKey: "run")
    
    // Setup pig's physics body
    self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
    self.physicsBody!.isDynamic = true
    self.physicsBody!.allowsRotation = false
    self.physicsBody!.categoryBitMask = categoryBitMask
    self.physicsBody!.collisionBitMask = collisionBitMask
    self.physicsBody?.friction = 0
    self.physicsBody?.restitution = 0.0
    self.physicsBody?.mass = 50.0
    self.physicsBody?.affectedByGravity = true
    self.physicsBody?.density = 4.0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Player methods
  func setPlayerVelocity(to amount: CGFloat) {
    self.physicsBody!.velocity.dy = amount
  }
  
  func updatePlayer(_ timeStep: Int) {
    if isAlive && self.physicsBody?.velocity.dy == 0.0{
      // Set player's constant velocity
      self.physicsBody?.velocity.dx = CGFloat((kSpeedMultiplier * log(Double(timeStep+1))) + Double(velocityX+150))}
    else if isAlive && self.physicsBody?.velocity.dy != 0.0{
      if (self.physicsBody?.velocity.dy)! < CGFloat(0.0){
        self.physicsBody?.velocity.dy = (self.physicsBody?.velocity.dy)!
      }
      self.physicsBody?.velocity.dx = CGFloat(Double(velocityX+150))
    }
    // Update player's score
    GameData.sharedInstance.score += Int((self.physicsBody?.velocity.dx)!/CGFloat(velocityX))
  }
  
  // MARK: - Movements
  func jump() {
    if jumpsLeft > 0 {
      emitter.isHidden = false
      
      let delayInSeconds = 0.3
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
        self.emitter.isHidden = true
      }
      
      if soundEffectPrefs {
        self.run(GameAudio.sharedInstance.soundJump)
      }
      
      setPlayerVelocity(to: 900.0)
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
      self.texture = SKTexture(imageNamed: "Running 01")
      self.alpha = 1.0
      self.physicsBody!.velocity.dy = self.physicsBody!.velocity.dy/1.15
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
        if soundEffectPrefs {
          coin.run(GameAudio.sharedInstance.soundCoin)
        }
        GameData.sharedInstance.coins += 1
        coin.collected()
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
      }
      
    // Player - Ground Collision
    case ColliderType.Ground:
      self.land()
      
    case ColliderType.Trigger:if let steamroller = body.node?.parent?.childNode(withName: "steamroller") as? Steamroller {
        steamroller.trigger()
      }
      
    case ColliderType.Steamroller:
      if let steamroller = body.node?.parent?.childNode(withName: "steamroller") as? Steamroller {
        if starPowerup {
          steamroller.removeFromParent()
          break
        }
        
        if !isInvencible {
          self.life = 0
        }
      }
      
    default:
      break
    }
  }
}
