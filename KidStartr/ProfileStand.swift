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
    
    var shouldGoToProjects = false
    
    var storeProjects = [ProjectsObj]()
    
    @IBAction func ProjectsPressed(_ sender: Any) {
        shouldGoToProjects = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if PFUser.current() != nil {
            let user = PFUser.current()
            
            self.UsernameTF.text = user?.username
            
            self.ProfilePicture.layer.cornerRadius = self.ProfilePicture.frame.size.width / 2
            self.ProfilePicture.clipsToBounds = true
            self.ProfilePicture.layer.borderWidth = 3
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
                    if(object["Picture"] != nil){
                        let userImageFile = object["Picture"] as! PFFile
                        userImageFile.getDataInBackground {
                            (imageData: Data?, error: Error?) -> Void in
                            if error == nil {
                                let image = UIImage(data:imageData!)
                                self.ProfilePicture.image = image
                            }
                        }
                    }
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
                //Delete all projets in storeProjects first -.-
                self.storeProjects.removeAll()
                
                for project in objects!{
                    self.storeProjects.append(ProjectsObj(Name: project["Name"] as! String, Creator: project["Creator"] as! String, Desc: project["Disc"] as! String, Goal: project["Goal"] as! String, Location: (project["City"] as! String) + ", " + (project["State"] as! String)))
                    count = count + 1
                }
                self.ProjectsTF.text = "Projects: " + String(count)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(!shouldGoToProjects){
            let viewController: Profile = segue.destination as! Profile
            if(ProfilePicture.image != nil){
                viewController.image = ProfilePicture.image!
                viewController.shouldDisplayImage = true
            }
        }
        if(shouldGoToProjects){
            let viewController: ProjectView = segue.destination as! ProjectView
            
            viewController.Projects = storeProjects
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
