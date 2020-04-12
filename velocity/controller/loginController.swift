//
//  File.swift
//  velocity
//
//  Created by Nimit on 2020-04-11.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import UIKit

class loginController: UIViewController {

    
    
    
    
    
    //MARK: - all properties
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Velocity"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 36)
        label.textColor = .white
        
        return label
        
    }()
    
    private lazy var emailcontainerView : UIView = {
        
        let view = UIView()
//view.backgroundColor = .black
        let imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        imageview.alpha = 0.87
        view.addSubview(imageview)
        imageview.centerY(inView: view)
        imageview.myanchor(left:view.leftAnchor, paddingLeft: 8 ,width: 32,height: 32)
   
    
        view.addSubview(emailTextField)
        emailTextField.centerY(inView: view)
        emailTextField.myanchor(left:imageview.rightAnchor,bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 8,paddingRight: 8)
       

        let separatorView = UIView()
        separatorView.backgroundColor = .red
        view.addSubview(separatorView)
        separatorView.myanchor(left:view.leftAnchor,bottom:view.bottomAnchor,right:view.rightAnchor,paddingLeft: 8,height:  0.75)
        
        
        
       return view
        
    }()
   
    
    

        private lazy var passwordContainerView : UIView = {
            
            let view = UIView()
    //view.backgroundColor = .black
            let imageview = UIImageView()
            imageview.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
            imageview.alpha = 0.87
            view.addSubview(imageview)
            imageview.centerY(inView: view)
            imageview.myanchor(left:view.leftAnchor, paddingLeft: 8 ,width: 32,height: 32)
       
        
            view.addSubview(password)
            password.centerY(inView: view)
            password.myanchor(left:imageview.rightAnchor,bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 8,paddingRight: 8)
           

           
            
            
            
           return view
            
        }()
    
    
   
    let emailTextField : UITextField = {
                  
                  let tf = UITextField()
                  
        return tf.textField(withplace: "Email", isSecureTextEntry: false )
        
                  
              }()
    let password : UITextField = {
        
        let tf = UITextField()
        return tf.textField(withplace: "password", isSecureTextEntry: true)
        
    }()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        
        view.addSubview(titleLabel)
        titleLabel.myanchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        view.addSubview(emailcontainerView)
        emailcontainerView.myanchor(top:titleLabel.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 50 , paddingLeft: 30, paddingRight: 30,height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.myanchor(top:emailcontainerView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor ,paddingTop: 50, paddingLeft: 30 , paddingRight: 30, height: 50)
    
    
        
    }
    


}
