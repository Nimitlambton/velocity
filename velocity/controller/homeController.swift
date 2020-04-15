//
//  homeController.swift
//  velocity
//
//  Created by Nimit on 2020-04-14.
//  Copyright © 2020 Nimit. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class homeController: UIViewController {

     private let mapView = MKMapView()
    private let  locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
     // signOut()
        configureUI()
        configureNavigation()
        checkIFUSerLoggesIn()
        enablelocation()
        view.backgroundColor = .green
        
        
    }
    
    
    
    //MARK: -API
    
    func  checkIFUSerLoggesIn()  {
        
       
        if Auth.auth().currentUser?.uid == nil {
  
                let controller = loginController()
                  
                  navigationController?.pushViewController(controller, animated: true)
            
        
        }
        else{
            
           configureUI()
            
        }
        
    }
    
    func signOut(){
        do{
        
            try Auth.auth().signOut()
        }catch let error {
            
            print("error occurs")
            
        }
        
            
        }
        
        
        func configureNavigation(){
                 navigationController?.navigationBar.isHidden = true
             }
    
    
    
    
    //MARK: - Helper Functions
       
   
       func configureUI(){
           
         configuremap()
       }
       
    
    func  configuremap(){
      
        view.addSubview(mapView)
         mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        
    }


}


    

  
extension homeController :CLLocationManagerDelegate{
    
    
    
    
    
    func enablelocation(){
        
        locationManager.delegate = self
      
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
       print("notDetermined")
       locationManager.requestWhenInUseAuthorization()
    case .authorizedAlways:
       locationManager.requestWhenInUseAuthorization()
       locationManager.startUpdatingLocation()
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("authorizedAlways")
        case .authorizedWhenInUse:
        print("authorizedWhenInUse")
    locationManager.requestWhenInUseAuthorization()
        case .denied:
            break;
        case .restricted:
            break;
        @unknown default:
            break
        }
        
    }
 
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status  == .authorizedWhenInUse{
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
}
