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
private let annotationIdentifier  = "DriverAnnotation"
class homeController: UIViewController {
    
    func executeSearch(query: String) {
           
        searchBy(naturalLanguageQuery: query) { (Placemark) in
            print("did complete\(Placemark)")
            self.searchresult = Placemark
            self.tabelView.reloadData()
        }

    }
    
    
    
    
    //MARK:- PROPERTIES
     private let mapView = MKMapView()
    private let  locationManager = locationHandler.shared.locationManager
    private let inputActivationView = LocationInputActiviationView()
    private let locationinputView = LocationInputView()
    private final let locationInputViewHeight : CGFloat = 200
    private var searchresult = [MKPlacemark]()
    private let tabelView = UITableView()

    private var u : User? {
        
        didSet{
            locationinputView.user = u
        }
    }
    
    //MARK: - LIFECYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // signOut()
        configureUI()
        configure()
        configureNavigation()
        checkIFUSerLoggesIn()
        enablelocation()
        view.backgroundColor = .green
       
    
    
    }
    
    
    
    //MARK: -API
    

    func fetchDrivers(){

        guard let location = locationManager.location else {return}
        print("nkdsa\(location)")
        Service.shared.fetchDrivers(location: location) { (driver) in
            
            guard let coordinate = driver.location?.coordinate else {return}

         let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
              
            
            print("update\(coordinate)")
            
            
            var driverIsVisible : Bool{
                
                
                return self.mapView.annotations.contains { (annotation) -> Bool in
    
    guard let driveranon = annotation as? DriverAnnotation else {return false}

      if driveranon.uid == driver.uid {
                       
    
        driveranon.updateAnnotationPosition(withCoordinate: coordinate)
        
        
        
        return true}
        return false
                }
                
            }

          //  print("nkdsa: \(driver.fullname)" )
            //print("nkdsa: \(driver.location)" )
       
            
            if !driverIsVisible{
                
              self.mapView.addAnnotation(annotation)
            
            
            }
            
           
            
        
        }


    }
//
    
    
    func fetchUserData(){
        
        guard  let uid = Auth.auth().currentUser?.uid else {return }
        Service.shared.fetchUserData(uid: uid) { user in
            self.u = user
        }
}

    
    func  checkIFUSerLoggesIn()  {
        
       
        if Auth.auth().currentUser?.uid == nil {
        let controller = loginController()
        navigationController?.pushViewController(controller, animated: true)
        }
        else{
          configure()
            
            
        }
    }
    

    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch let error {

            print("error occurs")
        }

        }
        
    
    
    //to hide navigation bar
        func configureNavigation(){
                 navigationController?.navigationBar.isHidden = true
             }

    //MARK: - Helper Functions
    
    
    func dismissLocationViw(comp: ((Bool) -> Void)? = nil ){
        UIView.animate(withDuration: 0.3, animations: {
                         UIView.animate(withDuration: 0.6, animations: {
                           self.locationinputView.alpha = 0
                           self.tabelView.frame.origin.y = self.view.frame.height
                           self.inputActivationView.alpha = 1
                         })
        }, completion: comp)
  
        
    }
       
    
    
    
    
    func configure(){
        
        configureUI()
        fetchUserData()
               fetchDrivers()
    }
   
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
    
        mapView.delegate = self
    
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
        
       dismissLocationViw()
      
    }
    

}


//MARK: - TableView Extension
   
extension homeController : UITableViewDelegate ,UITableViewDataSource{

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "testing"
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        
        return  searchresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! LocationCell
        
        if indexPath.section == 1{
        cell.placemark = searchresult[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissLocationViw { _ in
            let selectedPlacemark = self.searchresult[indexPath.row]
            print(selectedPlacemark.address)
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    
    
    
   }

extension homeController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if let annotation = annotation as? DriverAnnotation {
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
    return nil
    }
    
    
}



private extension homeController {

               func searchBy(naturalLanguageQuery : String , completion : @escaping([MKPlacemark]) ->Void){
                   
                   var result = [MKPlacemark]()
                
                
                let request = MKLocalSearch.Request()
                
                request.region = mapView.region
                request.naturalLanguageQuery = naturalLanguageQuery
                
                let search = MKLocalSearch(request: request)
            
                search.start { (Response , Error) in
                    
                    guard let response = Response else {return}
                    
                    response.mapItems.forEach { (Item) in
                       // print("de\(Item.phoneNumber)")
                        result.append(Item.placemark)
                    }
                
                      completion(result)
                
                }
              
                
                

                   
               }
    
    
    
}
