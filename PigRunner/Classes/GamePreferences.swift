//
//  GameSettings.swift
//  PigRunner
//
//  Created by Joao Pereira on 08/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation

let GamePreferencesSharedInstance = GamePreferences()

class GamePreferences {
    // MARK: - Prorperties
    class var sharedInstance: GamePreferences {
        return GamePreferencesSharedInstance
    }
    
    // MARK: Private
    private let localDefaults = UserDefaults.standard
    private let keyFirstRun = "FirstRun"
    private let keyBackgroundMusic = "BackgroundMusic"
    private let keySoundEffects = "SoundEffects"
    private let keyTutorial = "Tutorial"
    
    // MARK: - Init
    init() {
        if (self.localDefaults.object(forKey: keyFirstRun) == nil) {
            self.firstLaunch()
        }
    }
    
    // MARK: - Methods
    // MARK: Private
    private func firstLaunch() {
        self.localDefaults.set(true, forKey: keyBackgroundMusic)
        self.localDefaults.set(true, forKey: keySoundEffects)
        self.localDefaults.set(false, forKey: keyFirstRun)
        self.localDefaults.set(true, forKey: keyTutorial)
        self.localDefaults.synchronize()
    }
    
    // MARK: Public
    func saveBackgroundMusicPrefs(_ preference: Bool) {
        self.localDefaults.set(preference, forKey: keyBackgroundMusic)
        self.localDefaults.synchronize()
    }
    
    func saveSoundEffectsPrefs(_ preference: Bool) {
        self.localDefaults.set(preference, forKey: keySoundEffects)
        self.localDefaults.synchronize()
    }
    
    func saveTutorialPrefs(_ preference: Bool) {
        self.localDefaults.set(preference, forKey: keyTutorial)
        self.localDefaults.synchronize()
    }
    
    func getBackgroundMusicPrefs() -> Bool {
        return self.localDefaults.bool(forKey: keyBackgroundMusic)
    }
    
    func getSoundEffectsPrefs() -> Bool {
        return self.localDefaults.bool(forKey: keySoundEffects)
    }
    
    func getTutorialPrefs() -> Bool {
        return self.localDefaults.bool(forKey: keyTutorial)
    }
}
