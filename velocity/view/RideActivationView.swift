//
//  RideActivationView.swift
//  velocity
//
//  Created by Nimit on 2020-04-20.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class RideActivationView : UIView{
    
    var destination :MKPlacemark?{
        
        didSet{
            
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
        
    }
    
 
    //MARK: PROPERTIES
    
    private let titleLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.systemFont(ofSize: 18)
          label.textAlignment = .center
         label.text = "helloworl123"
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
        label.text = "v"
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
        button .addTarget(self, action: #selector(actionButonPressed), for: .touchUpInside)
        
        return button
       
    }()
    
    
    
    
       //MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init( frame : frame)
        
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
            right: rightAnchor , paddingTop: 4 ,height: 0.75)
        
        addSubview(actionButoon)
        actionButoon.myanchor(left: leftAnchor , bottom: safeAreaLayoutGuide.bottomAnchor , right: rightAnchor , paddingLeft: 35 , paddingBottom: 12, paddingRight: 35 , height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:: HELPER FUNCTIONS
    
    @objc func  actionButonPressed() {
        
        print("helloworl")
    }
    
    
}
