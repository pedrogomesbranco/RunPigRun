//
//  GameAudio.swift
//  PigRunner
//
//  Created by Joao Pereira on 08/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit
import AVFoundation

internal class Music {
  class var BackgroundMusic: String { return "funtrack.mp3" }
  class var BackgroundStarMusic: String { return "background_star.mp3" }
}

internal class SoundEffects {
  class var Coin: String { return "coin" }
  class var BigCoin: String { return "walk.wav" }
  class var ExtraLife: String { return "apple.mp3" }
  class var Death: String { return "no.wav" }
  class var FirstJump: String { return "pulo_simples.mp3" }
  class var SecondJump: String { return "pulo_duplo.mp3" }
  class var Hurt: String { return "ouch.m4a" }
  class var GameOver: String { return "game_over" }
  class var NewRecord: String { return "letsgo.m4a" }
  class var Purchase: String { return "hahaha.m4a" }
}

let GameAudioSharedInstance = GameAudio()

class GameAudio {
  // MARK: - Properties
  class var sharedInstance: GameAudio {
    return GameAudioSharedInstance
  }
  
  // MARK: Private
  private var musicPlayer = AVAudioPlayer()
  
  // MARK: Public
  internal let soundCoin = SKAction.playSoundFileNamed(SoundEffects.Coin, waitForCompletion: false)
  internal let soundBigCoin = SKAction.playSoundFileNamed(SoundEffects.BigCoin, waitForCompletion: false)
  internal let soundExtraLife = SKAction.playSoundFileNamed(SoundEffects.ExtraLife, waitForCompletion: false)
  internal let soundDeath = SKAction.playSoundFileNamed(SoundEffects.Death, waitForCompletion: true)
  internal let soundJump = SKAction.playSoundFileNamed(SoundEffects.FirstJump, waitForCompletion: false)
  internal let soundDoubleJump = SKAction.playSoundFileNamed(SoundEffects.SecondJump, waitForCompletion: false)
  internal let soundHurt = SKAction.playSoundFileNamed(SoundEffects.Hurt, waitForCompletion: true)
  internal let soundGameOver = SKAction.playSoundFileNamed(SoundEffects.GameOver, waitForCompletion: false)
  internal let soundNewRecord = SKAction.playSoundFileNamed(SoundEffects.NewRecord, waitForCompletion: false)
  internal let soundPurchase = SKAction.playSoundFileNamed(SoundEffects.Purchase, waitForCompletion: false)
  
  // MARK: - Init
  init() { }
  
  // MARK: - Background Music player
  func playBackgroundMusic(filename: String) {
    let music = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: nil)!)
    let musicPreference = GamePreferences.sharedInstance.getBackgroundMusicPrefs()
    
    do {
      try self.musicPlayer = AVAudioPlayer(contentsOf: music)
    } catch { }
    
    self.musicPlayer.numberOfLoops = -1
    self.musicPlayer.volume = 0.5
    self.musicPlayer.prepareToPlay()
    
    if musicPreference {
      self.musicPlayer.play()
    }
  }
  
  func stopBackgroundMusic() {
    if self.musicPlayer.isPlaying {
      self.musicPlayer.pause()
    }
  }
  
  func pauseBackgroundMusic() {
    if self.musicPlayer.isPlaying {
      self.musicPlayer.pause()
    }
  }
  
  func resumeBackgroundMusic() {
    if !self.musicPlayer.isPlaying {
      self.musicPlayer.play()
    }
  }
}
