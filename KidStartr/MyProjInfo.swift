//
//  MyProjInfo.swift
//  KidStartr
//
//  Created by Matt Keating on 6/24/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class MyProjInfo: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var NameTF: UILabel!
    @IBOutlet var CreatorTF: UILabel!
    @IBOutlet var DescTF: UILabel!
    @IBOutlet var GoalTF: UILabel!
    @IBOutlet var MembersTF: UILabel!
    
    @IBOutlet var NameCTF: UILabel!
    @IBOutlet var CreatorCTF: UILabel!
    @IBOutlet var DescCTF: UILabel!
    @IBOutlet var GoalCTF: UILabel!
    @IBOutlet var MembersCTF: UILabel!
    
    var membersStr = [String]()
    var members = [MembersObj]()
    var shouldGoToMembers = false
    
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
    @IBAction func LeaderMembersPressed(_ sender: AnyObject) {
        convertToMembersObj()
        shouldGoToMembers = true
    }
    @IBAction func MemberMembersPressed(_ sender: AnyObject) {
        convertToMembersObj()
        shouldGoToMembers = true
    }
    @IBAction func MemberCommentPressed(_ sender: AnyObject) {
        shouldGoToMembers = false
    }
    @IBAction func LeaderCommentPressed(_ sender: AnyObject) {
        shouldGoToMembers = false
    }
    
    var holdName = ""
    
    var Name = String()
    var Creator = String()
    var Desc = String()
    var Goal = String()
    
    var comments = [Comment]()
    
    var gate = false
    var secondGate = false
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(NameTF != nil){
            tableView.delegate = self
            tableView.dataSource = self
            
            holdName = Name
            
            tableView.separatorStyle = .none
            
            retrieveMembers(MembersTF)
            queryComments()
        }
        if(NameTF == nil){
            cTableView.delegate = self
            cTableView.dataSource = self
            
            holdName = Name
            
            cTableView.separatorStyle = .none
            
            retrieveMembers(MembersCTF)
            queryComments()
        }
        //all this does is configures the display on the project info
        if(NameTF != nil){
            
            NameTF.text = Name
            CreatorTF.text = "Creator: " + Creator
            DescTF.text = Desc
            GoalTF.text = "Goal: " + Goal
            
        }else{
            
            NameCTF.text = Name
            CreatorCTF.text = "Creator: " + Creator
            DescCTF.text = Desc
            GoalCTF.text = "Goal: " + Goal
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(tableView != nil){
            queryComments()
        }
    }
    @IBAction func RefreshPressedOnMember(_ sender: AnyObject) {
        retrieveMembers(MembersTF)
        queryComments()
    }
    @IBAction func refreshPressedOnLeader(_ sender: AnyObject) {
        retrieveMembers(MembersCTF)
        queryComments()
    }
    @IBAction func LeaveProjectPressed(_ sender: AnyObject) {
        
        let q = PFQuery(className:"Project")
        q.whereKey("Name", equalTo: Name)
        q.whereKey("Creator", equalTo: Creator)
        q.whereKey("Members", contains: PFUser.current()?.username)
        q.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                if objects?.isEmpty == false{
                    
                    let query = PFQuery(className:"Project")
                    query.whereKey("Name", equalTo: self.Name)
                    query.whereKey("Creator", equalTo: self.Creator)
                    query.findObjectsInBackground {
                        (objects: [PFObject]?, error: Error?) -> Void in
                        if error == nil {
                            
                            for object in objects! {
                                
                                //makes an array which stores all the users in the members catigory
                                var array = (object["Members"] as AnyObject).components(separatedBy: "*")
                                
                                var i = 0
                                //iterates through the array and finds where the user is and removes the user from the array
                                while(i < array.count){
                                    if(array[i] == PFUser.current()?.username){
                                        array.remove(at: i)
                                    }
                                    i = i + 1
                                }
                                
                                var j = 0
                                //At the last possible moment(To avoid any possible errors later on in runtime) the current members list is erased
                                object["Members"] = ""
                                //The array is then turned into a string stored in the members string
                                while(j < array.count - 1){
                                    object["Members"] = object["Members"] as! String + array[j] + "*"
                                    j = j + 1
                                }
                                //The object is saved with the new members string
                                object.saveInBackground()
                                
                                self.gate = true
                                self.performSegue(withIdentifier: "segue", sender: nil)
                            }
                            
                        }else{
                            self.Alert("Error", Message: "Project does not exist anymore")
                        }
                    }
                }else{
                    self.Alert("You have already left", Message: "")
                }
            }
        }
    }
    
    
    @IBAction func DeletePressed(_ sender: AnyObject) {
        deleteProject()
    }
    
    func deleteProject(){
        //this method is used if the leader chooses to delete the project
        
        //first we delete the project itself
        let query = PFQuery(className: "Project")
        query.whereKey("Name", equalTo: Name)
        query.whereKey("Creator", equalTo: Creator)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    //deletes the project
                    object.deleteInBackground()
                }
            }
        }
        
        //Then we have to remomve all of the comments on the project
        let query2 = PFQuery(className: "Comment")
        query2.whereKey("Project", equalTo: holdName)
        query2.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    //deletes the comments
                    object.deleteInBackground()
                }
            }
        }
        
        self.secondGate = true
        self.performSegue(withIdentifier: "segue", sender: nil)
    }
    func Alert(_ t: String, Message: String){
        // create the alert
        let alert = UIAlertController(title: t, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    ////////////////
    let textCellIdentifier = "textCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! CommentViewCell
        
        var comment : Comment
        
        comment = comments[(indexPath as NSIndexPath).row]
        
        cell.Comment.text = comment.Creator + comment.Text
        
        return cell
    }
    func queryComments(){
        let query = PFQuery(className:"Comment")
        query.whereKey("Project", equalTo: holdName)
        query.order(byDescending: "_created_at")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                var storeArray = [Comment]()
                
                storeArray.append(Comment(Creator: "", Text: "Comments:"))
                
                for object in objects! {
                    
                    let foo = Comment(Creator: object["Creator"] as! String + ": ", Text: object["Text"] as! String)
                    storeArray.append(foo)
                        
                }
                
                self.comments = storeArray
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    func retrieveMembers(_ label: UILabel){
        let query = PFQuery(className: "Project")
        query.whereKey("Name", equalTo: holdName)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                for object in objects! {
                    let array = (object["Members"] as! String).components(separatedBy: "*")
                    
                    self.membersStr = array
                    
                    label.text = "Members: " + String(array.count - 2)
                }
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(shouldGoToMembers){
            let viewController: Members = segue.destination as! Members
            
            viewController.Members = members
        }
        else if(!gate && !secondGate){
            let viewController: CommentSection = segue.destination as! CommentSection
            
            viewController.comments = comments
            viewController.project = holdName
        }
    }
}
