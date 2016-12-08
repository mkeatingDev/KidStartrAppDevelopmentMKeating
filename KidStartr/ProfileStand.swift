//
//  ProfileStand.swift
//  KidStartr
//
//  Created by Matt Keating on 6/16/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class ProfileStand: UIViewController {

    @IBOutlet var ProfilePicture: UIImageView!
    
    @IBOutlet var NameTF: UILabel!
    @IBOutlet var UsernameTF: UILabel!
    @IBOutlet var ProjectsTF: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if PFUser.current() != nil {
            let user = PFUser.current()
            
            self.UsernameTF.text = user?.username
            
            self.ProfilePicture.layer.cornerRadius = self.ProfilePicture.frame.size.width / 2
            self.ProfilePicture.clipsToBounds = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let user = PFUser.current()
        self.UsernameTF.text = user?.username
        queryInfo(user: (user?.username)!)
        queryProjectInfo(user: (user?.username)!)
    }
    func queryInfo(user: String){
        let query = PFQuery(className:"UserCopy")
        query.whereKey("Username", equalTo: user)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for object in objects!{
                    self.NameTF.text = object["Name"] as! String?
                }
            }
        }
    }
    func queryProjectInfo(user: String){
        let query = PFQuery(className: "Project")
        query.whereKey("Members", contains: "*" + user + "*")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                var count = 0
                for _ in objects!{
                    count = count + 1
                }
                self.ProjectsTF.text = "Projects: " + String(count)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
