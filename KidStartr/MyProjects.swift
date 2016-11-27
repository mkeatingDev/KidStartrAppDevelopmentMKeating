//
//  MyProjects.swift
//  KidStartrApp
//
//  Created by Matt Keating on 5/14/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class MyProjects: UITableViewController {
    
    var MyProjects = [ProjectsObj]()
    
    var HoldProjectName = ""
    var HoldProjectCreator = ""
    var HoldProjectDesc = ""
    var HoldProjectGoal = ""
    var HoldProjectLocation = ""
    
    var gate = false
    
    var shouldRefresh = false
    
    func refresh(_ sender:AnyObject)
    {
        loadData()
        
        self.refreshControl?.endRefreshing()
    }
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        MyProjects.append(ProjectsObj(Name: "Loading...", Creator: "", Desc: "", Goal: "", Location: ""))
        
        self.refreshControl?.addTarget(self, action: #selector(JoinAProject.refresh(_:)), for: UIControlEvents.valueChanged)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    
        loadData()
    }
    func loadData(){
        let query = PFQuery(className:"Project")
        query.whereKey("Members", contains: "*" + (PFUser.current()?.username)! + "*")
        query.order(byDescending: "Name")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                var StoreArray = [ProjectsObj]()
                
                for object in objects! {
                    
                    let foo = ProjectsObj(Name: object["Name"] as! String, Creator: object["Creator"] as! String, Desc: object["Disc"] as! String, Goal: object["Goal"] as! String, Location: ((object["City"] as! String) + ", " + (object["State"] as! String)))
                    StoreArray.append(foo)
                    
                }
                if(StoreArray.count == 0){
                    StoreArray.append(ProjectsObj(Name: "No Projects Yet...", Creator: "Add Projects With Join A Project", Desc: "", Goal: "", Location: ""))
                }
                self.MyProjects = StoreArray
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }else{
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(gate == true){
            let viewController: MyProjInfo = segue.destination as! MyProjInfo
            
            viewController.Name = HoldProjectName
            viewController.Creator = HoldProjectCreator
            viewController.Desc = HoldProjectDesc
            viewController.Goal = HoldProjectGoal
            viewController.Location = HoldProjectLocation
            
            gate = false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyProjects.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! ProjectsCell
        
        var myProjects : ProjectsObj
        
        myProjects = MyProjects[(indexPath as NSIndexPath).row]
        
        cell.TitleTF.text = myProjects.Name
        if(myProjects.Creator == ""){
            cell.LeaderTF.text = ""
        }else if(myProjects.Desc == ""){
            cell.LeaderTF.text = myProjects.Creator
        }else if(PFUser.current()?.username == myProjects.Creator){
            cell.LeaderTF.text = "Status: Leader"
        }else{
            cell.LeaderTF.text = "Status: Member"
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(MyProjects[(indexPath as NSIndexPath).row].Desc == ""){
            
        }else{
            gate = true
            
            HoldProjectName = MyProjects[(indexPath as NSIndexPath).row].Name
            HoldProjectCreator = MyProjects[(indexPath as NSIndexPath).row].Creator
            HoldProjectDesc = MyProjects[(indexPath as NSIndexPath).row].Desc
            HoldProjectGoal = MyProjects[(indexPath as NSIndexPath).row].Goal
            HoldProjectLocation = MyProjects[(indexPath as NSIndexPath).row].Location
            
            if(HoldProjectCreator == PFUser.current()?.username){
                self.performSegue(withIdentifier: "Creator", sender: nil)
            }else{
                self.performSegue(withIdentifier: "ProjectInfo", sender: nil)
            }
        }
    }
}
