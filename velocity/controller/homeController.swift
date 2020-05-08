//
//  homeController.swift
//  velocity
//
//  Created by Nimit on 2020-04-14.
//  Copyright © 2020 Nimit. All rights reserved.
//


//my imports used for essiential funntions
import UIKit
import Firebase
import MapKit



//identifiers - to identifie uniquely

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier  = "DriverAnnotation"



//this is enum for acction_button , it is used to save lines of code. it has to option hamburgemnt menu and backButton

private enum ActionButtonConfiguration{
    
    case showMenu
   
    case dismissActionView
    
    init() {
        self = .showMenu
    }
    
}


private enum AnnotationType : String {
    
    case pickup
    case destination

}



class homeController: UIViewController {
    
    func executeSearch(query: String) {
           
        searchBy(naturalLanguageQuery: query) { (Placemark) in
            self.searchresult = Placemark
            self.tabelView.reloadData()
        }

    }
    
    
    
    
    //MARK:- PROPERTIES
    //to initiate map view on app
    private let mapView = MKMapView()
    
    //for_locations and cordinates initilization
    private let  locationManager = locationHandler.shared.locationManager
    
    //views initializtion
    private let inputActivationView = LocationInputActiviationView()
    private let rideActionView = RideActivationView()
    private let locationinputView = LocationInputView()
    private var actionButtonConfig = ActionButtonConfiguration()
    private let tabelView = UITableView()
    
    //PlaceMark array , results are   appended  when  when search query executes
     private var searchresult = [MKPlacemark]()
    
    
    //constants
    private final let locationInputViewHeight : CGFloat = 200
    private final let rideActionViewHeight : CGFloat = 300
   
    
    //??
    private var route : MKRoute?
    
    
    //User is initiated  here and diffrenciated
    
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
    
    
    //Trip is initiated and stored in model with details like current Trip state
    
    private var trip : Trip? {
       
        
        didSet{
            
            guard let user = user else {return}
            if user.accountType == .driver{
                guard let trip = trip else {return }
                print("d::\(trip.state)")
        
                
    
    let controller = PickUpController(trip: trip)
    controller.delegate = self
    self.present(controller , animated: false)
                
            
            }
            
            else {
                
                print("showAt")
            }
        }
        
    }
   
    //action button on screen
    private let actionButton :UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(actionButoonPressed), for: .touchUpInside)
          return button
    }()
    
    
    //MARK: - LIFECYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signOut()
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
    
    func startTrip(){
        
        
        guard let trip = self.trip else {return }
        
        
        Service.shared.updateTripState(trip: trip, state: .inProgress) { (Error, DatabaseReference) in
            
            self.rideActionView.config =  .tripInProgress
            self.removeAnotationAndOverlays()
    self.mapView.addAnotationandSelect(forCoordinates: trip.destinationCoordinates)
            
            
            let placemark = MKPlacemark(coordinate: trip.destinationCoordinates)
          
            let mapitem = MKMapItem(placemark: placemark)
            
            self.setCustomRegion(withtype: .destination, withCoordinates: trip.destinationCoordinates)
            self.generatePolyline(toDestination: mapitem)
        }
        
        
        
        
    }
    
    
    
    func observeCurrentTrip(){
        
        Service.shared.observeCurrentTrip { Trip in
       
            
            self.trip = Trip
       
    
            guard let stare = Trip.state else {return}
            guard let driverUid = Trip.driverUid else {return}
            
            
            switch stare {

            case .requested:
                break
            case .accepted:
                self.shouldPresnetLoadingView(false)
                self.removeAnotationAndOverlays()
                self.zoomForActiveTrip(withDriverUid: driverUid)
                break
            case .driverArrived:
                self.rideActionView.config = .driverArrived
           case .inProgress:
                self.rideActionView.config = .tripInProgress
                break
            case .arrivedAtDestination:
               self.rideActionView.config = .endtrip
            case .completed:
                self.animateRideActionView(shouldShow: false)
                self.CenterMapOnUserLocations()
                self.configureActionButton(config: .showMenu)
                self.presentAlertController(withMessage: "Trip completed" , withTitle: "fucking have a nice day yo!")
                break
         
            }
            
            
            
            
            if Trip.state == .accepted {
                
                self.shouldPresnetLoadingView(false)
                guard let driveruid = Trip.driverUid else {return }
                Service.shared.fetchUserData(uid: driveruid) { (driver) in
                self.animateRideActionView(shouldShow: true, config: .tripAccepted , user: driver)
                }
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
                driveranon.updateAnnotationPosition(withCoordinate:coordinate)
                self.zoomForActiveTrip(withDriverUid: driver.uid)
                return true}
                return false
                }
                
            }

            if !driverIsVisible{
              self.mapView.addAnnotation(annotation)

            }
        }
    }

    
    
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
func animateRideActionView(shouldShow : Bool , destination: MKPlacemark? = nil,
                               config: RideActionViewConfiguration? = nil , user : User? = nil){
            
      let yorigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight :
          
          self.view.frame.height

            
              UIView.animate(withDuration: 0.3) {
                  
               self.rideActionView.frame.origin.y = yorigin
              }
        
        if shouldShow{

            guard let config = config else {return}

          if  let destination = destination{
            rideActionView.destination = destination}
            
            if let user = user{
                
                rideActionView.usera = user
            }

      
            rideActionView.config = config
     
    
    
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
      
    }
   
       func configureUI(){
        configuremap()
        //HamBurger menu or back button
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
    
  

    //adding
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
    
    

    func zoomForActiveTrip(withDriverUid  Uid : String){
       var annotations = [MKAnnotation]()
                      
        self.mapView.annotations.forEach { (Annotation) in

            if let annon = Annotation as? DriverAnnotation{

 if   annon.uid == Uid{
                          annotations.append(annon) }

                      if let userannon = Annotation as? MKUserLocation{
                          
                          
                          annotations.append(userannon)
                      }
                          }
                      }
 self.mapView.zoomToFit(annotation:annotations )

    }

    
    
    
    
    
    }


    

  //MARK: -LOCATION SERVICES
extension homeController : CLLocationManagerDelegate{
   
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        

        if region.identifier == AnnotationType.pickup.rawValue {
            
            
            print("R:  \(region)" )
            
        }
        
        if region.identifier == AnnotationType.destination.rawValue{
            
            print("R: \(region)")
            
        }
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        guard let trip = self.trip else {return }

  if region.identifier == AnnotationType.pickup.rawValue {
                      
                      
Service.shared.updateTripState(trip: trip, state: .driverArrived) { (Error, DatabaseReference) in
self.rideActionView.config = .pickupPassenger
                      
                  }
 
        }

        
         if region.identifier == AnnotationType.destination.rawValue{
        
             
             Service.shared.updateTripState(trip: trip, state: .arrivedAtDestination) { (Error, DatabaseReference) in
                                           
             self.rideActionView.config = .endtrip
                 
             }
    }
        
      
    
    
    }



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
              
            
            
            self.mapView.addAnotationandSelect(forCoordinates: selectedPlacemark.coordinate)
            
            
            
                let annontations = self.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self)})
            self.mapView.showAnnotations(annontations, animated: true)
            self.animateRideActionView(shouldShow: true,destination:  selectedPlacemark ,config: .requestRide)
        }
    }
   }

