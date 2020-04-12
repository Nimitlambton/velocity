//
//  Login.swift
//  velocity
//
//  Created by Nimit on 2020-04-12.
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

    let emailTextField : UITextField = {
                     
                     let tf = UITextField()
                     
           return tf.textField(placeholder: "Email", isSecureTextEntry: false )
           
                     
                 }()
    
    let passwordTextField : UITextField = {
           
           let tf = UITextField()
           return tf.textField(placeholder: "password", isSecureTextEntry: true)
           
       }()
    
   private let  loginButton  :UIButton = {
           
    let b = UIButton(type: .system)
           b.setTitle("Log In" ,for: .normal)
           b.setTitleColor(.white, for: .normal)
           b.heightAnchor.constraint(equalToConstant: 50)
           b.backgroundColor = .red
           return b
       }()
    let dontHaveAccountButoon :UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account ?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize:16),
                            NSAttributedString.Key.foregroundColor:UIColor.green])
        attributedTitle.append( NSMutableAttributedString(string: "  Sign UP ?", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
        NSAttributedString.Key.foregroundColor:UIColor(red: 17/255, green:  17/255, blue:  17/255, alpha:6)  ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handelSingup), for: .touchUpInside )
        return button
    }()

    
    //MARK: Containers
    private lazy var emailcontainerView : UIView = {
        let view = UIView().myContainers(img: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), text: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
        private lazy var passwordContainerView : UIView = {
          let  view = UIView().myContainers(img: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), text: passwordTextField)
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return view
            
        }()
    
    
   
   
   
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        
        //textlabel
        view.addSubview(titleLabel)
        titleLabel.myanchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        

        //stackview for email and password textfield
        let stack = UIStackView(arrangedSubviews:      [emailcontainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16

        view.addSubview(stack)
        stack.myanchor(top:titleLabel.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 40 , paddingLeft: 16, paddingRight: 14)
        
        view.addSubview(dontHaveAccountButoon)
        dontHaveAccountButoon.myanchor(left: view.leftAnchor, bottom:view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingTop: 40 , paddingLeft: 16, paddingRight: 14, height: 50)
        
    
        
    }
    

    
    //MARK:- Selector
    
    @objc func handelSingup(){
        
    print("123")
    }

}
