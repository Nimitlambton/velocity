//
//  RideActivationView.swift
//  velocity
//
//  Created by Nimit on 2020-04-20.
//  Copyright © 2020 Nimit. All rights reserved.
//

import UIKit
import MapKit



protocol rideActivityDelegate : class {
 
    func uploadTrip(_ View : RideActivationView )
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    
        init() {
                    self = .requestRide
            }
    
    
    
    }


enum ButtonAction :  CustomStringConvertible{

    case requestRide
    case cancel
    case getDirection
    case pickup
    case dropoff
    

    var description: String{
        switch self {
        case .requestRide: return "GET VELOCITY"
            case .cancel:  return "cancel"
            case .getDirection: return "get Direction"
            case .pickup:  return  "pickup passenger"
            case .dropoff:    return "dropoff passenger"
        
        }
        }
    
    init() {
                   self = .requestRide
           }
      
        
    }


    
   


class RideActivationView: UIView {

    var destination :MKPlacemark?{
           
           didSet{
               
               titleLabel.text = destination?.name
               addressLabel.text = destination?.address
           }
           
       }
    
    var config = RideActionViewConfiguration()
    var buttonAction = ButtonAction()
    
    
    
    //MARK: - PROPERTIES
    
    
    
    weak var delegate : rideActivityDelegate?
    
    
    private let titleLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.systemFont(ofSize: 16)
          label.text = "helloworl123"
        label.textAlignment = .center
          return label
      }()
    
    private let addressLabel: UILabel = {
           let label = UILabel()
           label.textColor = .lightGray
           label.text = "helloworl123"
           label.font = UIFont.systemFont(ofSize: 16)
           label.textAlignment = .center
           return label
       }()
    
    private lazy var inforView : UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = "x"
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
      

        return view
    }()
    
    
    private let velocityLabel: UILabel = {
             let label = UILabel()
           label.text = "Velocity XL"
             label.font = UIFont.systemFont(ofSize: 18)
             label.textAlignment = .center
             return label
         }()
    
    
     private let actionButoon : UIButton = {
        
         let button = UIButton(type: .system)
        button.backgroundColor = .systemOrange
         button.setTitle("Get velocity", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
       //  button.addTarget(self, action: #selector(actionbuttonPress), for: .touchUpInside)
         return button
        
     }()
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addshadow()
        
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        
        addSubview(stack)
               stack.centerX(inView: self)
               stack.myanchor(top: topAnchor, paddingTop: 12)
        
        
        
        addSubview(inforView)
            inforView.centerX(inView: self)
            inforView.myanchor(top: stack.bottomAnchor,paddingTop: 16)
            inforView.setDimensions(height: 60, width: 60)
            inforView.layer.cornerRadius = 60 / 2
        
        addSubview(velocityLabel)
           velocityLabel.myanchor(top: inforView.bottomAnchor , paddingTop: 8)
           velocityLabel.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .systemOrange
        addSubview(separatorView)
        separatorView.myanchor(top:velocityLabel.bottomAnchor ,left: leftAnchor,
            right: rightAnchor , paddingTop: 8 ,height: 0.75)
        
        
        addSubview(actionButoon)
               actionButoon.myanchor(left: leftAnchor , bottom: safeAreaLayoutGuide.bottomAnchor , right: rightAnchor , paddingLeft: 10 , paddingBottom: 12, paddingRight: 10 , height: 50)
        
      let tap = UITapGestureRecognizer(target :self , action: #selector(actionbuttonPress))
        actionButoon.addGestureRecognizer(tap)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Lifecycle

    
    //MARK: SELECTORS
    
    
    @objc func actionbuttonPress(){
        
        print("helloworlf")
        delegate?.uploadTrip(self)
    }
    
    
    //MARK: helper function
    func configureUI(withConfig config : RideActionViewConfiguration){
        
        
        
        
        
    }
 
    
    
}
