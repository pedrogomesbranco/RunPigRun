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
import FBSDKLoginKit


class GameViewController: UIViewController {
    
    //Facebook Login Management
    // MARK: - Facebook
    var fbConnection = FacebookConnection()
    
    // MARK: - Scene Configuration
    var skView : SKView?
    var menuScene : MenuScene?
    var menuTransition : SKTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScene()
    }
    
    private func prepareScene(){
        skView = self.view as? SKView
        
        if skView?.scene == nil {
            if kDebug {
                skView?.showsFPS = true
                skView?.showsNodeCount = true
                skView?.showsPhysics = true
            }
            
            skView?.ignoresSiblingOrder = true
            skView?.sizeToFit()
            
            self.menuScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
            menuScene?.scaleMode = .fill
            menuScene?.fbConnection = self.fbConnection
            menuScene?.viewController = self
            
            self.menuTransition = SKTransition.fade(with: UIColor.black, duration: 0.25)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GameTextures.sharedInstance.preloadAssets(completionHandler: { (_) in
            self.skView?.presentScene(self.menuScene!)
        })
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
    
    func showRanking (){
        self.performSegue(withIdentifier: "RankedViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "RankedViewControllerSegue"){
            if let destinationViewController = segue.destination as? RankingViewController{
                destinationViewController.fbConnection = self.fbConnection
                destinationViewController.menuScene = self.menuScene
            }
        }
    }
}
