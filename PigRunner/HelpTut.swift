//
//  RankingViewController.swift
//  PigRunner
//
//  Created by Gustavo Fonseca Olenka on 02/03/17.
//  Copyright © 2017 João Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class HelpTut: UIViewController{
    
//    var menuScene: MenuScene!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}
