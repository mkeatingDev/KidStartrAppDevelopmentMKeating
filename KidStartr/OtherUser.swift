//
//  OtherUser.swift
//  KidStartr
//
//  Created by Matt Keating on 11/6/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import Parse
import UIKit

class OtherUser: UIViewController{
    
    var username = ""
    var numberOfProjects = 0
    
    @IBOutlet var ProfilePicture: UIImageView!
    
    @IBOutlet var NameTF: UILabel!
    @IBOutlet var UsernameTF: UILabel!
    @IBOutlet var ProjectsTF: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.ProfilePicture.layer.cornerRadius = self.ProfilePicture.frame.size.width / 2
        self.ProfilePicture.clipsToBounds = true
        
        self.UsernameTF.text = username
        
        retrieveInfo()
        retrieveProjectInfo()
    }
    func retrieveInfo(){
        let query = PFQuery(className:"UserCopy")
        query.whereKey("Username", equalTo: username)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for object in objects!{
                    self.NameTF.text = object["Name"] as! String?
                }
            }
        }
        
    }
    func retrieveProjectInfo(){
        let query2 = PFQuery(className: "Project")
        query2.whereKey("Members", contains: "*" + username + "*")
        query2.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for _ in objects!{
                    self.numberOfProjects += 1
                }
                self.ProjectsTF.text = "Projects: " + String(self.numberOfProjects)
            }
        }
    }
}
