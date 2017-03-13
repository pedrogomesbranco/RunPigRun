//
//  RankingCell.swift
//  PigRunner
//
//  Created by Gustavo Fonseca Olenka on 02/03/17.
//  Copyright © 2017 João Pereira. All rights reserved.
//

import UIKit

class RankingCell : UITableViewCell{
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var position: UILabel!
    
    override func layoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.clipsToBounds = true
    }
}
