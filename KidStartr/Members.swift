//
//  Members.swift
//  KidStartr
//
//  Created by Matt Keating on 10/26/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import Parse
import UIKit

class Members: UITableViewController {
    
    var Members = [MembersObj]()
    var projectName = ""
    
    var shouldGoToOtherProfile = false
    
    var userSelectedName = ""
    
    func refresh(_ sender:AnyObject)
    {
        loadData()
        
        self.refreshControl?.endRefreshing()
    }
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl?.addTarget(self, action: #selector(JoinAProject.refresh(_:)), for: UIControlEvents.valueChanged)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    func loadData(){
        
        
        let query = PFQuery(className: "Project")
        query.whereKey("Name", equalTo: projectName)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                self.Members.removeAll()
                
                for object in objects! {
                    let array = (object["Members"] as! String).components(separatedBy: "*")
                    
                    for thing in array{
                        self.Members.append(MembersObj(Username: thing))
                    }
                    if(self.Members.count > 2){
                        self.Members.remove(at: 0)
                        self.Members.remove(at: self.Members.count - 1)
                        
                    }else{
                        self.Members.remove(at: 0)
                    }
                }
            }
        }
        
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!MembersCell
        
        var member : MembersObj
        
        member = Members[(indexPath as NSIndexPath).row]
        
        cell.UsernameTF.text = member.Username
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        shouldGoToOtherProfile = true
        
        userSelectedName = Members[(indexPath as NSIndexPath).row].Username
        
        self.performSegue(withIdentifier: "Profile", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(shouldGoToOtherProfile){
            shouldGoToOtherProfile = false
            
            let viewController: OtherUser = segue.destination as! OtherUser
            
            viewController.username = userSelectedName
        }
    }
}
