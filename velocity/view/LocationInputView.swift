//
//  LocationInputView.swift
//  velocity
//
//  Created by Nimit on 2020-04-15.
//  Copyright © 2020 Nimit. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate : class{
    
    func DismissInputview()
    func executeSearch(query: String)
    
}


class LocationInputView: UIView {

   
    //MARK: - Properties
    weak var delegate : LocationInputViewDelegate?
    

    var user: User?{
        didSet {
            
            titleLabel.text = user?.fullname
            
        }
        
    }
    
    
    
    private let backButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelBackTapper), for:.touchUpInside)
        return button
        
    }()
    
    
   private var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        label.textColor = .black
        return label
        
    }()

    
    private let startIndicatorView :UIView = {
        
        let view = UIView()
        view.backgroundColor = .purple
        return view
        
    }()
    
    
    
       private let linkingIndicatorView :UIView = {
           
           let view = UIView()
           view.backgroundColor = .purple
           return view
           
       }()
    
    private let destinationIndicatorView :UIView = {
             
             let view = UIView()
             view.backgroundColor = .purple
             return view
             
         }()
    
  lazy  var startingLocationTextField : UITextField = {
        
     let tf = UITextField()
                  tf.placeholder = "Current Location"
                  tf.backgroundColor = .yellow
                  tf.isEnabled = false
                 
    
    let paddingView = UIView()
    paddingView.setDimensions(height: 30, width: 8)
    tf.leftView = paddingView
    tf.leftViewMode = .always
    
    return tf
    }()
    
    lazy  var destinationLocationTextField : UITextField = {
          
           let tf = UITextField()
           tf.placeholder = "Enter location"
          // tf.backgroundColor = .orange
         
           tf.delegate  = self
        
           tf.returnKeyType = .search
           let paddingView = UIView()
             paddingView.setDimensions(height: 30, width: 8)
             tf.leftView = paddingView
             tf.leftViewMode = .always
           return tf
      
    
    
    }()

    
    
    
    
    
    //MARK:-Lifecycle
    

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addshadow()
        backgroundColor = .yellow
        
        addSubview(backButton)
        backButton.myanchor(top:topAnchor ,left: leftAnchor,paddingTop: 44 ,paddingLeft: 12 ,width: 24, height: 25)
    
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.myanchor(top:backButton.bottomAnchor,left: leftAnchor ,right: rightAnchor ,paddingTop: 4 ,paddingLeft: 40 ,paddingRight: 40 ,height: 30 )
        
         addSubview(destinationLocationTextField)
     
         destinationLocationTextField.myanchor(top:startingLocationTextField.bottomAnchor,left: leftAnchor ,right: rightAnchor ,paddingTop: 30 ,paddingLeft: 40 , paddingRight: 40 ,height: 30)
        
        addSubview(startIndicatorView)
        
        //starting  indicatror
        startIndicatorView.centerY(inView: startingLocationTextField
            ,leftAnchor:leftAnchor,paddingLeft: 20)
        
        startIndicatorView.setDimensions(height: 6, width: 6)
        startIndicatorView.layer.cornerRadius = 6 / 2
        
        //destination indicatror
         addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextField
            ,leftAnchor:leftAnchor,paddingLeft: 20)
        
        destinationIndicatorView.setDimensions(height: 6, width: 6)
        destinationIndicatorView.layer.cornerRadius = 6 / 2

        //lining indicator
       
         addSubview(linkingIndicatorView)
        linkingIndicatorView.centerY(inView: startIndicatorView)
        
        linkingIndicatorView.myanchor(top : startIndicatorView.bottomAnchor ,bottom: destinationIndicatorView.topAnchor,paddingTop: 4 , paddingBottom:  4 ,width: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     

    
    //MARK: - Selectors
    
    @objc func handelBackTapper(){
        
        delegate?.DismissInputview()
        
        
        
    }

}

//MARK : UITEXT field delegate

extension LocationInputView : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let query = textField.text else {return false}
      
        delegate?.executeSearch(query: query)
        
        return true
    }
 
}



