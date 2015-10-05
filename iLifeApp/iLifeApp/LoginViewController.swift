//
//  LoginViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 02/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class LoginViewController:UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set textfield delegate
        self.emailText.delegate = self
        self.passwordText.delegate = self
    }
    
    @IBAction func SignInButton(sender: AnyObject) {
        //API No.1 User Login
        let urlPath = "http://ilife.ie/mobile_user_sign_in"
        let request = NSMutableURLRequest(URL:NSURL(string: urlPath)!)
        request.HTTPMethod = "POST"
        
        var postEmail = emailText.text
        var postPassword = passwordText.text
        
        //check for empty field
        if (postEmail.isEmpty || postPassword.isEmpty) {
            //display alert message
            alertMessage("All fields are required!")
        }else {
            
            //start HTTP POST Request
            var postString = "email=\(postEmail)&password=\(postPassword)"
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
                        if json["code"] as? Int == 1 {
                            NSOperationQueue.mainQueue().addOperationWithBlock{
                                self.alertMessage("Can't login, User does not exist. Please check email address and try again")
                            }
                        }
                        if json["code"] as? Int == 2 {
                            NSOperationQueue.mainQueue().addOperationWithBlock{
                                self.alertMessage("Can't login, Password is incorrect!")
                            }
                        }
                        if json["code"] as? Int == 1000 {
                            println("Login success!")
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    //alert message
    func alertMessage(usermessage:String){
        
        var alert = UIAlertController(title:"Whoops...", message:usermessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler:nil)
        alert.addAction(okButton)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //click away from keyboard to close the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //click Return button to close the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SingUpJumpButton(sender: AnyObject) {
        
    }
    
    
}
