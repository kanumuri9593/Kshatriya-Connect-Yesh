//
//  FeedVC.swift
//  Kshatriya-Connect-yesh
//
//  Created by Yeswanth varma Kanumuri on 1/12/16.
//  Copyright © 2016 Yeswanth varma Kanumuri. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController ,UITableViewDataSource , UITableViewDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    
    @IBOutlet weak var tableView :UITableView!
    
    @IBOutlet weak var postField: materialTextfield!
    var posts = [Post]()
    
    var imagePicker : UIImagePickerController!
    
   static var imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.estimatedRowHeight = 358
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapShot in
        
        print(snapShot.value)
            
            self.posts = []
            
            if let snapshots = snapShot.children.allObjects as? [FDataSnapshot] {
            
                for snap in snapshots {
                print ("Snap : \(snap)")
                
                    if let postDict = snap.value as? Dictionary<String , AnyObject> {
                    
                    let key = snap.key
                    let post = Post(postkey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                    
                    
                    
                }
            
            
            }
            
            
            self.tableView.reloadData()
        
        })
        
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let post = posts[indexPath.row]
       // print(post.psotDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            var img : UIImage?
            
            if let url = post.imageUrl {
            
           img = FeedVC.imageCache.objectForKey(url) as? UIImage
            
            }
        
            cell.configureCell(post ,img :img)
            return cell
        
        } else {
        
            return PostCell()
        
        }
     
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
        
        return 150
        
        } else {
        
        return tableView.estimatedRowHeight
        
        }
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        imageSelectorImage.image = image
        
        
    }

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }

    
    
    
    @IBAction func makePost(sender: AnyObject) {
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
