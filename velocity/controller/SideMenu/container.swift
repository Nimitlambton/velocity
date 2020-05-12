//
//  container.swift
//  velocity
//
//  Created by Nimit on 2020-05-09.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation

import UIKit
import Firebase


class container: UIViewController, homeControllerDelegate {
    func handelMenuToggel() {
        isexpanded.toggle()
        animateMenu(shouldExpand: isexpanded)
    }
    
    
    
    
    //MARK: -PROPERTIES
   
    private let  homecontroller = homeController()
    private var menucontroller:  menuController!
    private let blackView  = UIView()
    private var isexpanded = false
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
           super.viewDidLoad()
        
        checkIFUSerLoggesIn()
        
      
        
        
        
    }
    

       
    func configureNavigation(){
            navigationController?.navigationBar.isHidden = true
    
    }
    
    


    //MARK: -Selectors
    
        //MARK: -API
    private var user: User?{
 
        didSet{
            
         guard let User = user else {return }
        homecontroller.user = User
        configureMenuController(withUser: User)
        configureHomeController()
            
            
        }
        
        
        
    }
    
    //MARK: -Helper Functions
    
    
    func fetchUserData(){
           
           guard  let uid = Auth.auth().currentUser?.uid else {return }
           Service.shared.fetchUserData(uid: uid) { user in
               self.user = user
           }
            }
    
    
    
       func  checkIFUSerLoggesIn()  {
           
          
           if Auth.auth().currentUser?.uid == nil {
           let controller = loginController()
           navigationController?.pushViewController(controller, animated: true)
           }
           else{
           configureNavigation()
           view.backgroundColor = .systemBackground
           fetchUserData()
           }
       }
    
    
    
    
    func configureHomeController(){
        
       addChild(homecontroller)
        homecontroller.didMove(toParent: self)
        view.addSubview(homecontroller.view)
        
        homecontroller.delegate = self
        homecontroller.user = user
    }
    
    
   
    func configureMenuController(withUser user : User){
        menucontroller = menuController(user: user)
        addChild(menucontroller)
        menucontroller.didMove(toParent: self)
        view.insertSubview(menucontroller.view, at: 0)
        menucontroller.user = user
        
        menucontroller.delegate = self
        
        
    }
    func configureBlackView(){
        
        
        blackView.frame = self.view.bounds
        blackView.backgroundColor = UIColor(white: 0 , alpha:  0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
      let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu) )
        
        
        blackView.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissMenu(){
        
        isexpanded = false
        
        animateMenu(shouldExpand: isexpanded)
        
        
    }
    
   

    

    
    
    
    
    func animateMenu(shouldExpand : Bool , completion:(( Bool ) -> Void)?=nil ){
        
        let xOrigin = self.view.frame.width - 80
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homecontroller.view.frame.origin.x = xOrigin
    
                self.blackView.alpha = 1
                self.blackView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
                
            }, completion: nil)
            
        }else {
        self.blackView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homecontroller.view.frame.origin.x = 0
                       }, completion: completion)
            
        }
        
        
    }
    
    
    func signOut(){
        
        
                 do{
                  
        
        navigationController?.pushViewController(loginController(), animated: true)
         
                    
         try Auth.auth().signOut()
                    
                    
                 }catch let error {

                     print("error occurs")
                 }

                 }
    
    
}


extension container : menuControllerDelegate{
    func didSelect(option: MenuOptions) {
        isexpanded.toggle()
        animateMenu(shouldExpand: isexpanded) { _ in
            switch option {
             case .yourTrips:
                 break
             case .Settings:
                
                guard  let user = self.user else {
                    return
                }
                
                let controller = SettingContoller(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
                
                  break
             case .logout:
                 let alert = UIAlertController(title: nil, message:"wanna Logout??" , preferredStyle: .actionSheet)
         
                 alert.addAction(UIAlertAction(title: "LogOut", style: .destructive, handler: { _ in
                     self.signOut()
                     
                 }))
                 
                 alert.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
                 
                 self.present(alert, animated: true , completion: nil)
             
             }
        }
    
    
        
    
    }
}
