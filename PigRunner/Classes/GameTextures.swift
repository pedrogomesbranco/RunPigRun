//
//  GameTextures.swift
//  pigrunner
//
//  Created by Joao Pereira on 17/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

// MARK: - Sprite Names
class SpriteName {
    // Player
    class var Player: String { return "Player" }
 
    // HUD
    class var CoinsCollected: String { return "coin" }
}

class GameTextures {
    // Shared Instance
    static let GameTexturesSharedInstance = GameTextures()
    
    class var sharedInstance: GameTextures {
        return GameTexturesSharedInstance
    }
    
    // MARK: - Private properties
    private var textureAtlas = SKTextureAtlas()
    
    // MARK: - Public properties
    // Texture Arrays
    internal var runTextures = [SKTexture]()
    internal var jumpTextures = [SKTexture]()
    internal var slideTextures = [SKTexture]()
    
    // MARK: - Init
    init() {
        self.textureAtlas = SKTextureAtlas(named: "GameTextures")
        
        self.setupRunTextures()
        self.setupJumpTextures()
        self.setupSlideTextures()
    }
    
    // MARK: - Sprite Creation
    func spriteWithName(name: String) -> SKSpriteNode {
        return SKSpriteNode(texture: self.textureAtlas.textureNamed(name))
    }
    
    // MARK: - Texture Creation
    func textureWithName(name: String) -> SKTexture {
        return SKTexture(imageNamed: name)
    }
    
    // MARK: Animation textures setup
    private func setupRunTextures() {
        for i in 0...5 {
            runTextures.append(SKTexture(imageNamed: "Run_00\(i)"))
        }
    }
    
    private func setupJumpTextures() {
        for i in 0...9 {
            jumpTextures.append(SKTexture(imageNamed: "Jump_00\(i)"))
        }
    }
    
    private func setupSlideTextures() {
        for i in 0...3 {
            slideTextures.append(SKTexture(imageNamed: "Sliding_00\(i)"))
        }
    }
}
