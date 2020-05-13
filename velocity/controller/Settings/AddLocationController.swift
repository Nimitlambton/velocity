//
//  AddLocationController.swift
//  velocity
//
//  Created by Nimit on 2020-05-12.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import  UIKit
import MapKit

protocol addLocationControllerDelegate : class {
    func updatelocation(locationString : String , type : locationTtype)
}


class AddLocationController : UITableViewController, UISearchBarDelegate {
  
    private let reusefidetifier  = "Cell"
    
    
    private let searchBar1 = UISearchBar()
    
    
    private let searchComplete =   MKLocalSearchCompleter()

    private var searachResults = [MKLocalSearchCompletion]()
    
    private let type : locationTtype
    private let location  : CLLocation
    
    weak var delegate : addLocationControllerDelegate?
    
    init(type : locationTtype , location : CLLocation) {
        self.type  = type
        self.location = location
        
        super.init(nibName:nil , bundle : nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
 configureSearchbar()
   configureTableView()
        configureSearchComplete()
       
        
    }
    
    func configureTableView(){
        
tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell" )

        
        tableView.tableFooterView = UIView()
tableView.rowHeight = 60
 tableView.addshadow()
        
    }
    
    
    func configureSearchbar(){
        
        searchBar1.sizeToFit()
        searchBar1.delegate = self
        navigationItem.titleView = searchBar1
        
        
    }
    
    
    //to hide navigation bar
    func configureNavigation(){
     navigationController?.navigationBar.isHidden = false
         }
    
    
    
}


extension AddLocationController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searachResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reusefidetifier)
        
        let  results = searachResults[indexPath.row]
        cell.detailTextLabel?.text = results.subtitle
        cell.textLabel?.text = results.title
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result  = searachResults[indexPath.row]
        let title =  result.title
        let subtitle = result.subtitle
        var locationString = title + " " + subtitle
        
       let trimmedloc = locationString.replacingOccurrences(of: "ON", with: " ")
        delegate?.updatelocation(locationString:  trimmedloc , type: type)
    }

    
    
    
    func configureSearchComplete(){
        
let region = MKCoordinateRegion(center: location.coordinate , latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        searchComplete.region =  region
        searchComplete.delegate = self
        
        
    }
    
    
}






extension AddLocationController : UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("r\(searchBar)")
      
        searchComplete.queryFragment = searchText
    }
    
    
    
}


extension AddLocationController : MKLocalSearchCompleterDelegate {
    
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searachResults = completer.results
        tableView.reloadData()
    }
    
    
    
    
}

