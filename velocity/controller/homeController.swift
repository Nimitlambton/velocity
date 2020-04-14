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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configureNavigation()
        //signOut()
        checkIFUSerLoggesIn()
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
           
           view.addSubview(mapView)
           mapView.frame = view.frame
       }
       
    
    }
    

  

