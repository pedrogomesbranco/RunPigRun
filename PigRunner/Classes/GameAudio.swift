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
    class var BackgroundMusic: String { return "background.mp3" }
}

internal class SoundEffects {
    class var Coin: String { return "coin" }
    class var BigCoin: String { return "big_coin" }
    class var ExtraLife: String { return "extra_life" }
    class var Star: String { return "star" }
    class var SecondJump: String { return "jump" }
    class var Hurt: String { return "hurt" }
    class var GameOver: String { return "game_over" }
    class var NewRecord: String { return "new_record" }
    class var Purchase: String { return "purchase" }
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
    internal let soundStar = SKAction.playSoundFileNamed(SoundEffects.Star, waitForCompletion: false)
    internal let soundSecondJump = SKAction.playSoundFileNamed(SoundEffects.SecondJump, waitForCompletion: false)
    internal let soundHurt = SKAction.playSoundFileNamed(SoundEffects.Hurt, waitForCompletion: false)
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
        self.musicPlayer.volume = 0.25
        self.musicPlayer.prepareToPlay()
        
        if musicPreference {
            self.musicPlayer.play()
        }
    }
    
    func stopBackgroundMusic() {
        if self.musicPlayer.isPlaying {
            self.musicPlayer.stop()
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
