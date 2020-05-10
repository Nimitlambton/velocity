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
class menuController : UITableViewController{
   
    
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
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier ,  for: indexPath)
        
        cell.textLabel?.text = "menu Option"
        
        return  cell
    }
    
}
