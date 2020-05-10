//
//  menuHeader.swift
//  velocity
//
//  Created by Nimit on 2020-05-09.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation

import UIKit


class menuHeader : UIView {
    
    
    var user: User?{
        
        didSet{
            titleLabel.text = user?.fullname
            addressLabel.text = user?.email   
        }
        
    }
    
    
    //MARK: -PROPERTIES
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
        
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
         label.text = "Velocity"
         label.font = UIFont(name: "ChalkboardSE-Bold", size: 12)
         label.textColor = .white
         
         return label
         
     }()

     private let addressLabel: UILabel = {
        let label = UILabel()
         label.text = "pamnaninimit@ymail.com"
           label.font = UIFont.systemFont(ofSize: 14)
         label.textColor = .lightGray
         
         return label
         
     }()
    
        //MARK: -LIFECYCLES
    
    override init(frame: CGRect) {
        
        super.init(frame : frame)
        
        backgroundColor = .orange
 
        addSubview(profileImageView)
        profileImageView.myanchor(top: topAnchor, left: leftAnchor,   paddingTop: 4, paddingLeft: 12 , width: 64, height: 64)
   
        profileImageView.layer.cornerRadius = 64/2
   
        
        let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        
        
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        addSubview(stack)
    stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: -SELECTORS
    
    
    
}
