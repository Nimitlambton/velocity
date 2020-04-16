//
//  User.swift
//  velocity
//
//  Created by Nimit on 2020-04-16.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let fullname: String
    let email : String
    let accountType :Int
    
    //casting data into dictionary
    init(dictionary : [String:Any]) {
        self.fullname = dictionary["fullname"] as? String ?? "madarchod"
        self.email = dictionary["email"] as? String ?? "madarchod"
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
    
}
