//
//  GameData.swift
//  PigRunner
//
//  Created by Joao Pereira on 01/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation

class GameData: NSObject {
    // MARK: - Properties
    // Player points
    var coins: Int = 0
    var totalCoins: Int = 0
    var score: Int = 0
    var highScore: Int = 0
    
    // Store items
    var specialCoinMultiplier: Int = 1
    var extraLife: Bool = false
    var starExtraTime: Int = 0
    
    static var filePath: String? {
        get {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/gamedata") as String?
        }
    }
    
    // MARK: Init
    // NSCoding Protocol
    required init?(coder aDecoder: NSCoder) {
        self.highScore = aDecoder.decodeInteger(forKey: "highScore")
        self.totalCoins = aDecoder.decodeInteger(forKey: "totalCoins")
        self.specialCoinMultiplier = aDecoder.decodeInteger(forKey: "specialCoinMultiplier")
        self.extraLife = aDecoder.decodeBool(forKey: "extraLife")
        self.starExtraTime = aDecoder.decodeInteger(forKey: "starExtraTime")
    }
    
    override init() {
        super.init()
    }
    
    // Shared Instance
    static let sharedInstance = GameData.loadInstance()
    
    // MARK: - Methods
    func reset() {
        self.coins = 0
        self.score = 0
    }
    
    func save() {
        guard let filePath = GameData.filePath else { return }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        do {
            try encodedData.write(to: URL(fileURLWithPath: filePath))
        } catch {
            return
        }
    }
    
    class func loadInstance() -> Self {
        return loadInstanceHelper()
    }
    
    private class func loadInstanceHelper<T>() -> T {
        guard let filePath = GameData.filePath else {
            return GameData() as! T
        }
        
        let decodedData = NSData(contentsOfFile: filePath as String)
        
        if let decodedData = decodedData {
            let gameData = NSKeyedUnarchiver.unarchiveObject(with: decodedData as Data) as! T
            return gameData
        }
        
        return GameData() as! T
    }
}

// MARK: - Persistence
extension GameData: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(GameData.sharedInstance.highScore, forKey: "highScore")
        aCoder.encode(GameData.sharedInstance.totalCoins, forKey: "totalCoins")
        aCoder.encode(GameData.sharedInstance.specialCoinMultiplier, forKey: "specialCoinMultiplier")
        aCoder.encode(GameData.sharedInstance.extraLife, forKey: "extraLife")
        aCoder.encode(GameData.sharedInstance.starExtraTime, forKey: "starExtraTime")
    }
}
