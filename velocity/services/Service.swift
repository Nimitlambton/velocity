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

let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")


struct Service {
//    //static becasue only instance can be created

    static let shared = Service()
    
    
    
func fetchUserData(completion: @escaping(User) -> Void){

    guard  let currentUid = Auth.auth().currentUser?.uid else {return}

    REF_USERS.child(currentUid).observeSingleEvent(of: .value){ (DataSnapshot) in
    guard let dictionary = DataSnapshot.value as? [String:Any] else {return}
    let user = User(dictionary: dictionary)
  
        completion(user)
        
        
        
        }




        }
        
      

    }

    
    


