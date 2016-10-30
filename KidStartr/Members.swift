//
//  Members.swift
//  KidStartr
//
//  Created by Matt Keating on 10/26/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit

class Members: UITableViewController {
    
    var Members = [MembersObj]()
    
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
        
    }
}
