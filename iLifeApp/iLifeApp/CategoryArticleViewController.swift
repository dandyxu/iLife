//
//  CategoryArticleListViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 08/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class CategoryArticleViewController:UITableViewController,UITableViewDataSource{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    var category_id_detail:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
            }else {
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    if json["code"] as? Int == 14 {
                        println("category_id is not found")
                    }else {
                        if var jsonData = json["data"] as? NSArray {
//                            NSOperationQueue.mainQueue().addOperationWithBlock{
                            for item in jsonData {
                                var article_id_item = item["article_id"] as! Int
                                println(article_id_item)
                            }
                            
//                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
}
