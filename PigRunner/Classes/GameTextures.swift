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
    internal var dieTextures = [SKTexture]()
    internal var roller = [SKTexture]()
    internal var puff = [SKTexture]()
    
    // MARK: - Init
    init() {
        self.setupRunTextures()
        self.setupJumpTextures()
        self.setupSlideTextures()
        self.setupIdleTextures()
        self.setupDieTextures()
        self.setupPuffTextures()
    }
    
    
    // MARK: Animation textures setup
    private func setupRunTextures() {
        for i in 1...12 {
            runTextures.append(SKTexture.init(imageNamed: "Running 0\(i)"))
        }
    }
    
    private func setupJumpTextures() {
        for i in 1...12 {
            jumpTextures.append(SKTexture.init(imageNamed: "Running 0\(i)"))
        }
    }
    
    private func setupSlideTextures() {
        for i in 1...12 {
            slideTextures.append(SKTexture.init(imageNamed: "Running 0\(i)"))
        }
    }
    
    private func setupIdleTextures() {
        for i in 1...12 {
            idleTextures.append(SKTexture.init(imageNamed: "Running 0\(i)"))
        }
    }
    
    private func setupDieTextures() {
        for i in 1...12 {
            dieTextures.append(SKTexture.init(imageNamed: "Running 0\(i)"))
        }
    }
    
    private func setRollerTextures(){
        for i in 1...2 {
            roller.append(SKTexture.init(cgImage: "roller0\(i)" as! CGImage))
        }
    }
    
    private func setupPuffTextures(){
        for i in 1...5 {
            puff.append(SKTexture.init(imageNamed: "puff\(i)"))
        }
    }
}
