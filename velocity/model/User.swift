//
//  User.swift
//  velocity
//
//  Created by Nimit on 2020-04-16.
//  Copyright © 2020 Nimit. All rights reserved.
//


import CoreLocation

struct User {
    let fullname: String
    let email : String
    let accountType :Int
    var location : CLLocation?
    var uid: String
   
    
    //casting data into dictionary
    init(uid:String, dictionary : [String:Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? "madarchod"
        self.email = dictionary["email:"] as? String ?? "madarchod"
        self.accountType = dictionary["accountType"] as? Int ?? 1234
    }
    
}
