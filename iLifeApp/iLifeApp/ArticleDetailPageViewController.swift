//
//  ArticleDetailPageViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 05/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var title_image: UIImageView!
    
    @IBOutlet var article_title: UILabel!
    
    @IBOutlet weak var body_image: UIImageView!    

    @IBOutlet weak var article_body: UILabel!
    
    @IBOutlet weak var webSiteView: UIWebView!
    
    var article_id_detail:Int!
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let address = webSite {
//            let webURL = NSURL(string:address)
//            let urlRequest = NSURLRequest(URL:webURL!)
//            webSiteView.loadRequest(urlRequest)
//        }
        
        
        
        let article_urlPath = "http://ilife.ie/mobile_article_details"
        let request = NSMutableURLRequest(URL:NSURL(string: article_urlPath)!)
        request.HTTPMethod = "POST"
        
        //start HTTP POST Request
        var postString = "article_id=\(article_id_detail)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                println(error)
            }else {
                //                println(response)
                //                let responseString = NSString(data:data, encoding:NSUTF8StringEncoding)
                //                println(responseString)
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    //                        println(json)
                    if json["code"] as? Int == 5 {
                        println("article detail is not found")
                    }else{
                        if var jsonData = json["data"] as? NSDictionary {
                            NSOperationQueue.mainQueue().addOperationWithBlock{
                                //article title
                                self.article_title.text! = jsonData["title"] as! String
                                
                                //title image
                                if let title_image_url = jsonData["title_image"] as? String {
                                    let title_image_url_whole = "http://ilife.ie/\(title_image_url)"
                                    var title_image_data = self.getImageData(title_image_url_whole)
                                    self.title_image?.image = UIImage(data: title_image_data)
                                }else {
                                    self.title_image?.hidden = true
                                }
                                
                                //body image
                                if let body_image_url = jsonData["body_image"] as? String {
                                    let body_image_url_whole = "http://ilife.ie/\(body_image_url)"
                                    var body_image_data = self.getImageData(body_image_url_whole)
                                    self.body_image?.image = UIImage(data:body_image_data)
                                }else {
                                    self.body_image?.hidden = true
                                }
                                
                                //article body
                                self.article_body.text! = jsonData["article_body"] as! String
                                self.article_body?.numberOfLines = 0
                                self.article_body.lineBreakMode = NSLineBreakMode.ByWordWrapping
                                self.article_body.baselineAdjustment = UIBaselineAdjustment.AlignCenters
                
                                //created time
                                
                                //updated time
                                
                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    //Get imageinput url, output NSData
    func getImageData(imageURL:String) -> NSData{
        var url = NSURL(string:imageURL)
        var data = NSData(contentsOfURL: url!)
        return data!
    }
}
