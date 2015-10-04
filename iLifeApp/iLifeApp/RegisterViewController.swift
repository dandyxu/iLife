//
//  RegisterViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 02/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class RegisterViewController:UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func SignUpButton(sender: AnyObject) {
        //API NO.2 User Sign Up
        let urlPath = "http://ilife.ie/mobile_user_sign_up"
        let request = NSMutableURLRequest(URL:NSURL(string: urlPath)!)
        request.HTTPMethod = "POST"
        
        
        var postEmail = emailText.text
        var postPassword = passwordText.text
        var postUsername = usernameText.text
        
        
        var postString = "email=\(postEmail)&password=\(postPassword)&name=\(postUsername)"
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
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    if json["code"] as! Int == 3 {
                        println("can't singup, email has been registered")
                    }
                    if json["code"] as! Int == 1000 {
                        println("Sign up succeed!")
                }
            }
        })
        task.resume()
        
    }
    
    @IBAction func SingInJumpButton(sender: AnyObject) {
        
    }
    
}
