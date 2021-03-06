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
let REF_TRIPS = DB_REF.child("trips")


//to fetch userData



struct DriverServices {
    static let shared = DriverServices()


    
       //observing trips wherever added
        
        func observeTrips(completion: @escaping(Trip) -> Void){
            REF_TRIPS.observe(.childAdded){ (DataSnapshot) in
                
    guard let dictionary = DataSnapshot.value as? [String: Any] else {return}
                
        let uid = DataSnapshot.key
        let trip = Trip(passengerUid: uid , dictionary: dictionary)
     
                print("pid \(trip.destinationCoordinates)")

                completion(trip)
            }

        }

    
    //when we remove , we listen to this.
      
      
      func observeTripCancelled(trip : Trip , completion : @escaping() -> Void){
          REF_TRIPS.child(trip.passengerUid).observeSingleEvent(of: .childRemoved) {_ in
          print("remove")
            completion()
            
          
          }

              print(trip.passengerUid)

          }
          
    
    //accept trip
    
    func acceptTrip(trip : Trip , completion: @escaping(Error? , DatabaseReference) -> Void ){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["driverUid": uid ,"state": TripState.accepted.rawValue ] as [String : Any]
     
        REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
        
        
    }


    func updateTripState(trip: Trip , state: TripState, completion: @escaping(Error? , DatabaseReference) -> Void) {

        
        REF_TRIPS.child(trip.passengerUid).child("state").setValue(state.rawValue, withCompletionBlock: completion)
        
        if state == .completed {
            
            REF_TRIPS.child(trip.passengerUid).removeAllObservers()
            
        }
        
        
    }

    
    func updateDriverLocations(location: CLLocation){
        
        
      guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        geofire.setLocation(location, forKey: uid)

    }

    
    
    
    



}







struct PassengerServices {
    
    static let shared = PassengerServices()
    
    
    
    
     func fetchDrivers (location :CLLocation ,  completion : @escaping (User) -> Void ){

    let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
            
     REF_DRIVER_LOCATIONS.observe(.value) { (DataSnapshot) in
                
        geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: {(uid, location) in
            
            print("bcbc: \( uid)")
            print("bcbc:+\(location.coordinate)")
       
            Service.shared.fetchUserData(uid: uid) { (User) in
               
                var driver = User
                driver.location = location
                completion(driver)
            }

        }

            )}

        }
    
    
    
    
    
    func uploadTrip(_ pickupCoordinates : CLLocationCoordinate2D , _ destinationCoordinates: CLLocationCoordinate2D,  completion: @escaping(Error? ,DatabaseReference) -> Void ){

        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        let pickupArray = [pickupCoordinates.latitude , pickupCoordinates.longitude]
     
        let destinationArray =  [destinationCoordinates.latitude , destinationCoordinates.longitude ]
        
    let values = ["pickupCoordinates":pickupArray,"destinationCoordinates" : destinationArray, "state" : TripState.requested.rawValue  ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        
       print("r::")
    }

    
    //observetrips
     
     func observeCurrentTrip(completion: @escaping(Trip) -> Void){
         
         guard let uid = Auth.auth().currentUser?.uid else {return}
         
         REF_TRIPS.child(uid).observe(.value) { (DataSnapshot) in

             guard let dictionary = DataSnapshot.value as? [String: Any] else {return}
             let uid = DataSnapshot.key
             let trip = Trip(passengerUid: uid , dictionary: dictionary)
             completion(trip)

         }

     }
    
    
    
    
       func deleteTrip(completion :   @escaping(Error? , DatabaseReference) -> Void ){
            
            
             guard let uid = Auth.auth().currentUser?.uid else {return}
             REF_TRIPS.child(uid).removeValue (completionBlock: completion)
            

    }
    
    
    
    func saveLocation(locationString : String , type : locationTtype, completion: @escaping (Error? , DatabaseReference) -> Void  ) {
        
         guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let key : String = type == .home ? "homelocation" : "worklocation"
        
        REF_USERS.child(uid).child(key).setValue(locationString , withCompletionBlock: completion)
        
        
        
    }
    
    
    
    
    
}

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

}



    
    
    
    
    
    
 
        
  
    
    


    
    


