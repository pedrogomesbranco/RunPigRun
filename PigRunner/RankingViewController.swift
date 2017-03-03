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
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingCell
        
        
        if(fbConnection.friendsPlayingGame[indexPath.row] != nil){
            cell.nameLabel.text = fbConnection.friendsPlayingGame[indexPath.row].userFullName
            cell.scoreLabel.text = String(describing: fbConnection.friendsPlayingGame[indexPath.row].userScore!)
            cell.userImageView.image = fbConnection.friendsPlayingGame[indexPath.row].userImage
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbConnection.friendsPlayingGame.count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current()) != nil {
            fbConnection.getPlayersScore(completion: {(result) ->Void in
                print("total de players" + String(self.fbConnection.friendsPlayingGame.count))
                print("reloading table view\n\n")
                self.userTableView.reloadData()
            })
        }
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}