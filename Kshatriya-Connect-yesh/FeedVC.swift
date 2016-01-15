//
//  FeedVC.swift
//  Kshatriya-Connect-yesh
//
//  Created by Yeswanth varma Kanumuri on 1/12/16.
//  Copyright © 2016 Yeswanth varma Kanumuri. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController ,UITableViewDataSource , UITableViewDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    
    @IBOutlet weak var tableView :UITableView!
    
    @IBOutlet weak var postField: materialTextfield!
    
    var imageSelected = false
    
    
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
        
        imageSelected = true
        
        
    }

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }

    
    
    
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postField.text where txt != "" {
        
            if let img = imageSelectorImage.image where imageSelected == true {
            
            let urlStr = "https://post.imageshack.us/upload_api.php"
                
            let url = NSURL(string: urlStr)!
             
            let imgData = UIImageJPEGRepresentation(img, 0.2)!
                
            let keyData = ("1257JORUeadc106bd7ed6ad68fb0335830aed7b2").dataUsingEncoding(NSUTF8StringEncoding)!
                
            let KeyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
            
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData  in
                    
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    
                    multipartFormData.appendBodyPart(data: KeyJSON, name: "format")
                    
                    
                    
                    }) { encodingResult in
                        
                        switch encodingResult {
                            
                        case .Success(let upload, _, _):
                            
                            upload.responseJSON(completionHandler: { response in
                                
                                if let info = response.result.value as? Dictionary<String,AnyObject> {
                                    
                                    if let links = info["links"] as? Dictionary<String,AnyObject> {
                                        
                                        if let imageLink = links["image_link"] as? String {
                                            
                                           
                                            
                                            print("LINK: \(imageLink)")
                                            
                                            self.postToFirebase(imageLink)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            })
                            
                        case.Failure(let error):
                            
                            print(error)
                        
                        }
                       
                }
                
            } else {
            
            self.postToFirebase(nil)
            
            
            }
        
        
        
        
        }
        
        
        
    }
    
    
    func postToFirebase(imageUrl :String?) {
    
        var post :Dictionary<String ,AnyObject> = [
            "post" :postField.text!,
            "likes" : 0
        
        ]
        
        if imageUrl != nil {
        
        post["image Url"] = imageUrl!
            
        }
        
        let firebadePost = DataService.ds.REF_POSTS.childByAutoId()
        firebadePost.setValue(post)
        
        
        self.imageSelectorImage.image = UIImage(named: "camera")
        
        self.postField.text = ""
        
        imageSelected = false
        
        tableView.reloadData()
        
        
    
    }
    
    
    
    
    
    
    
    
    
}
