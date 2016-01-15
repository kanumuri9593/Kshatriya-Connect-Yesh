//
//  dataService.swift
//  Kshatriya-Connect-yesh
//
//  Created by Yeswanth varma Kanumuri on 1/12/16.
//  Copyright © 2016 Yeswanth varma Kanumuri. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://kshatriya-conncet.firebaseio.com"

class DataService {
    
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    
    
    var REF_BASE :Firebase {
    
    return _REF_BASE
    
    }
    
    var REF_POSTS :Firebase {
        
        return _REF_POSTS
        
    }
    
    var REF_USERS :Firebase {
        
        return _REF_USERS
        
    }
    
    var REF_USER_CURRENT :Firebase {
    
    let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID)
        
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath("uid")
        
        return user!
    
    }
    
    
    func createFireBaseUser (uid:String , user :Dictionary<String , String>) {
    
    REF_USERS.childByAppendingPath(uid).setValue(user)
    
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}