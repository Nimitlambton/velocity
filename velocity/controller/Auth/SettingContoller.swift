//
//  SettingContoller.swift
//  velocity
//
//  Created by Nimit on 2020-05-11.
//  Copyright © 2020 Nimit. All rights reserved.
//


import UIKit



private let reuseIdentifier = "LocationCell"


enum locationTtype : Int , CaseIterable , CustomStringConvertible {
    
    case home
    case work
    
    
    var description: String{
        
        switch self {
       
        case .home:
            return "Home"
        case .work:
            return "work"
        }
        
        
        var subtitle : String {
           
            
            
            switch self {
                 
                  case .home:
                      return "Add home"
                  case .work:
                      return " Add work"
                  }
                  
            
        }
        
        
        
    }
    
    
    
}





class SettingContoller : UITableViewController   {
    
       private let user : User
     //for_locations and cordinates initilization
    private let  locationManager = locationHandler.shared.locationManager
    
    
    
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

         tableView.tableFooterView = UIView()
        
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


//MARK:- UITABLEVIEW SECTION
extension SettingContoller {
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationTtype.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let view = UIView()
        
        
       // view.backgroundColor = .black
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.text = "Favorities"
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor , paddingLeft: 16)
        
        
        return view 

    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
    
        
 guard let type = locationTtype(rawValue: indexPath.row) else {return cell}
 
        cell.type = type
        return cell
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
       guard let type = locationTtype(rawValue: indexPath.row) else {return }
        
        guard let location = locationManager.location else {return }
        
        let controller = AddLocationController(type: type, location: location)
       
        navigationController?.pushViewController(controller, animated: true)
        
        
        
    }
    
    
    
}
