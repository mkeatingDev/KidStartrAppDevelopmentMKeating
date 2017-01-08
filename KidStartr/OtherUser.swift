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
    
    var shouldGoToProjects = false
    var storeProjects = [ProjectsObj]()
    
    @IBAction func ProjectsPressed(_ sender: Any) {
        shouldGoToProjects = true
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.ProfilePicture.layer.cornerRadius = self.ProfilePicture.frame.size.width / 2
        self.ProfilePicture.clipsToBounds = true
        self.ProfilePicture.layer.borderWidth = 3
        
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
    func retrieveProjectInfo(){
        let query2 = PFQuery(className: "Project")
        query2.whereKey("Members", contains: "*" + username + "*")
        query2.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                //Remove all projects in storeProjects
                self.storeProjects.removeAll()
                
                for project in objects!{
                    self.storeProjects.append(ProjectsObj(Name: project["Name"] as! String, Creator: project["Creator"] as! String, Desc: project["Disc"] as! String, Goal: project["Goal"] as! String, Location: (project["City"] as! String) + ", " + (project["State"] as! String)))
                    
                    self.numberOfProjects += 1
                }
                self.ProjectsTF.text = "Projects: " + String(self.numberOfProjects)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(shouldGoToProjects){
            let viewController: ProjectView = segue.destination as! ProjectView
            
            viewController.Projects = storeProjects
        }
    }
}
