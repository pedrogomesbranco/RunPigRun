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

class FacebookConnection{
    var loggedUser: FacebookUser?
    var friendsPlayingGame = [FacebookUser]()
    var loginManager:FBSDKLoginManager?
    var totalPlayers : Int!
    
    // Await Get Players Score
    func getPlayersScore(completion: @escaping (_ result: ()) -> Void){
        if(FBSDKAccessToken.current() != nil){
            let req = FBSDKGraphRequest(graphPath:  "/" + FBSDKSettings.appID() + "/scores", parameters: ["fields": "score,user,picture"], httpMethod: "GET")
            
            req?.start(completionHandler: {(connection, result, error)->Void in
                if error != nil{
                    print(error!)
                    return
                }
                
                if(self.friendsPlayingGame.count != 0){
                    self.friendsPlayingGame.removeAll()
                }
                
                let resultdict = result as! NSDictionary!
                let data : NSArray = resultdict!.object(forKey: "data") as! NSArray
                self.totalPlayers = data.count
                //                prints JSON with all players
                //                print(data.description)
                
                for i in 0 ..< data.count{
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let userDic = valueDict["user"] as! [String: AnyObject]
                    
                    // Getting user information treatment
                    
                    
                    self.getUserPicture(fbUserID: userDic["id"] as! String!, completion: {(result) -> Void in
                        let user = FacebookUser()
                        
                        user.userId = (userDic["id"] as! String!)
                        user.userFullName = (userDic["name"] as! String!)
                        user.userScore = (valueDict["score"] as! Int!)
                        user.userImage = result
                        
                        self.friendsPlayingGame.append(user)
                        
                        if(FBSDKAccessToken.current().userID == user.userId){
                            self.loggedUser = user
                        }
                        completion()
                    })
                    
                    
                    
                }
            })
            
        }
    }
    
    // Await Get User Profile Picture
    private func getUserPicture(fbUserID:String, completion:@escaping (_ result: UIImage) -> Void){
        
        if(FBSDKAccessToken.current() != nil){
            let req = FBSDKGraphRequest(graphPath:  "/" + fbUserID, parameters: ["fields": "picture"], httpMethod: "GET")
            
            req?.start(completionHandler: {(connection, result, error)->Void in
                if error != nil{
                    print(error!)
                    return
                }
                let resultdict = result as! NSDictionary! // transform result JSON in dictionary
                let pictureData = resultdict?.object(forKey: "picture") as! NSDictionary! // transform pictureData JSON in dictionary
                let data = pictureData?.object(forKey: "data") as! NSDictionary! // transform Data JSON in dictionary
                let imageURL = data?.object(forKey: "url") as! String! // transform image url JSON in string
                
                let urlString = imageURL!
                let url = URL(string: urlString)!
                let imageData = try? Data(contentsOf: url)
                //
                if imageData != nil {
                    //                    fbUser.userImage = UIImage(data: imageData!)!
                    completion(UIImage(data: imageData!)!)
                }
                else {
                    print("error loading image")
                }
                
                
            })
        }
    }
    
    // Updates player highest score on Facebook Database
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
    
    func getUserScore(completion: () -> Void){
        if(FBSDKAccessToken.current() != nil){
            let req = FBSDKGraphRequest(graphPath:  "/" + FBSDKSettings.appID() + "/scores", parameters: ["fields": "score,user"], httpMethod: "GET")
            
            req?.start(completionHandler: {(connection, result, error)->Void in
                if error != nil{
                    print(error!)
                    return
                }
                
                if(self.friendsPlayingGame.count != 0){
                    self.friendsPlayingGame.removeAll()
                }
                
                let resultdict = result as! NSDictionary!
                let data : NSArray = resultdict!.object(forKey: "data") as! NSArray
                self.totalPlayers = data.count
                //                prints JSON with all players
                //                print(data.description)
                
                for i in 0 ..< data.count{
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let userDic = valueDict["user"] as! [String: AnyObject]
                    
                    // Getting user information treatment
                    
                    
                    let user = FacebookUser()
                    
                    user.userId = (userDic["id"] as! String!)
                    user.userFullName = (userDic["name"] as! String!)
                    user.userScore = (valueDict["score"] as! Int!)
                    
                    self.friendsPlayingGame.append(user)
                        
                    if(FBSDKAccessToken.current().userID == user.userId){
                        self.loggedUser = user
                    }

                    
                }
            })
            
        }
    }
    
    // Request User Login to Facebook, from a View Controller
    func loginFromViewController(viewController: UIViewController, completion: @escaping () -> Void){
        if(loginManager == nil){
            loginManager = FBSDKLoginManager.init()
        }
        loginManager?.logIn(withReadPermissions: ["email", "public_profile", "user_friends", "user_games_activity"], from: viewController) { (result,error) in
            
            if error != nil{
                print(error.unsafelyUnwrapped)
                return
            }
            let fbLoginResult: FBSDKLoginManagerLoginResult = result!
            //            print(fbLoginResult.grantedPermissions)
            completion()
        }
    }

    
    // Request permission to access user's friends that play the game, from a View Controller
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
    
    // Request user permission to write his records in Facebook database, from a View Controller
    func requestWritePermissionFromViewController(viewController: UIViewController, completion: @escaping () -> Void){
        if(loginManager == nil){
            loginManager = FBSDKLoginManager.init()
        }
        
        loginManager?.logIn(withPublishPermissions: ["publish_actions"], from: viewController) { (result,error) in
            if error != nil{
                print(error.unsafelyUnwrapped)
                return
            }
            let fbLoginResult: FBSDKLoginManagerLoginResult = result!
            print(result!.grantedPermissions)
            print(result!.grantedPermissions.description)
            UserDefaults.standard.set(true, forKey: "PublishPermission")
            print(fbLoginResult.grantedPermissions)
            completion()
        }
    }
    
    // Logout from Facebook
    func logoutFacebook(completion:() -> Void){
        if(loginManager == nil){
            loginManager = FBSDKLoginManager.init()
        }
        loginManager?.logOut()
        completion()
    }
}
