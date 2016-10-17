//
//  Profile.swift
//  KidStartrApp
//
//  Created by Matt Keating on 5/14/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class Profile: UIViewController, UITextFieldDelegate {

    @IBOutlet var NameTextField: UITextField!
    
    @IBOutlet var FavSubjectTF: UITextField!
    @IBOutlet var FavFoodTF: UITextField!
    @IBOutlet var FavAnimalTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.NameTextField.delegate = self
        self.FavFoodTF.delegate = self
        self.FavSubjectTF.delegate = self
        self.FavAnimalTF.delegate = self
        
        self.addBottomLineToTextField(NameTextField)
        self.addBottomLineToTextField(FavFoodTF)
        self.addBottomLineToTextField(FavSubjectTF)
        self.addBottomLineToTextField(FavAnimalTF)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SaveBioPressed(_ sender: AnyObject) {
        PFUser.current()?["FavAnimal"] = FavAnimalTF.text
        PFUser.current()?["FavFood"] = FavFoodTF.text
        PFUser.current()?["FavSubject"] = FavSubjectTF.text
        
        PFUser.current()!.saveInBackground {
            (success: Bool!, error: Error?) -> Void in
            
            if (success == false) {
                
                self.Alert("Error", Message: (error?.localizedDescription)!)
                
            } else {
                
                self.Alert("Success", Message: "")
            }
        }

    }
    @IBAction func SaveNamePressed(_ sender: AnyObject) {
        PFUser.current()?["Name"] = NameTextField.text
        
        PFUser.current()!.saveInBackground {
            (success: Bool!, error: Error?) -> Void in
            
            if (success == false) {
                
               // let errorString = error!.userInfo["error"] as? NSString
                
                self.Alert("Error", Message: "Error")
                
            } else {
                
                self.Alert("Success", Message: "")
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
    @IBAction func LogOutPressed(_ sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Logout?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            PFUser.logOut()
            self.performSegue(withIdentifier: "logOut", sender: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in }))
        
        present(refreshAlert, animated: true, completion: nil)
        }
}
