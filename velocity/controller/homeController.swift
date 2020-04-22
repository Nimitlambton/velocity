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


private enum ActionButtonConfiguration{
    
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
    
}

class homeController: UIViewController {
    
    func executeSearch(query: String) {
           
        searchBy(naturalLanguageQuery: query) { (Placemark) in
            //print("did complete\(Placemark)")
            self.searchresult = Placemark
            self.tabelView.reloadData()
        }

    }
    
    
    
    
    //MARK:- PROPERTIES
    private let mapView = MKMapView()
    private let  locationManager = locationHandler.shared.locationManager
    private let inputActivationView = LocationInputActiviationView()
   
    private let rideActionView = RideActivationView()
    
    private let locationinputView = LocationInputView()
    private final let locationInputViewHeight : CGFloat = 200
    private final let rideActionViewHeight : CGFloat = 300
    private var searchresult = [MKPlacemark]()
    private let tabelView = UITableView()
    private var actionButtonConfig = ActionButtonConfiguration()
    private var route : MKRoute?
    
    
    
    private var user : User? {
        didSet{
            locationinputView.user = user
          
            if user?.accountType == .passanger {
            print("its passenger")
                fetchDrivers()
                configureInputActivationView()
                observeCurrentTrip()
            }else{
                 
                Service.shared.observeTrips { (Trip) in
                    self.trip = Trip
                }
            }
        }
    }
    
    
    private var trip : Trip? {
        didSet{
            
            guard let user = user else {return}
            
            if user.accountType == .driver{
                guard let trip = trip else {return }
                      let controller = PickUpController(trip: trip)
                      controller.delegate = self
                      self.present(controller , animated: false)
            }else {
                print("showAt")
            }
        }
        
    }
   
    
    private let actionButton :UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(actionButoonPressed), for: .touchUpInside)
          return button
    }()
    
    
    //MARK: - LIFECYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  signOut()
        configureUI()
        configure()
        configureNavigation()
        checkIFUSerLoggesIn()
        enablelocation()
        view.backgroundColor = .green
        configureRideActionView()
        self.animateRideActionView(shouldShow: false)
       
  
    }

    
    //MARK: SELECTORS
    
    
    
    
    @objc func actionButoonPressed(){
        
        switch actionButtonConfig {
        case .showMenu:
            print("abc")
        case .dismissActionView:
           removeAnotationAndOverlays()
        mapView.showAnnotations(mapView.annotations, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
                self.configureActionButton(config: .showMenu)
                self.animateRideActionView(shouldShow: false)
                
            }
      
            
        }
        
    }
    
    
    
    
    //MARK: -API
    
    func observeCurrentTrip(){
        
        Service.shared.observeCurrentTrip { Trip in
            self.trip = Trip
       
            if Trip.state == .accepted {
                
                self.shouldPresnetLoadingView(false)
                
            }
        
        }
           
           
       }

    
    
    
    
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

            if !driverIsVisible{
                
              self.mapView.addAnnotation(annotation)
            
            
            }
            
           
            
        
        }


    }
