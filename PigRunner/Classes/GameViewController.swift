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
        
        // Verifica se é a primeira vez do usuario no app
        if UserDefaults.standard.value(forKey: "high") == nil{
            UserDefaults.standard.set(0, forKey: "high")
        }
        
        // Verifica se o usuario está conectado com facebook e recupera seus dados
        if FBSDKAccessToken.current() != nil {
            fbConnection.getUserScore(completion: {})
        }
        
        // Verifica se tem permissao para publicar score
        if FBSDKAccessToken.current() != nil {
            if (UserDefaults.standard.value(forKey: "PublishPermission") == nil ){
                UserDefaults.standard.set(false, forKey: "PublishPermission")
            }
        }
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
            self.skView?.presentScene(self.menuScene!)
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
    
//    func showRanking (){
//        self.performSegue(withIdentifier: "RankedViewControllerSegue", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "RankedViewControllerSegue"){
//            if let destinationViewController = segue.destination as? RankingViewController{
//                destinationViewController.fbConnection = self.fbConnection
//                destinationViewController.menuScene = self.menuScene
//            }
//        }
//    }
}
