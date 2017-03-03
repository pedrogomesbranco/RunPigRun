//
//  FacebookUser.swift
//  PigRunner
//
//  Created by Gustavo Fonseca Olenka on 02/03/17.
//  Copyright © 2017 João Pereira. All rights reserved.
//

import Foundation
import UIKit

class FacebookUser{
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
