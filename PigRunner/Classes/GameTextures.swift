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
    // Texture Arrays
    internal var runTextures = [SKTexture]()
    internal var jumpTextures = [SKTexture]()
    internal var slideTextures = [SKTexture]()
    internal var idleTextures = [SKTexture]()
    
    // MARK: - Init
    init() {
        self.setupRunTextures()
        self.setupJumpTextures()
        self.setupSlideTextures()
        self.setupIdleTextures()
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
    
    private func setupIdleTextures() {
        for i in 0...9 {
            idleTextures.append(SKTexture(imageNamed: "Idle_00\(i)"))
        }
    }
}
