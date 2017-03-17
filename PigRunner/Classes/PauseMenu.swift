//
//  PauseMenu.swift
//  PigRunner
//
//  Created by Joao Pereira on 29/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class PauseMenu: SKNode {
  // MARK: - Properties
  var pauseMenuNode: SKNode!
  var playBtn: SKSpriteNode!
  var menuBtn: SKSpriteNode!
  
  // MARK: - Init
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init() {
    super.init()
    
    self.pauseMenuNode = SKNode(fileNamed: "PauseMenu")!.childNode(withName: "Overlay")
    
    self.playBtn = self.pauseMenuNode.childNode(withName: "playBtn") as! SKSpriteNode
    self.menuBtn = self.pauseMenuNode.childNode(withName: "menuBtn") as! SKSpriteNode
  }
  
  // MARK: - Methods
  func show(at pos: CGPoint, onNode node: SKNode) {
    GameAudio.sharedInstance.pauseBackgroundMusic()
    
    self.pauseMenuNode.position = pos
    self.pauseMenuNode.removeFromParent()
    self.pauseMenuNode.zPosition = GameLayer.Interface
    
    node.addChild(self.pauseMenuNode)
  }
  
  func tappedButton() {
    if GamePreferences.sharedInstance.getBackgroundMusicPrefs() {
      GameAudio.sharedInstance.resumeBackgroundMusic()
    }
    
    self.pauseMenuNode.removeFromParent()
    self.removeFromParent()
  }
}
