//
//  Star.swift
//  PigRunner
//
//  Created by Joao Pereira on 09/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

//
//  Coin.swift
//  PigRunner
//
//  Created by Joao Pereira on 23/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import SpriteKit

class Star: SKSpriteNode {
    // MARK: - Properties
    var nodeWidth: CGFloat = 0.0
    var nodeToSpawn: SKSpriteNode!
    
    // MARK: - Methods
    func collected() {
        let shrinkAction = SKAction.scale(to: 0.0, duration: 0.03)
        
        self.run(shrinkAction, completion: {
            self.removeFromParent()
        })
    }
}
