
//
//  Drivers.swift
//  velocity
//
//  Created by Nimit on 2020-04-17.
//  Copyright © 2020 Nimit. All rights reserved.
//
import MapKit
class  DriverAnnotation : NSObject , MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var uid : String
 
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid  = uid
        self.coordinate = coordinate
    }
    
}
