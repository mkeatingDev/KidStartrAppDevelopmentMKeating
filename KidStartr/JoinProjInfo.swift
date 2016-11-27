//
//  JoinProjInfo.swift
//  KidStartr
//
//  Created by Matt Keating on 6/20/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class JoinProjInfo: UIViewController {

    @IBOutlet var ProjectNameTF: UILabel!
    @IBOutlet var ProjectCreatorTF: UILabel!

    @IBOutlet var ProjectDescTF: UILabel!
    @IBOutlet var ProjectGoalTF: UILabel!
    @IBOutlet var LocationTF: UILabel!
    
    @IBOutlet var ProjectMembersTF: UILabel!
    
    var membersStr = [String]()
    var members = [MembersObj]()
    var shouldGoToMembers = false
    
    @IBAction func MembersPressed(_ sender: AnyObject) {
        convertToMembersObj()
        shouldGoToMembers = true
    }
    
    //Variables that are passed from the previous view controllers
    var ProjectName = String()
    var ProjectCreator = String()
    var ProjectDesc = String()
    var projectGoal = String()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        ProjectNameTF.text = ProjectName
        ProjectCreatorTF.text = "Creator: " + ProjectCreator
        ProjectDescTF.text = ProjectDesc
        ProjectGoalTF.text = "Goal: " + projectGoal
        
        retrieveMembers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func retrieveMembers(){
        let query = PFQuery(className: "Project")
        query.whereKey("Name", equalTo: ProjectName)
        query.whereKey("Creator", equalTo: ProjectCreator)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                for object in objects! {
                    let array = (object["Members"] as! String).components(separatedBy: "*")
                    
                    self.membersStr = array
                    
                    self.ProjectMembersTF.text = "Members: " + String(array.count - 2)
                }
            }
            
        }

    }
    func convertToMembersObj(){
        members.removeAll()
        
        for object in membersStr{
            members.append(MembersObj(Username: object))
        }
        if(members.count > 2){
            members.remove(at: 0)
            members.remove(at: members.count - 1)

        }else{
            members.remove(at: 0)
        }
    }
    
    @IBAction func RefreshPressed(_ sender: AnyObject) {
        retrieveMembers()
    }
    @IBAction func JoinPressed(_ sender: AnyObject) {
        //Method that adds the username to the string that contains the users
        let query = PFQuery(className:"Project")
        query.whereKey("Name", equalTo: ProjectName)
        query.whereKey("Creator", equalTo: ProjectCreator)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                for object in objects! {
                    
                    if (object["Members"] as! String).contains("*" + (PFUser.current()?.username)! + "*"){
                        self.Alert("Oops", Message: "You are already a member")
                    }else{
                        let foo = object["Members"]
                        
                        object["Members"] = foo as! String + (PFUser.current()?.username)! + "*"
                        
                        object.saveInBackground()
                        
                        self.Alert("Success", Message: "")
                    }
                    
                }
                
            }else{
                self.Alert("Error", Message: "Project does not exist anymore")
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(shouldGoToMembers){
            let viewController: Members = segue.destination as! Members
            
            viewController.Members = members
            viewController.projectName = ProjectName
        }
    }
   
    func Alert(_ t: String, Message: String){
        // create the alert
        let alert = UIAlertController(title: t, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}
