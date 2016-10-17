//
//  CommentSection.swift
//  KidStartr
//
//  Created by Matt Keating on 8/2/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class CommentSection: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var CommentEdit: UITextField!
    
    @IBOutlet var SendButton: UIButton!
    
    var comments = [Comment]()
    var project = String()
    
    var isAccessedFromCreator = true
    
    var holdProject = ""
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        holdProject = project
        
        CommentEdit.delegate = self
        
        editButtons(SendButton)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        if(comments[0].Creator == ""){
            comments.remove(at: 0)
        }
    }
    @IBAction func SendPressed(_ sender: AnyObject) {
        if(CommentEdit.text != ""){
            let comment = PFObject(className:"Comment")
            comment["Creator"] = PFUser.current()?.username
            comment["Project"] = holdProject
            comment["Text"] = CommentEdit.text
            comment.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            comments.insert(Comment(Creator: (PFUser.current()?.username)!, Text: CommentEdit.text!), at: 0)
            
            CommentEdit.text = ""
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    @IBAction func RefreshPressed(_ sender: AnyObject) {
        loadData()
    }
    func loadData(){
        let query = PFQuery(className:"Comment")
        query.whereKey("Project", equalTo: holdProject)
        query.order(byDescending: "_created_at")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                var storeArray = [Comment]()
                
                for object in objects! {
                    
                    let foo = Comment(Creator: object["Creator"] as! String, Text: object["Text"] as! String)
                    storeArray.append(foo)
                    
                }
                
                self.comments = storeArray
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentCell
        
        var comment : Comment
        
        comment = comments[(indexPath as NSIndexPath).row]
        
        cell.CommenterTf.text = comment.Creator
        cell.CommentTf.text = comment.Text
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
   /* func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle==UITableViewCellEditingStyle.Delete){
            comments.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    func editButtons(_ button: UIButton){
        button.layer.borderWidth = 1.0
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.gray.cgColor
        button.clipsToBounds = true
    }
}
