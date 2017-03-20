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
  static let KnifesBox: UInt32        = 0b100     // 4
  static let NetTrap: UInt32          = 0b1000    // 8
  static let Hydrant: UInt32          = 0b10000   // 16
  static let BearTrap: UInt32         = 0b100000  // 32
  static let Steamroller: UInt32      = 0b1000000 // 64
  static let Barbecue: UInt32         = 0b10000000 // 128
  static let GarbageCollector: UInt32 = 0b100000000 // 256
  static let Life: UInt32             = 0b1000000000 // 512
  static let Trigger: UInt32          = 0b10000000000 // 1024
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
  case Ob1 = 0
  case Ob2 = 0b1
  case Ob3 = 0b10
  case Ob4 = 0b100
  case Ob5 = 0b1000
  case Ob6 = 0b10000
  case Ob7 = 0b100000
}

struct GameLayer {
  static let Backgorund: CGFloat      = 1
  static let Obstacles: CGFloat       = 2
  static let Player: CGFloat          = 3
  static let WhiteBackground: CGFloat = 4
  static let Interface: CGFloat       = 5
}

let playerVelocityX: Int = 600
let kSpeedMultiplier = 10.0
let playerJumpPower: Float = 1.4
let spikesPercentage: Int = 33
let coinsPercentage: Int = 66
let specialCoinPercentage: Int = 30

// Ground node height (for positioning the blocks correctly on Y axis)
var groundHeight: CGFloat = 0.0

// Screen Dimensions
let kViewSizeWidth: CGFloat = 2208.0
let kViewSizeHeight: CGFloat = 1522.0

// Debug
let kDebug = false
