//
//  DrawerMenuController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 30/09/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class DrawerMenuController:UITableViewController, UITableViewDataSource {
    
    @IBOutlet var CategoryMainTableView: UITableView!

    var categorysources = [categorysource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urlPath = "http://ilife.ie/mobile_get_category_list"
        let url = NSURL(string:urlPath)
        if let JsonData = NSData(contentsOfURL: url!){
            if let json = NSJSONSerialization.JSONObjectWithData(JsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
//                println(json)
                if let categoryArray = json["data"] as? [NSDictionary] {
//                    println(categoryArray)
                    for item in categoryArray {
//                        println(item)
                        categorysources.append(categorysource(json:item))
//                        println(categorysource(json:item))
                    }
                }
            }
        }
    }
    
    //return the number of section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //Return the number of category
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return categorysources.count
        default:
            return 1
        }
    }
    
    //Ask the tableview for a reusable cell for the given identifier
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath:indexPath) as! UITableViewCell
            cell.textLabel?.text = "Main Page"
        }else {
            if (indexPath.section == 1) {
                cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = categorysources[indexPath.row].category_name
//                println(categorysources[indexPath.row].category_name)
            }
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CategoryDetail" {
//            var cell = sender as! UITableViewCell
//            let IndexPath = self.CategoryMainTableView.indexPathForCell(cell)
            
            //Embed in Navigation controller
            let detailViewController = segue.destinationViewController as? UINavigationController
            let categoryViewController = detailViewController?.topViewController as! CategoryArticleViewController
            var IndexPath = self.CategoryMainTableView.indexPathForSelectedRow()
            let row = IndexPath?.row
            categoryViewController.category_id_detail = categorysources[row!].category_id!
        }
    }
}
