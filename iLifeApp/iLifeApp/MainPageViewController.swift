//
//  MainPageViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 30/09/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class MainPageViewController: UITableViewController,UITableViewDataSource {
    
    @IBOutlet weak var ScrollView: UIWebView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var maintableview: UITableView!
    
    var articlesources = [articlesource]()
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string:"Pull to refresh!")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.maintableview.addSubview(refresher)
        
        refresh()
        
        //Invoke action in RevealViewController to use drawer menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Grab website scrollview
        let scrollViewUrlPath = "http://ilife.ie/mobile_slides"
        let scrollUrl = NSURL(string:scrollViewUrlPath)
        var scrollRequest = NSURLRequest(URL:scrollUrl!)
        ScrollView.loadRequest(scrollRequest)
        
  

    }
    
    func refresh(){
        //start get article list
        let urlPath = "http://ilife.ie/mobile_get_article_list"
        let url = NSURL(string:urlPath)
        if let JsonData = NSData(contentsOfURL: url!){
            if let json = NSJSONSerialization.JSONObjectWithData(JsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray {
                if let articleArray = json as? [NSDictionary] {
                    for item in articleArray {
                        articlesources.append(articlesource(json:item))
                        //println(item["image_url"])
                    }
                }
            }
        }
        self.refresher.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return articlesources.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("maincell", forIndexPath: indexPath) as! ArticleTableViewCell
        
        //Load title of each tableview cell
        cell.title?.text = articlesources[indexPath.row].article_title
        
        //Load title icon at the left of each tableview cell
        if let article_icon_url = articlesources[indexPath.row].article_icon {
            let article_icon_url_whole = "http://ilife.ie/\(articlesources[indexPath.row].article_icon!)"
            var url = NSURL(string:article_icon_url_whole)
            let data = NSData(contentsOfURL: url!)
            cell.title_icon?.image = UIImage(data: data!)
        }else
        {
            cell.title_icon?.image = UIImage(named: "title_icon_default.png")
        }
//        cell.title_icon?.image = UIImage(data: NSData(contentsOfURL: NSURL(string:article_icon_url)!)!)
        
        //Load create time at the left of each tableview cell
        cell.created_at?.text = articlesources[indexPath.row].created_at
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowArticleDetail" {
            let detailViewController = segue.destinationViewController as? ArticleDetailViewController
            let myIndexPath = self.maintableview.indexPathForSelectedRow()
            let row = myIndexPath?.row
            detailViewController?.article_id_detail = articlesources[row!].article_id!
        }
    }
}