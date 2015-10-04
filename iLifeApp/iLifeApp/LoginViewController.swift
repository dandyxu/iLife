//
//  LoginViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 02/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class LoginViewController:UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignInButton(sender: AnyObject) {
        //API No.1 User Login
        let urlPath = "http://ilife.ie/mobile_user_sign_in"
        let request = NSMutableURLRequest(URL:NSURL(string: urlPath)!)
        request.HTTPMethod = "POST"
        
        var postEmail = emailText.text
        var postPassword = passwordText.text
        
        var postString = "email=\(postEmail)&password=\(postPassword)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                println(error)
            }else {
                //println(response)
                //let responseString = NSString(data:data, encoding:NSUTF8StringEncoding)
                //println(responseString)
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    if json["code"] as! Int == 1 {
                        println("can't login, user not exist")
                    }
                    if json["code"] as! Int == 2 {
                        println("can't login, password is wrong")
                    }
                    if json["code"] as! Int == 1000 {
                        println("Login success!")
                    }
                
            }
        })
        task.resume()
        
    }
    
    @IBAction func SingUpJumpButton(sender: AnyObject) {
        
    }
    
    
}
