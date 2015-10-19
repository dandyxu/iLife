//
//  CategoryArticleListViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 08/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryArticleViewController:UITableViewController,UITableViewDataSource{
    
    @IBOutlet var CategoryArticleMainView: UITableView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    var category_id_detail:Int!
    
    var categoryArticleSources = [categoryArticleSource]()
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string:"Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.CategoryArticleMainView.addSubview(refresher)
        
        refresh()
        
        //Use Alamofire 1.3.1 to send HTTP POST Request
//        Alamofire.request(.POST, category_urlPath, parameters:["category_id":"\(category_id_detail)"],encoding: .JSON).responseJSON {
//                (request, response, data, error) in
////            println(data)
//            if error != nil {
//                println(error)
//            }else {
////                if let json = NSJSONSerialization.JSONObjectWithData(data! as! NSData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary{
////                    println(json)
////                }
//                var json = JSON(data!)
//                var jsonData = json["data"].array
////                var tempArray = NSMutableArray()
//                
//                for item in jsonData!{
////                    var jsonItem: AnyObject = categoryArticleSource().initModel(NSDictionary(dictionary: item.dictionaryObject!) as [NSObject:AnyObject])
////                    println(item)
//                    
////                    self.categoryArticleSources.append(jsonItem as! categoryArticleSource)
////                    tempArray.addObject(jsonItem)
//                    
//                }
//            }
//        }
        
    }
    
    func refresh(){
        //Start POST request
        let category_urlPath = "http://ilife.ie/mobile_get_category_articles"
        let request = NSMutableURLRequest(URL: NSURL(string:category_urlPath)!)
        request.HTTPMethod = "POST"
        
        var postString = "category_id=\(category_id_detail)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                println(error)
            }else{
                if var json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    if json["code"] as? Int == 14 {
                        println("category_id is not found")
                    }else{
                        if let jsonData = json["data"] as? [NSDictionary] {
                            for item in jsonData {
                                //                                println(item)
                                self.categoryArticleSources.append(categoryArticleSource(json:item))
                            }
                        }
                    }
                }
            }
            self.CategoryArticleMainView.reloadData()
        })
        task.resume()
        self.refresher.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArticleSources.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("categoryList", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.categoryArticleSources[indexPath.row].article_title
//        println(self.categoryArticleSources[indexPath.row].article_title!)
        return cell
    }
    
}