//
    
    
    func fetchUserData(){
        
        guard  let uid = Auth.auth().currentUser?.uid else {return }
        Service.shared.fetchUserData(uid: uid) { user in
            self.user = user
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
    
    func animateRideActionView(shouldShow : Bool , destination: MKPlacemark? = nil ){
            
      let yorigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight :
          
          self.view.frame.height

              if shouldShow{
                guard let destination = destination else {return}
                  rideActionView.destination = destination
              }
              UIView.animate(withDuration: 0.3) {
                  
               self.rideActionView.frame.origin.y = yorigin
             
              }
              }
    
    
    
    

    func removeAnotationAndOverlays(){

        mapView.annotations.forEach { (annotation) in
                  if let annon = annotation as? MKPointAnnotation{
                      
                      mapView.removeAnnotation(annon)
                  }
              }
        
        if mapView.overlays.count > 0{
            mapView.removeOverlay(mapView.overlays[0])
        }
        
    }
    
   fileprivate func configureActionButton(config: ActionButtonConfiguration){
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
            self.actionButtonConfig = .showMenu

        case .dismissActionView:
        
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1"), for: .normal)
            actionButtonConfig = .dismissActionView
        
        }
        
        
    }
    
    
    func dismissLocationViw(comp: ((Bool) -> Void)? = nil ){
        UIView.animate(withDuration: 0.3, animations: {
                         UIView.animate(withDuration: 0.6, animations: {
                           self.locationinputView.alpha = 0
                           self.tabelView.frame.origin.y = self.view.frame.height
                       
                         })
        }, completion: comp)
  
        
    }
       
    
    
    
    
    func configure(){
        
        configureUI()
        fetchUserData()
      //  fetchDrivers()
    }
   
       func configureUI(){
        configuremap()
        //HamBurger menu
        
        view.addSubview(actionButton)
        actionButton.myanchor(top: view.safeAreaLayoutGuide.topAnchor ,  left:view.leftAnchor , paddingTop: 16 , paddingLeft: 16 , width: 30 , height: 30 )
      
         
       }
    
    
    func configureInputActivationView(){
        
        view.addSubview(inputActivationView)
              inputActivationView.centerX(inView: view)
              inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
              inputActivationView.myanchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 80)
             // inputActivationView.alpha = 0
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
    
    
    func configureRideActionView(){
           
           view.addSubview(rideActionView)
           rideActionView.delegate = self
           rideActionView.frame = CGRect(x: 0, y: view.frame.height-300, width: view.frame.width , height: 300)
        
           
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
        
        dismissLocationViw {_ in
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
       let selectedPlacemark = searchresult[indexPath.row]
        configureActionButton(config: .dismissActionView)

        dismissLocationViw { _ in
         
                let desination = MKMapItem(placemark: selectedPlacemark)
                self.generatePolyline(toDestination: desination )
                //print(selectedPlacemark.address)
                let annotation = MKPointAnnotation()
                annotation.coordinate = selectedPlacemark.coordinate
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                
                let annontations = self.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self)})
            self.mapView.showAnnotations(annontations, animated: true)
                self.animateRideActionView(shouldShow: true,destination:  selectedPlacemark)
        }
        
        
    
        
    }
    
    
    
    
   }

//MARK: MAPVIEW DELEGATE
extension homeController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if let annotation = annotation as? DriverAnnotation {
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
    return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let router = self.route {
           
            let polyline = route?.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline as! MKOverlay)
            lineRenderer.strokeColor = .orange
            lineRenderer.lineWidth = 4
            return lineRenderer
        }
        return MKOverlayRenderer()
    }
    
}


//MARK: MapView helper functions

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
    
    func generatePolyline(toDestination destination :MKMapItem){
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { (Response, Error) in
            guard let Response = Response else {return }
            self.route = Response.routes[0]
            guard let polyline = self.route?.polyline else {return }
            self.mapView.addOverlay(polyline)
        }
        
    }
    
}

    //MARK: -  homeController : rideActivityDelegate

extension homeController : rideActivityDelegate{
    func uploadTrip(_ View: RideActivationView) {
    
        shouldPresnetLoadingView(true , message: "hella ! wait , finding you a ride ")
        guard let pickupCoordinates = locationManager.location?.coordinate  else {  return }
        guard let destinationCoordinates =  View.destination?.coordinate  else {  return }
          
        Service.shared.uploadTrip(pickupCoordinates, destinationCoordinates) { (Error, DatabaseReference) in
           
            if let error = Error{
                
                print("heyworld")
                
            }
            
            
            UIView.animate(withDuration: 0.3) {
                
                self.rideActionView.frame.origin.y = self.view.frame.height
            }
            
            
        }
        
        
        
    }
    
   
    
    
  
    
    
    
    
}


//MARK:  extension homeController : PickupControllerDelegate

extension homeController : PickupControllerDelegate{
    func didAccpted(_ trip: Trip) {
       
        let annon =  MKPointAnnotation()
        annon.coordinate = trip.pickupCoordinates
        mapView.addAnnotation(annon)
        mapView.selectAnnotation(annon, animated: true)
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: mapItem)
        mapView.zoomToFit(annotation: mapView.annotations)
       // self.trip?.state = .accepted
        self.dismiss(animated: true, completion: nil)

    
    }
    
    
    
    
}
