//
//  Constants.swift
//  PigRunner
//
//  Created by Joao Pereira on 07/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit
import Foundation

struct ColliderType {
    static let None: UInt32             = 0
    static let Player: UInt32           = 0b1       // 1
    static let Ground: UInt32           = 0b10      // 2
    static let CoinNormal: UInt32       = 0b100     // 4
    static let CoinSpecial: UInt32      = 0b1000    // 8
    static let Spikes: UInt32           = 0b10000   // 16
    static let Trigger: UInt32          = 0b100000  // 32
    static let SpinningWheel: UInt32    = 0b1000000 // 64
    static let Magnet: UInt32           = 0b10000000 // 128
    static let MagneticField: UInt32    = 0b100000000 // 256
    static let GarbageCollector: UInt32 = 0b1000000000 // 512
}

enum CoinBlock: UInt32 {
    case Arrow          = 0
    case SpecialArrow   = 0b1   // 1
    case Smile          = 0b10  // 2
}

enum CoinType: UInt32 {
    case Normal         = 0
    case Special        = 0b1   // 1
}

enum BlockType: UInt32 {
    case SmileAndTrigger        = 0
    case TwoTriggers            = 0b1
    case SpikesAndCoins         = 0b10
}

struct GameLayer {
    static let Interface: CGFloat = 5
}

let playerVelocityX: Int = 700
let kSpeedMultiplier = 10.0
let playerJumpPower: Float = 1.5
let spikesPercentage: Int = 33
let coinsPercentage: Int = 66
let specialCoinPercentage: Int = 30

// Screen Dimensions
let kViewSizeWidth: CGFloat = 2208.0
let kViewSizeHeight: CGFloat = 1522.0

// Debug
let kDebug = false
