//
//  DrawerMenuController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 30/09/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class DrawerMenuCOntroller:UITableViewController,UITableViewDataSource {
    
    var categorysource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //Return the number of category
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorysource.count
    }
    
    //ask the tableview for a reusable cell for the given identifier
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = categorysource[indexPath.row]
        return cell
    
    }
    
    
}
