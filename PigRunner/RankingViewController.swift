//
//  RankingViewController.swift
//  PigRunner
//
//  Created by Gustavo Fonseca Olenka on 02/03/17.
//  Copyright © 2017 João Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class RankingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fbConnection:FacebookConnection!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingCell
        
        if(fbConnection.friendsPlayingGame[indexPath.row] != nil){
            let name =  fbConnection.friendsPlayingGame[indexPath.row].userFullName
            cell.nameLabel.text = name?.uppercased()
            cell.scoreLabel.text = String(describing: fbConnection.friendsPlayingGame[indexPath.row].userScore!)
            let image = fbConnection.friendsPlayingGame[indexPath.row].userImage
            cell.userImageView.image = image
            cell.position.text = String(indexPath.row + 1)
            
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbConnection.friendsPlayingGame.count
    }
    
    @IBAction func logout(_ sender: Any) {
        self.fbConnection.logoutFacebook()
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current()) != nil {
            fbConnection.getPlayersScore(completion: {(result) ->Void in
                print("total de players" + String(self.fbConnection.friendsPlayingGame.count))
                print("reloading table view\n\n")
                if(self.fbConnection.totalPlayers == self.fbConnection.friendsPlayingGame.count){
                    self.sortByScore()
                    self.userTableView.reloadData()
                }
            })
        }
    }
    
    private func sortByScore(){
        fbConnection.friendsPlayingGame.sort(by: {$0.userScore! > $1.userScore!})
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}
