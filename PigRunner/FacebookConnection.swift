//
//  FacebookConnection.swift
//  PigRunner
//
//  Created by Gustavo Fonseca Olenka on 12/12/16.
//  Copyright © 2016 João Pereira. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import UIKit

// TODO 
//
// SET PLISTS TO ENABLE FACEBOOK LOGIN
//
// SET NECESSARY CONFIGURATION IN APP DELEGATE
//
// END TODO


internal class User{
    var userId: String?
    var userFullName: String?
    var userScore: Int?
    var userImage: UIImage?
    
    init(){}
    
    init(id: String, fullName: String, score: Int, image: UIImage){
        self.userId = id
        self.userFullName = fullName
        self.userScore = score
        self.userImage = image
    }
}



class FacebookConnection{
    var loggedUser: User?
    var friendsPlayingGame: [User]?
    var loginManager:FBSDKLoginManager?

    
    // Load loggedUser information and all his friends playing the game, inside friendsPlayingGame variable (loggedUser is included in array)
    func getPlayersScore(){
        if(FBSDKAccessToken.current() != nil){
            let req = FBSDKGraphRequest(graphPath:  "/" + FBSDKSettings.appID() + "/scores", parameters: ["fields": "score,user"], httpMethod: "GET")
    
            req?.start(completionHandler: {(connection, result, error)->Void in
                if error != nil{
                    print(error!)
                    return
                }
                
                if(self.friendsPlayingGame?.count != 0){
                    self.friendsPlayingGame?.removeAll()
                }
                
                let resultdict = result as! NSDictionary!
                let data : NSArray = resultdict!.object(forKey: "data") as! NSArray
                print(data.description)
                
                
                for i in 0 ..< data.count
                {
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let userDic = valueDict["user"] as! [String: AnyObject]
                    
                    // Getting user information treatment
                    let user = User()
                    
                    user.userId = (userDic["id"] as! String)
                    user.userFullName = (userDic["name"] as! String)
                    user.userScore = (valueDict["score"] as! Int)
                    
                    // Image treatment
                    let urlString = ((valueDict["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"] as! String
                    
                    let url = URL(string: urlString)!
                    let imageData = try? Data(contentsOf: url)
                    
                    if imageData != nil {
                        user.userImage = UIImage(data: imageData!)!
                    } else {
                        print("error loading image")
                    }

                    self.friendsPlayingGame?.append(user)
                    
                    //If is loggedUser
                    if(FBSDKAccessToken.current().userID == user.userId){
                        self.loggedUser = user
                    }
                }
                
            })
        }
    }
    
    // Updates player highest score on Facebook
    func sendScore(score: Int){
        if(FBSDKAccessToken.current() != nil) {
            if (score > self.loggedUser!.userScore!) {
                let scoreString = String(score)
                // Update highest score in Facebook Storage
                let req = FBSDKGraphRequest(graphPath:  "/" + "me" + "/scores", parameters: ["score": scoreString], httpMethod: "POST")
                req?.start(completionHandler: {(connection, result, error)->Void in
                    if error != nil{
                        print(error!)
                        return
                    }
                    print("score updated")
                })
            }
        }
    }
    
    
    func loginFromViewController(viewController: UIViewController){
        if(loginManager == nil){
            loginManager = FBSDKLoginManager.init()
        }
        loginManager?.logIn(withReadPermissions: ["email", "public_profile", "user_friends", "user_games_activity"], from: viewController) { (result,error) in
            
            if error != nil{
                print(error.unsafelyUnwrapped)
                return
            }
            let fbLoginResult: FBSDKLoginManagerLoginResult = result!
            print(fbLoginResult.grantedPermissions)
        }
    }
    
    func requestFriendPermissionFromViewController(viewController: UIViewController){
        if(loginManager == nil){
            loginManager = FBSDKLoginManager.init()
        }
        
        loginManager?.logIn(withReadPermissions: ["user_friends"], from: viewController) { (result,error) in
            if error != nil{
                print(error.unsafelyUnwrapped)
                return
            }
            let fbLoginResult: FBSDKLoginManagerLoginResult = result!
            print(fbLoginResult.grantedPermissions)
        }
    }
    
    func requestWritePermissionFromViewController(viewController: UIViewController){
        if(loginManager == nil){
            loginManager = FBSDKLoginManager.init()
        }
        
        loginManager?.logIn(withPublishPermissions: ["publish_actions"], from: viewController) { (result,error) in
            if error != nil{
                print(error.unsafelyUnwrapped)
                return
            }
            let fbLoginResult: FBSDKLoginManagerLoginResult = result!
            print(fbLoginResult.grantedPermissions)
        }
    }
    
}
