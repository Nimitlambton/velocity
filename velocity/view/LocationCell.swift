//
//  LocationCell.swift
//  velocity
//
//  Created by Nimit on 2020-04-15.
//  Copyright © 2020 Nimit. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

  
    //MARK: properties
    
       private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Velocity"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 12)
        label.textColor = .black
        
        return label
        
    }()

    private let addressLabel: UILabel = {
       let label = UILabel()
        label.text = "Velocity1233"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 12)
        label.textColor = .lightGray
        
        return label
        
    }()

    
    
    //MARK: Lifecycle
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         
        super.init(style: style, reuseIdentifier: "LocationCell")
        let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        stack.distribution = .fillEqually
        stack.spacing =  4
       
        //stack for cell 
        addSubview(stack)
        stack.centerY(inView: self , leftAnchor:leftAnchor , paddingLeft:12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 
