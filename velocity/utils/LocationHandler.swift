//
//  LocationHandler.swift
//  velocity
//
//  Created by Nimit on 2020-04-16.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import CoreLocation

//centalizing locations 
class locationHandler: NSObject , CLLocationManagerDelegate {
    
    
    static let shared  = locationHandler()
    
    var locationManager = CLLocationManager()
    
     var location : CLLocation?
    
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status  == .authorizedWhenInUse{
        locationManager.requestWhenInUseAuthorization()

        }
    }
    
    
}
