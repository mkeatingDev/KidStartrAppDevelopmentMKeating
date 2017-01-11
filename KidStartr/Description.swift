//
//  Description.swift
//  KidStartr
//
//  Created by Matt Keating on 1/9/17.
//  Copyright © 2017 Matt Keating. All rights reserved.
//

import UIKit

class Description: UITableViewController {
    
    var descriptions = [DescObj]()
    
    var projectName = ""
    var projectDesc = ""
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        descriptions.append(DescObj(Name: projectName, Description: projectDesc))
        
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DescriptionCell
        
        var description : DescObj
        
        description = descriptions[(indexPath as NSIndexPath).row]
        
        cell.NameTF.text = description.Name
        cell.DescriptionTF.text = description.Description
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}

