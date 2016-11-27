//
//  StartAProject.swift
//  KidStartr
//
//  Created by Matt Keating on 6/20/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class StartAProject: UIViewController, UITextFieldDelegate {

    @IBOutlet var ProjectNameTF: UITextField!
    @IBOutlet var DiscTF: UITextField!
    @IBOutlet var GoalTF: UITextField!
    @IBOutlet var CityTF: UITextField!
    @IBOutlet var StateTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ProjectNameTF.delegate = self
        self.DiscTF.delegate = self
        self.GoalTF.delegate = self
        self.CityTF.delegate = self
        self.StateTF.delegate = self
        
        self.addBottomLineToTextField(GoalTF)
        self.addBottomLineToTextField(ProjectNameTF)
        self.addBottomLineToTextField(DiscTF)
        self.addBottomLineToTextField(CityTF)
        self.addBottomLineToTextField(StateTF)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func CreatePressed(_ sender: AnyObject) {
        if(ProjectNameTF.text != ""){
            if(GoalTF.text != "" ){
                if(DiscTF.text != ""){
                    checkIfExist(ProjectNameTF.text!)
                }else{
                    self.Alert("Error", Message: "Please enter a project description")
                }
            }else{
                self.Alert("Error", Message: "Please enter a project goal")
            }
        }else{
            self.Alert("Error", Message: "Please enter a project name")
        }
    }
    func databaseWork(){
        let object = PFObject(className: "Project")
        object["Name"] = ProjectNameTF.text
        object["Disc"] = DiscTF.text
        object["Goal"] = GoalTF.text
        object["City"] = CityTF.text
        object["State"] = StateTF.text
        object["Creator"] = PFUser.current()?.username
        object["Members"] = "*" + (PFUser.current()?.username)! + "*"
        object.saveInBackground { (success, error) -> Void in
            if error == nil{
                self.Alert("Success", Message: "Project Created")
            }
        }
    }
    func checkIfExist(_ Name: String){
        let query = PFQuery(className: "Project")
        query.whereKey("Name", equalTo: Name)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                if objects!.count == 0{
                    self.databaseWork()
                }else{
                    self.Alert("Error", Message: "Project of that name already exists")
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    func addBottomLineToTextField(_ textField : UITextField) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
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
