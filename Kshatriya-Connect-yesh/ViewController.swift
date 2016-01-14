//
//  ViewController.swift
//  Kshatriya-Connect-yesh
//
//  Created by Yeswanth varma Kanumuri on 1/11/16.
//  Copyright © 2016 Yeswanth varma Kanumuri. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailadressText: materialTextfield!
    
    @IBOutlet weak var passwordText: materialTextfield!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
        
        
        performSegueWithIdentifier(SEG_LOGGED_IN, sender: nil)
        }
        
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func FbloginPressed (sender : UIButton!){
    
    let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult :FBSDKLoginManagerLoginResult!,facebookError: NSError!) -> Void in
            if facebookError != nil {
            
            print("facebook login failed")
            
            }else  {
            
              let  acessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                print("sucessfully logged in \(acessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: acessToken , withCompletionBlock: { error, authData -> Void in
                    
                    if error != nil {
                    
                    print("login failed! \(error)")
                        
                    } else {
                    
                    print("login sucessfull \(authData)")
                    
                   
                        let user = ["provider" :authData.provider! , "qwer":"zxcvf"]
                        
                        DataService.ds.createFireBaseUser(authData.uid, user: user)
                        
                        
                        
                        
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    
                  self.performSegueWithIdentifier(SEG_LOGGED_IN, sender: nil)
                        
                        
                    }
                        
                })
            
            
            }
        }
    
    
    }

    @IBAction func logInButnPressed(sender: AnyObject) {
        
        
        if let email = emailadressText.text where email != "" ,   let pwd = passwordText.text where pwd != "" {
        
            
        DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error , authData in
            
            
            if error != nil {
            
                print(error.code)
                print(error)
                
                if error.code == STATUS_WRONGPSWD {
                
                
                self.showErrorAlert("Wrong Password", msg: "please try again")
                
                
                }
                
                if error.code == STATUS_ACCOUNT_NONEXIST {
                
                DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error , result in
                    
                    
                    if error != nil {
                    
                    self.showErrorAlert("Coundnt create the account", msg: "Please try something else")
                    
                    } else  {
                    
                    
                    NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                        
                        
                    
                        
                        DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err , authData in
                        
                            let user = ["provider" :authData.provider! , "email":"teste"]
                            
                            DataService.ds.createFireBaseUser(authData.uid, user: user)

                        
                        
                        
                        })
                        
                        
                     self.performSegueWithIdentifier(SEG_LOGGED_IN, sender: nil)
                    
                    }
                    
                    
                    
                    
                    
                    
                })
                
                
                }
            
            } else {
            
            self.performSegueWithIdentifier(SEG_LOGGED_IN, sender: nil)
            
            
            }
            
            
            
            
        })
            
            
            
            
        
        
        }else {
        
        showErrorAlert("email and password needed", msg: "please enter valid details")
        }
        
       
    }
    
    func showErrorAlert (title :String! , msg :String!){
    
    let alert = UIAlertController(title: title, message: msg, preferredStyle:UIAlertControllerStyle.Alert)
    let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    
    }

}

