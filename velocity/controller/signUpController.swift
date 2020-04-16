//
//  signUpController.swift
//  velocity
//
//  Created by Nimit on 2020-04-12.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import  UIKit
import  Firebase
import GeoFire
class signUpController : UIViewController{
     
    
    //MARK: - properties
    //MARK: - all properties
    private var location = locationHandler.shared.locationManager.location
    
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
    
    
    let fullNameTextField :UITextField = {
        
        let tf = UITextField()
        return tf.textField(placeholder: "Enter your full name", isSecureTextEntry: false)
    }()
     
    private let AcountTypeSementedControl : UISegmentedControl = {
        
        let sg = UISegmentedControl(items: ["Rider","Driver"])
        sg.selectedSegmentIndex = 0
        
        return sg
        
        
    }()
    private let  loginButton  :UIButton = {
             
      let b = authButton(type: .system)
      
       b.setTitle("SignUp" ,for: .normal)
       b.addTarget(self, action:  #selector(handelSignup), for: .touchUpInside)
       return b
         }()
    
    
    let alreadyHaveAccountButoon :UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account ?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize:16),
                            NSAttributedString.Key.foregroundColor:UIColor.green])
        attributedTitle.append( NSMutableAttributedString(string: "  Login ?", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
        NSAttributedString.Key.foregroundColor:UIColor(red: 17/255, green:  17/255, blue:  17/255, alpha:6)  ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handelShowLogin), for: .touchUpInside )
        return button
    }()
    
    
    
    
    //MARK: - CONTAINER
    
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
    
    
    private lazy var accountTypeContainerView : UIView = {
        
              let  view = UIView().myContainers(img: #imageLiteral(resourceName: "ic_person_outline_white_2x"), segmentedControl:AcountTypeSementedControl )
               // view.heightAnchor.constraint(equalToConstant: 90).isActive = true
                return view
                
            }()
    
    private lazy var fullname : UIView = {
              let  view = UIView().myContainers(img: #imageLiteral(resourceName: "ic_person_outline_white_2x") , text:fullNameTextField )
                view.heightAnchor.constraint(equalToConstant: 50).isActive = true
                return view
                
            }()
       
   
    
    
    
    
    //MARK: - Lifecycle

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = .red
        configureUi()
    
        let sharedLocationManger = locationHandler.shared.locationManager
       
        print(sharedLocationManger.location)
        
        
        
        
    
    }
    
     //MARK: - Selectors
    
    func configureUi(){
          
          
          view.backgroundColor = .orange
             
             configureNavigation()
           
        view.addSubview(titleLabel)
             titleLabel.myanchor(top: view.safeAreaLayoutGuide.topAnchor)
             titleLabel.centerX(inView: view)
             

             //stackview for email and password textfield
             let stack = UIStackView(arrangedSubviews:      [fullname,emailcontainerView,passwordContainerView , accountTypeContainerView,loginButton])
             stack.axis = .vertical
             stack.distribution = .fillEqually
             stack.spacing = 30

             view.addSubview(stack)
             stack.myanchor(top:titleLabel.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 40 , paddingLeft: 16, paddingRight: 14)
           
        view.addSubview(alreadyHaveAccountButoon)
          alreadyHaveAccountButoon.myanchor(left: view.leftAnchor, bottom:view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingTop: 40 , paddingLeft: 16, paddingRight: 14, height: 50)
       
      }
    
    func configureNavigation(){
          navigationController?.navigationBar.isHidden = true
      }

    
    @objc func handelShowLogin(){
        
        navigationController?.popViewController(animated: true)
        
    }
 
    @objc func handelSignup(){
        
        
        
        guard let email = emailTextField.text else {return}
        guard let password  = passwordTextField.text else {return}
        guard let fullname  = fullNameTextField.text else {return}
        let accountIndex  = AcountTypeSementedControl.selectedSegmentIndex

        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error{
                
                print(error)
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
                let value = ["email:": email ,
                                "fullname":fullname,
                                  "accountType":accountIndex ] as [String: Any]
            
            
            if accountIndex == 1 {
                               
            var geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
            guard let location = self.location else {return }
          geofire.setLocation(location, forKey:  uid) { (Error) in
            
        self.uploadUserDataAndDismiss(uid: uid, values: value)
                                          
                
                }
                           }
            
            
            
            
            
            //self.uploadUserDataAndDismiss(uid: uid, values: value)
        
            
}
        

     
        
        
        }
        
          
    
    
    //MARK: - HELPER FUNCTIONS
     
     func uploadUserDataAndDismiss(uid:String , values:[String:Any]) {
          REF_USERS.child(uid).updateChildValues(values) { (Error , ref) in
          self.navigationController?.popViewController(animated: true)
                              
                                      }
   
      }
     
    
    
    
    
    
    
    
       }

    
    
    
    
 
    
    
    

