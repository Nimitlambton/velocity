//
//  LocationInputView.swift
//  velocity
//
//  Created by Nimit on 2020-04-15.
//  Copyright © 2020 Nimit. All rights reserved.
//

import UIKit

class LocationInputView: UIView {

   
    //MARK: - Properties
    
    private let backButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelBackTapper), for:.touchUpInside)
        return button
        
    }()
    
    
    
    
    
    
    //MARK:-Lifecycle
    

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addshadow()
        backgroundColor = .yellow
        
        addSubview(backButton)
        backButton.myanchor(top:topAnchor ,left: leftAnchor,paddingTop: 44 ,paddingLeft: 12 ,width: 24, height: 25)
    
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     

    
    //MARK: - Selectors
    
    @objc func handelBackTapper(){
        
        
        
        
    }

}
