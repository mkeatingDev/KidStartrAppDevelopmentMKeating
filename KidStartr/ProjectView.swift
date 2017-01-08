//
//  ProjectView.swift
//  KidStartr
//
//  Created by Matt Keating on 1/1/17.
//  Copyright © 2017 Matt Keating. All rights reserved.
//

import Parse
import UIKit

class ProjectView: UITableViewController {
    
    var Projects = [ProjectsObj]()
    var projectName = ""
    
    var shouldGoToProject = false
    
    var userSelectedName = ""
    var userSelectedCreator = ""
    var userSelectedDesc = ""
    var userSelectedGoal = ""
    var userSelectedLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Projects.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!ProjectsViewCell
        
        var project : ProjectsObj
        
        project = Projects[(indexPath as NSIndexPath).row]
        
        cell.TitleTF.text = project.Name
        cell.LeaderTF.text = project.Location
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        shouldGoToProject = true
        
        userSelectedName = Projects[(indexPath as NSIndexPath).row].Name
        userSelectedCreator = Projects[(indexPath as NSIndexPath).row].Creator
        userSelectedDesc = Projects[(indexPath as NSIndexPath).row].Desc
        userSelectedGoal = Projects[(indexPath as NSIndexPath).row].Goal
        userSelectedLocation = Projects[(indexPath as NSIndexPath).row].Location
        
        self.performSegue(withIdentifier: "ToJoin", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(shouldGoToProject){
            shouldGoToProject = false
            
            let viewController: JoinProjInfo = segue.destination as! JoinProjInfo
            
            viewController.ProjectName = userSelectedName
            viewController.ProjectCreator = userSelectedCreator
            viewController.ProjectDesc = userSelectedDesc
            viewController.projectGoal = userSelectedGoal
            viewController.projectLocation = userSelectedLocation
        }
    }
}
