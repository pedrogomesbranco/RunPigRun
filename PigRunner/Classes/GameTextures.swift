//
//  GameTextures.swift
//  pigrunner
//
//  Created by Joao Pereira on 17/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class GameTextures {
    // Shared Instance
    static let GameTexturesSharedInstance = GameTextures()
    
    class var sharedInstance: GameTextures {
        return GameTexturesSharedInstance
    }
    
    // MARK: - Public properties
    // Texture Atlas
    let pigAnimationAtlas = SKTextureAtlas(named: "Pig")
    
    // Texture Arrays
    internal var runTextures = [SKTexture]()
    internal var jumpTextures = [SKTexture]()
    internal var slideTextures = [SKTexture]()
    internal var idleTextures = [SKTexture]()
    internal var dieTextures = [SKTexture]()
    
    // MARK: - Init
    init() {
        self.setupRunTextures()
        self.setupJumpTextures()
        self.setupSlideTextures()
        self.setupIdleTextures()
        self.setupDieTextures()
    }
    
    func preloadAssets() {
        pigAnimationAtlas.preload(completionHandler: {
            print("Pig animations atlas pre-loaded.")
        })
    }
    
    // MARK: Animation textures setup
    private func setupRunTextures() {
        for i in 0...5 {
            runTextures.append(pigAnimationAtlas.textureNamed("Run_00\(i)"))
        }
    }
    
    private func setupJumpTextures() {
        for i in 0...9 {
            jumpTextures.append(pigAnimationAtlas.textureNamed("Jump_00\(i)"))
        }
    }
    
    private func setupSlideTextures() {
        for i in 0...3 {
            slideTextures.append(pigAnimationAtlas.textureNamed("Sliding_00\(i)"))
        }
    }
    
    private func setupIdleTextures() {
        for i in 0...9 {
            idleTextures.append(pigAnimationAtlas.textureNamed("Idle_00\(i)"))
        }
    }
    
    private func setupDieTextures() {
        for i in 0...7 {
            dieTextures.append(pigAnimationAtlas.textureNamed("Die_00\(i)"))
        }
    }
}
