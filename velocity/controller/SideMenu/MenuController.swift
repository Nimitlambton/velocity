//
//  menuController.swift
//  velocity
//
//  Created by Nimit on 2020-05-09.
//  Copyright © 2020 Nimit. All rights reserved.
//


import Foundation

import UIKit

private let reuseIdentifier = "MenuCell"

protocol menuControllerDelegate : class {
          func didSelect(option : MenuOptions)
      }



enum MenuOptions : Int , CaseIterable , CustomStringConvertible{
       
       case yourTrips
       case Settings
       case logout
       
       var description: String{
           
           
           switch self{
               
           case .yourTrips: return "Your Trips"
           case .Settings: return "Settings"
           case .logout: return "logout"
          
           
           }
       }
       
       
   }


class menuController : UITableViewController{
   
    
   
    
    weak var delegate: menuControllerDelegate?
 
    
    
    
    var user : User

   
    
    
     //MARK: -PROPERTIES
    private lazy var menueader : menuHeader = {
        
let frame1 = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 140)
        
       
        
       let view = menuHeader(user: user , frame1: frame1)
        
        return view
        
        
    }()
     
     
     //MARK: -LifeCycle
   
    
    override func viewDidLoad() {
           
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTableView()
        }
    
    
     init(user : User) {
        self.user = user
        super.init(nibName : nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

     //MARK: -Selectors
     
     //MARK: -Helper Functions
    

    func configureTableView(){
        
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableHeaderView = menueader
        
    }


}

   
extension menuController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier ,  for: indexPath)
        
        
        guard let option = MenuOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.textLabel?.text = option.description
        return  cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else{ return }
        delegate?.didSelect(option: option)
        
        
        
        
    }
    
}
