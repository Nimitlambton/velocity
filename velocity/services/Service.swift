//
//  Service.swift
//  velocity
//
//  Created by Nimit on 2020-04-16.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")

//to fetch userData

struct Service {
//    //static becasue only instance can be created

    static let shared = Service()
 
    func fetchUserData(uid : String,  completion: @escaping(User) -> Void){
    REF_USERS.child(uid).observeSingleEvent(of: .value){ (DataSnapshot) in
    
    guard let dictionary = DataSnapshot.value as? [String:Any] else {return}
    
    let uid = DataSnapshot.key
    let user = User(uid: uid, dictionary: dictionary)
    completion(user)
       
        }
}
    
    
        func fetchDrivers (location: CLLocation , completion:@escaping(User) -> Void){
            let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS )


  REF_DRIVER_LOCATIONS.observe(.value) { (DataSnapshot) in
                
  geofire.query(at: location, withRadius: 50).observe(.keyEntered, with:{ (uid ,location)   in
                
                    print("r::\(location)")
                    print("r::\(uid)")
               

                    self.fetchUserData(uid: uid) { (User) in
                    var driver = User
                    driver.location = location
                    completion(driver)
    
    
    }
                    
                    
                    
                    
                })

            }
            
            
    }
            
            
            
    
    
    
    
    
    
    
    
    
    
    
//    func fetchDrivers (location: CLLocation , completion:  @escaping(User) -> Void ){
//
//    //when we inialize geo fire we have to give firebase Database refrence
//
//        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS )
//
//        REF_DRIVER_LOCATIONS.observe(.value) { (DataSnapshot) in
//geofire.query(at: location, withRadius: 50).observe(.keyEntered ,
//                with: { (uid, location) in
//
//                print(uid)
//                print(location.coordinate)
//
//                    self.fetchUserData(uid: uid) { (User) in
//
//                        var driver = User
//                        driver.location = location
//                        completion(User)
//
//                    }
//
//            })
//        }
//
//    }




}

    
    


