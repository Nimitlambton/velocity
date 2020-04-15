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
    //MARK:- PROPERTIES
     private let mapView = MKMapView()
    private let  locationManager = CLLocationManager()
   
    private let inputActivationView = LocationInputActiviationView()
    private let locationinputView = LocationInputView()
    
    
    
    //MARK: - LIFECYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  signOut()
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
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.myanchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 80)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        UIView.animate(withDuration: 3) {
            self.inputActivationView.alpha = 1
        }
         
       }
       
    
    func  configuremap(){
      
        view.addSubview(mapView)
         mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        
    }
    
    func configureLocationInputView(){
        
        view.addSubview(locationinputView)
        locationinputView.myanchor(top:view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, height:200 )
        locationinputView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.locationinputView.alpha = 1        }) { _ in
         print("hello")
        }
        
    }
    
    


}


    

  //MARK: -LOCATION SERVICES
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

extension homeController : LocationInputActivationDelegate{
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
      
    }
    
    
    
    
}
