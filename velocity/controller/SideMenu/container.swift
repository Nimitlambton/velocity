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
    
    
    
    private var isexpanded = false
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .systemBackground
           fetchUserData()
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
        
        
    }
    
    func animateMenu(shouldExpand : Bool){
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homecontroller.view.frame.origin.x = self.view.frame.width - 80
            }, completion: nil)
            
        }else {
            
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homecontroller.view.frame.origin.x = 0
                       }, completion: nil)
            
        }
        
        
    }
    
    
}
