//
//  locationInputActivationView.swift
//  velocity
//
//  Created by Nimit on 2020-04-14.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import UIKit

protocol LocationInputActivationDelegate : class {
    
    func presentLocationInputView()
}



class LocationInputActiviationView: UIView {


    //MARK: - PROPERTIES
 
    weak var delegate : LocationInputActivationDelegate?

    private let indicatorView :UIView = {
        
        let view = UIView()
        view.backgroundColor = .purple
        return view
        
    }()
    
    private let PlaceholderLabel: UILabel = {
         let label = UILabel()
    
        label.text = "where are you heading to ?"
        
          label.font = UIFont(name: "ChalkboardSE-Bold", size: 18)
     
          return label
          
      }()
    

    //MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        backgroundColor = .white
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor ,paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)
        
        addshadow()
        addSubview(PlaceholderLabel)
        PlaceholderLabel.centerY(inView: self, leftAnchor: indicatorView.leftAnchor ,paddingLeft: 20)
     
        
        
        //tap gesture to recognize that search based has been tapped
        let tap = UITapGestureRecognizer(target :self , action: #selector(presentLocationInputView))
         
        //use of delegates
        addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selectors
    
    @objc func presentLocationInputView(){
        
        delegate?.presentLocationInputView()
    }
    
}
