//
//  DrawerMenuController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 30/09/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class DrawerMenuController:UITableViewController, UITableViewDataSource {
    
    var categorysources = [categorysource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPath = "http://ilife.ie/mobile_get_category_list"
        let url = NSURL(string:urlPath)
        if let JsonData = NSData(contentsOfURL: url!){
            if let json = NSJSONSerialization.JSONObjectWithData(JsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
//                println(json["data"])
                
                if let categoryArray = json["data"] as? [NSDictionary] {
//                    println(categoryArray)
                    for item in categoryArray {
//                        println(item)
                        categorysources.append(categorysource(json:item))
                        
                    }
                }
            }
        }
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    
    //Return the number of category
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        
//        if section == 1 {
//            return categorysources.count
//        }
        //return categorysources.count + 1
        return categorysources.count
    }
    
    //Ask the tableview for a reusable cell for the given identifier
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = categorysources[indexPath.row].category_name
        return cell
    
    }
    
    
}
