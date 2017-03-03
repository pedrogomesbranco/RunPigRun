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
    var loginManager:FBSDKLoginManager?
    var userDict: [String: AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
        //Facebook Login
//        if (FBSDKAccessToken.current()) != nil {
//            loginManager = FBSDKLoginManager()
////            fbConnection.getPlayersScore()
//        }
//        else{
////            fbConnection.loginFromViewController(viewController: self)
////            self.loginFromViewController()
//        }
        
//        SpriteKit View Setup
//        if let skView = self.view as? SKView {
//            if skView.scene == nil {
//                if kDebug {
//                    skView.showsFPS = true
//                    skView.showsNodeCouvar= true
//                    skView.showsPhysics = true
//                }
//                
//                skView.ignoresSiblingOrder = true
//                
//                GameTextures.sharedInstance.preloadAssets(completionHandler: { (_) in
//                    let menuScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
//                    menuScene.scaleMode = .fill
//                    menuScene.viewController = self
//                    let menuTransition = SKTransition.fade(with: UIColor.black, duration: 0.25)
//                    
//                    skView.presentScene(menuScene, transition: menuTransition)
//                })
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                if kDebug {
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    skView.showsPhysics = true
                }
                
                skView.ignoresSiblingOrder = true
                
                GameTextures.sharedInstance.preloadAssets(completionHandler: { (_) in
                    let menuScene = MenuScene(size: CGSize(width: kViewSizeWidth, height: kViewSizeHeight))
                    menuScene.scaleMode = .fill
                    let menuTransition = SKTransition.fade(with: UIColor.black, duration: 0.25)
                    menuScene.viewController = self
                    menuScene.fbConnection = self.fbConnection
                    skView.presentScene(menuScene, transition: menuTransition)
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
        return false
    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
    
//    func loginFromViewController(){
//        if(loginManager == nil){
//            loginManager = FBSDKLoginManager.init()
//        }
//        
//        loginManager?.logIn(withReadPermissions: ["email", "public_profile", "user_friends", "user_games_activity"], from: self) {(result,error) in
//            
//            
//            if error != nil{
//                print(error.unsafelyUnwrapped)
//                return
//            }
//            let fbLoginResult: FBSDKLoginManagerLoginResult = result!
//        }
//    }
    
    func showRanking (){
        self.performSegue(withIdentifier: "RankedViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "RankedViewControllerSegue"){
            if let destinationViewController = segue.destination as? RankingViewController{
                destinationViewController.fbConnection = self.fbConnection
            }
        }
    }

}
