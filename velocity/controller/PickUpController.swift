//
//  PickUpController.swift
//  velocity
//
//  Created by Nimit on 2020-04-21.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import MapKit

protocol PickupControllerDelegate : class {

    func didAccpted(_ trip : Trip)
    
    
    
    
}



class PickUpController : UIViewController{
    
     //MARK:PROPERTIES
    let trip : Trip
    let mapview = MKMapView()
    weak var delegate : PickupControllerDelegate?
    
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x"), for: .normal)
    button.addTarget(self, action: #selector(handelDismissal), for: .touchUpInside)
        return button
        
    }()
    
    
    private let pickupLabel : UILabel = {
        
        let label = UILabel()
        label.text = "new Passenger Found?"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
        label.textColor = .white
        
        return label
        
    }()
    
    private let AcceptTripbutton  : UIButton = {
           
           let button  = UIButton()
        button.setTitle("wanna pickup??" , for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handelAcceptTrip), for: .touchUpInside)
        return button
           
       }()
       
    
    
    
    
    
   
    //MARK: LIFECYCLE
  
    //initilization with custom trip object for creating view !!
   
    init(trip: Trip){
        
        self.trip = trip
        super.init(nibName: nil , bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        trip.passengerUid
        configureUI()
        configureMapView()
        
      }
    
    override var prefersStatusBarHidden: Bool{
        
        
        return true
        
    }
    
    
    //MARK:helper function
    
    @objc func handelDismissal(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func handelAcceptTrip(){
          
        Service.shared.acceptTrip(trip: trip) { (Error  , DatabaseReference) in
         
            self.delegate?.didAccpted(self.trip)
        
        }
          
      }
    
    
    
    func configureMapView(){
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)

        mapview.setRegion(region, animated: false)

        
      mapview.addAnotationandSelect(forCoordinates: trip.pickupCoordinates)
    
    }
    
    
    
    
    
    func configureUI(){
        
        view.backgroundColor = .systemTeal
        view.addSubview(cancelButton)
        cancelButton.myanchor(top: view.safeAreaLayoutGuide.topAnchor , left:view.leftAnchor , paddingLeft:  16)
        
        
        view.addSubview(mapview)
        mapview.setDimensions(height: 270, width: 270)
        mapview.layer.cornerRadius = 270 / 2
        
        mapview.centerX(inView: view)
        
        mapview.centerY(inView: view , constant: -200)
        
          view.addSubview(pickupLabel)
        pickupLabel.centerX(inView: view)
        pickupLabel.myanchor(top:mapview.bottomAnchor ,paddingTop: 16)
       
        view.addSubview(AcceptTripbutton)
        AcceptTripbutton.myanchor(top:pickupLabel.bottomAnchor ,  left: view.leftAnchor, right: view.rightAnchor,  paddingTop: 16 , paddingLeft: 32 , paddingRight: 32 , height:  50)
        
        
    }
    
  
    
    
    
    
}
