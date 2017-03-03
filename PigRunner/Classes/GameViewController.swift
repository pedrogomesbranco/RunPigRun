//
//  GameViewController.swift
//  PigRunner
//
//  Created by Joao Pereira on 06/11/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                if kDebug {
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    skView.showsPhysics = true
                }
                
                skView.ignoresSiblingOrder = true
                
                let menuScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
                menuScene.scaleMode = .fill
                let menuTransition = SKTransition.fade(with: UIColor.black, duration: 0.25)
                skView.presentScene(menuScene, transition: menuTransition)
                
                GameTextures.sharedInstance.preloadAssets(completionHandler: { (_) in
                })
            }
        }
    }
        
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
