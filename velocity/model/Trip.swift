//
//  Trip.swift
//  velocity
//
//  Created by Nimit on 2020-04-21.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import MapKit

enum TripState : Int{

    case requested
    case accepted
    case inProgress
    case completed

}



struct Trip {
    
    var pickupCoordinates : CLLocationCoordinate2D!
    var destinationCoordinates : CLLocationCoordinate2D!
    let passengerUid : String!
    var driverUid : String?
    var state : TripState!
    
    init(passengerUid : String , dictionary : [String: Any]) {
    
        self.passengerUid = passengerUid
 
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray{
            
            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else { return }
            
            guard let long = pickupCoordinates[1] as? CLLocationDegrees else {return}
            
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray{
                 
                 guard let lat = destinationCoordinates[0] as? CLLocationDegrees else { return }
                 
                 guard let long = destinationCoordinates[1] as? CLLocationDegrees else {return}
                 
                 self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                 
             }
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int{
         self.state = TripState(rawValue: state)
        
        }

    }

}



