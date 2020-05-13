//
//  User.swift
//  velocity
//
//  Created by Nimit on 2020-04-16.
//  Copyright © 2020 Nimit. All rights reserved.
//


import CoreLocation

enum AccountType : Int {
    case passanger
    case driver
}


struct User {
   
    let fullname: String
    let email : String
    var accountType :AccountType!
    var location : CLLocation?
    var uid: String
    
    var worklocation : String?
    var homelocation :String?
   
    
    //casting data into dictionary
    init(uid:String, dictionary : [String:Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? "madarchod"
        self.email = dictionary["email:"] as? String ?? "madarchod"
        
        
        
      if let home = dictionary["homelocation"] as? String {
            self.homelocation = home
        }
        
        
         
       if let work = dictionary["worklocation"] as? String {
                   self.worklocation = work
               }
    
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
        
    }
    
}
