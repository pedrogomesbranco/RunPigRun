//
//  PauseButton.swift
//  PigRunner
//
//  Created by Joao Pereira on 24/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class PauseButton: SKSpriteNode {
    // MARK: - Properties
    internal var tapped = false
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        let texture = SKTexture(imageNamed: "pause redondo")
        self.init(texture: texture, color: UIColor.white, size: texture.size())
        
        self.setupPauseButton()
    }
    
    // MARK: - Setup Functions
    private func setupPauseButton() {
        self.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        self.position = CGPoint(x: kViewSizeWidth, y: kViewSizeHeight)
        self.setScale(0.3)
        self.zPosition = GameLayer.Interface
    }
    
    // MARK: - Action Functions
    func tappedPauseButton() {
        self.tapped = !self.tapped
        
        let pauseTexture = SKTexture(imageNamed: "pause redondo")
        let resumeTexture = SKTexture(imageNamed: "pause redondo")
        
        self.texture = self.tapped ? resumeTexture : pauseTexture
    }
}
