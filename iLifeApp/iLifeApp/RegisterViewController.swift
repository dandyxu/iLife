//
//  RegisterViewController.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 02/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class RegisterViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set textfield delegate
        self.emailText.delegate = self
        self.usernameText.delegate = self
        self.passwordText.delegate = self
    }
    
    @IBAction func SignUpButton(sender: AnyObject) {
        //API NO.2 User Sign Up
        let urlPath = "http://ilife.ie/mobile_user_sign_up"
        let request = NSMutableURLRequest(URL:NSURL(string: urlPath)!)
        request.HTTPMethod = "POST"
        
        var postEmail = emailText.text
        var postPassword = passwordText.text
        var postUsername = usernameText.text
        
        //check for empty field
        if (postEmail.isEmpty || postPassword.isEmpty || postUsername.isEmpty) {
            //display alert message
            alertMessage("All fields are required!")
        }else
        
        //check for email address
        if isValidEmail(postEmail) == false {
            alertMessage("Email address format is wrong!")
        }else
        
        //check for password length
        if count(postPassword) < 6 {
            alertMessage("Password must be at least 6 characters")
        }else {
        
            //start HTTP POST request
            var postString = "email=\(postEmail)&password=\(postPassword)&name=\(postUsername)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> Void in
                    if error != nil {
                        println(error)
                    }else {
//                  println(response)
//                  let responseString = NSString(data:data, encoding:NSUTF8StringEncoding)
//                  println(responseString)
                            
                        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary{
                            if json["code"] as? Int == 3 {
                                //switch back to main thread
                                NSOperationQueue.mainQueue().addOperationWithBlock{
                                    self.alertMessage("This email address has been already registered. Please try another one!")
                                }
                            }
                            if json["code"] as? Int == 1000 {
                                println("Sign up succeed!")
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
    
    //validate email address format
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = emailStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true:false
        return result
    }
    
    //Click away from keyboard to close the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //Click Return button to close the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func SingInJumpButton(sender: AnyObject) {
        
    }
    
}
