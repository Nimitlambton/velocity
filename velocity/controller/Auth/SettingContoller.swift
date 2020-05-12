//
//  SettingContoller.swift
//  velocity
//
//  Created by Nimit on 2020-05-11.
//  Copyright © 2020 Nimit. All rights reserved.
//


import UIKit



private let reuseIdentifier = "LocationCell"

class SettingContoller : UITableViewController   {
    
       private let user : User
    
    
    private lazy var infoHeader1: infoHeader = {
          
         let  frama = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
         let view = infoHeader(user: user, frame1: frama )
          
          return view
      }()
     
    
     init(user : User) {
        self.user = user
        super.init(nibName : nil, bundle :nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        view.backgroundColor = .red
         configureNavigation1()
        configrueNavigationBar()
       configureTableView()
       
    }
    

    func configureTableView(){
        

        tableView.rowHeight = 60
        tableView.tableHeaderView = infoHeader1
           
    tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)

        
        tableView.backgroundColor = .white
        
        
        
    }
    
    func configrueNavigationBar(){
        
        navigationController?.navigationBar.prefersLargeTitles = true
      
      
        navigationController?.navigationBar.barTintColor = .systemBackground

        navigationItem.title = "Setting"
        
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_highlight_off_white_3x"), style: .plain, target: self, action: #selector(handelDismiis))

    }
    
    
    @objc func handelDismiis () {
        print("r:hello")
      
        navigationController?.popToRootViewController(animated: true)
         navigationController?.navigationBar.isHidden = true
}
    
    
    func configureNavigation1(){
    
        navigationController?.navigationBar.isHidden = false
       
       }
    




}


