//
//  Service.swift
//  velocity
//
//  Created by Nimit on 2020-04-16.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
//    //static becasue only instance can be created

    static let shared = Service()
    
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping(String) -> Void){


    REF_USERS.observeSingleEvent(of: .value) { (DataSnapshot) in
            
guard let dictionary = DataSnapshot.value as? [String:Any] else {return}
        
guard let fullname = dictionary["fullname"] as? String else {return}
        
     completion(fullname)
        
        
        
        
        }




        }
        
      

    }

    
    


