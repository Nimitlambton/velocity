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
private let reuseIdentifier = "LocationCell"
class homeController: UIViewController {
    //MARK:- PROPERTIES
     private let mapView = MKMapView()
    private let  locationManager = locationHandler.shared.locationManager
    private let inputActivationView = LocationInputActiviationView()
    private let locationinputView = LocationInputView()
    private final let locationInputViewHeight : CGFloat = 200
    
    private let tabelView = UITableView()

    private var u : User? {
        
        didSet{
            
            locationinputView.user = u
            
        }
    }
    
    //MARK: - LIFECYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOut()
        configureUI()
        configureNavigation()
        checkIFUSerLoggesIn()
        enablelocation()
        view.backgroundColor = .green
        fetchUserData()
        
        
    }
    
    
    
    //MARK: -API
    
    func fetchUserData(){
    
        Service.shared.fetchUserData { user in
            
            self.u = user
        }
}
    
    
    
    
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
        //configure Activation view 
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
        //calling dismiss delegate from locationInputView
        locationinputView.delegate = self
      
        view.addSubview(locationinputView)
        locationinputView.myanchor(top:view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, height:200 )
        locationinputView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.locationinputView.alpha = 1        }) { _ in
        
                UIView.animate(withDuration: 0.5) {
                     self.tabelView.frame.origin.y = self.locationInputViewHeight
                }
                
               
                
        }
        
    }
    
    
    func configureTableView(){
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tabelView.rowHeight = 60
        
        tabelView.tableFooterView = UIView()
        
       let height = view.frame.height - locationInputViewHeight
        tabelView.frame = CGRect(x: 0, y: view.frame.height-300, width: view.frame.width, height: height)
        tabelView.backgroundColor = .red
        view.addSubview(tabelView)
        
    
    }
    
    
    
    }


    

  //MARK: -LOCATION SERVICES
extension homeController {
   
    func enablelocation(){
       
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
 
    
    
}

//MARK: - extension homeController : LocationInputActivationDelegate
extension homeController : LocationInputActivationDelegate{
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
        configureTableView()
      
    }
}


//MARK: - extension homeController : LocationInputViewDelegate
extension homeController : LocationInputViewDelegate{
    func DismissInputview() {
        
        
        locationinputView.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.locationinputView.alpha = 0
            self.tabelView.frame.origin.y = self.view.frame.height
        }) {_ in
            
            self.inputActivationView.alpha = 1
        }
    }
    

}


//MARK: - TableView Extension
   
extension homeController : UITableViewDelegate ,UITableViewDataSource{

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "testing"
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! LocationCell
       
        return cell
    }
    
   
    
       
       
       
       
   }