//MARK: MAPVIEW DELEGATE
extension homeController : MKMapViewDelegate{
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        //make sure user exists
        guard let user = self.user else {return }
        //diffrentiate between rider and driver
        guard user.accountType == .driver else {return }
        
        guard let location = userLocation.location else {return }
        Service.shared.updateDriverLocations(location: location)

    }
    
    
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
    
    
    
    
    func CenterMapOnUserLocations(){
        
        guard let coordinate = locationManager.location?.coordinate else {return }
       
        let region = MKCoordinateRegion(center: coordinate,
                                          latitudinalMeters: 2000,
                                          longitudinalMeters: 2000)
        
        mapView.setRegion(region, animated: true)
        
    }
    

    func setCustomRegion(withtype type : AnnotationType ,     withCoordinates coordinates :CLLocationCoordinate2D){
    
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: type.rawValue)
        
        locationManager.startMonitoring(for: region)
        
        print("o: did1 set region\(region)")

    }
    
    
    








}





    //MARK: -  homeController : rideActivityDelegate

extension homeController : rideActivityDelegate{
    func dropOffPassenger() {
        guard let trip = self.trip else {return }
        
        Service.shared.updateTripState(trip: trip, state: .completed) { (Error, DatabaseReference) in
            
            self.removeAnotationAndOverlays()
            self.CenterMapOnUserLocations()
            self.animateRideActionView(shouldShow: false)
            

            
        }
        
        
        
        
    }
    
   
    func pickupPassenger() {
        
        startTrip()
    }
    

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

    
    //tocancel trip
    func cancelTrip() {
        Service.shared.cancelTrip { (Error, DatabaseReference) in
            
            if let error = Error{
                return
            }
            
            self.CenterMapOnUserLocations()
            self.animateRideActionView(shouldShow: false)
            self.removeAnotationAndOverlays()
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
            self.actionButtonConfig = .showMenu
            self.presentAlertController(withMessage: "yo! fucking trip cancelled!!", withTitle: "you cancelled trip !! backCharged")
            
            self.inputActivationView.alpha = 1
           
          
        }
    }

}


//MARK:  extension homeController : PickupControllerDelegate

extension homeController : PickupControllerDelegate{
    func didAccpted(_ trip: Trip) {
       
        self.trip = trip

        self.mapView.addAnotationandSelect(forCoordinates: trip.pickupCoordinates)
        
        
        setCustomRegion(withtype: .pickup, withCoordinates: trip.pickupCoordinates)
        
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: mapItem)
       
        mapView.zoomToFit(annotation: mapView.annotations)
        
        Service.shared.observeTripCancelled(trip: trip) {
             //self.CenterMapOnUserLocations()
            self.removeAnotationAndOverlays()
            self.animateRideActionView(shouldShow: false)
            self.mapView.zoomToFit(annotation: self.mapView.annotations)
            self.presentAlertController(withMessage: "yo! fucking trip cancelled!!", withTitle: "sad")
           
        }
        self.dismiss(animated: true) {
     Service.shared.fetchUserData(uid: trip.passengerUid) { (passenger) in
   
    self.animateRideActionView(shouldShow: true, config: .tripAccepted , user: passenger   )
           
            }

        }

    }
    
    
    
}
