//
//  JoinAProject.swift
//  KidStartrApp
//
//  Created by Matt Keating on 6/8/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class JoinAProject: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var Projects = [ProjectsObj]()
    var FilteredProjects = [ProjectsObj]()
    
    var HoldProjectName = ""
    var HoldProjectCreator = ""
    var HoldProjectDesc = ""
    var HoldProjectGoal = ""
    var HoldProjectLocation = ""
    
    func refresh(_ sender:AnyObject)
    {
        
        loadData()
        
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Projects.append(ProjectsObj(Name: "Loading...", Creator: "", Desc: "", Goal: "", Location: ""))
        
        loadData()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.refreshControl?.addTarget(self, action: #selector(JoinAProject.refresh(_:)), for: UIControlEvents.valueChanged)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        FilteredProjects = Projects.filter { Projects in
            return Projects.Name.lowercased().contains(searchText.lowercased())
        }
        FilteredProjects += Projects.filter{ Projects in
            return Projects.Location.lowercased().contains(searchText.lowercased())
        }
        //Sort through the array and delete any repeated elements
        for project in FilteredProjects{
            var i = 0;
            var u = 0;
            //i(variable, not me) will count how many of the certain index exists
            //1 is anticipated, > 1 is bad
            for project2 in FilteredProjects{
                u += 1;
                if(project2.Name == project.Name){
                    i += 1
                }
                if(i > 1){
                    FilteredProjects.remove(at: u-1)
                    break
                }
            }
        }
        
        tableView.reloadData()
    }
    func loadData(){
        
        let query = PFQuery(className:"Project")
        query.order(byDescending: "Name")
        query.whereKey("Creator", notEqualTo: (PFUser.current()?.username)!)
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                var StoreArray = [ProjectsObj]()
                
                for object in objects! {
                    let foo = ProjectsObj(Name: object["Name"] as! String, Creator: object["Creator"] as! String, Desc: object["Disc"] as! String, Goal: object["Goal"] as! String, Location: ((object["City"] as! String) + ", " + (object["State"] as! String)))
                    StoreArray.append(foo)
                    
                }
                self.Projects = StoreArray
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }else{
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController: JoinProjInfo = segue.destination as! JoinProjInfo
        
        viewController.ProjectName = HoldProjectName
        viewController.ProjectCreator = HoldProjectCreator
        viewController.ProjectDesc = HoldProjectDesc
        viewController.projectGoal = HoldProjectGoal
        viewController.projectLocation = HoldProjectLocation
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return FilteredProjects.count
        }else{
            return Projects.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "JoinCell", for: indexPath) as! JoinCell
        
        var projects : ProjectsObj
        
        if searchController.isActive && searchController.searchBar.text != "" {
            projects = FilteredProjects[(indexPath as NSIndexPath).row]
        }else{
            projects = Projects[(indexPath as NSIndexPath).row]
        }
        
        cell.TitleTF.text = projects.Name
        if(projects.Creator == ""){
            cell.LeaderTF.text = ""
        }else{
            cell.LeaderTF.text = projects.Location
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Projects[(indexPath as NSIndexPath).row].Creator == ""){
            
        }else if searchController.isActive && searchController.searchBar.text != "" {
            HoldProjectName = FilteredProjects[(indexPath as NSIndexPath).row].Name
            HoldProjectCreator = FilteredProjects[(indexPath as NSIndexPath).row].Creator
            HoldProjectDesc = FilteredProjects[(indexPath as NSIndexPath).row].Desc
            HoldProjectGoal = FilteredProjects[(indexPath as NSIndexPath).row].Goal
            HoldProjectLocation = FilteredProjects[(indexPath as NSIndexPath).row].Location
            self.performSegue(withIdentifier: "Join", sender: nil)
        }else{
            HoldProjectName = Projects[(indexPath as NSIndexPath).row].Name
            HoldProjectCreator = Projects[(indexPath as NSIndexPath).row].Creator
            HoldProjectDesc = Projects[(indexPath as NSIndexPath).row].Desc
            HoldProjectGoal = Projects[(indexPath as NSIndexPath).row].Goal
            HoldProjectLocation = Projects[(indexPath as NSIndexPath).row].Location
            self.performSegue(withIdentifier: "Join", sender: nil)
        }
       
    }
}
extension JoinAProject: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
