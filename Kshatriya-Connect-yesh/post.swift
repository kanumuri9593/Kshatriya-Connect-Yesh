//
//  post.swift
//  Kshatriya-Connect-yesh
//
//  Created by Yeswanth varma Kanumuri on 1/14/16.
//  Copyright © 2016 Yeswanth varma Kanumuri. All rights reserved.
//

import Foundation
import Firebase


class Post {

    private var _PostDescription : String!
    private var _imageUrl :String?
    private var _likes : Int!
    private var _username :String!
    private var _postKey :String!
    private var _postRef :Firebase!
    
    var postKey : String {
    
    return _postKey
    
    }
    
    var psotDescription :String {
    
    
    return _PostDescription
    }
    var imageUrl :String? {
    
    return _imageUrl
    }
    
    var likes :Int {
    
    
    return _likes
    }
    
    var username :String{
    
    
    return _username
    }
    
    init (description :String , imageUrl :String? ,username :String) {
    
    self._PostDescription = description
        self._username = username
        self._imageUrl = imageUrl
    
    
    }
    
    
    init (postkey :String ,dictionary :Dictionary<String , AnyObject>){
    
    self._postKey = postkey
        
        if let likes = dictionary["likes"] as? Int {
        
        self._likes = likes
        
        
        }
        if let imageUrl = dictionary["image Url"] as? String {
        
        self._imageUrl = imageUrl
        }
        
        if let desc = dictionary["post"] as? String {
        
        self._PostDescription = desc
        
        }
    
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
    
    }
    
    func adjustLikes(addLike :Bool) {
    
        if addLike {
        
        _likes = _likes + 1
        
        } else {
        
            _likes = _likes - 1
        
        }
    
     _postRef.childByAppendingPath("likes").setValue(_likes)
    }

}