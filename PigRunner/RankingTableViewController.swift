//
//  RankingTableViewController.swift
//  PigRunner
//
//  Created by Gustavo Fonseca Olenka on 02/03/17.
//  Copyright © 2017 João Pereira. All rights reserved.
//

import UIKit

class RankingTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // popular array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath)
        
        
        
        
        return cell
    }
}
