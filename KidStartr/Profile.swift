//
//  Profile.swift
//  KidStartrApp
//
//  Created by Matt Keating on 5/14/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class Profile: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var profilePicture: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.NameTextField.delegate = self
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        
        self.addBottomLineToTextField(NameTextField)
    }
    
    
    @IBAction func PickImagePressed(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicture.contentMode = .scaleAspectFit
            self.profilePicture.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SaveNamePressed(_ sender: AnyObject) {
        
        let query = PFQuery(className: "UserCopy")
        
        let username = PFUser.current()?.username
        
        query.whereKey("Username", equalTo: username!)
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                for object in objects!{
                    if(self.NameTextField.text != ""){
                        object["Name"] = self.NameTextField.text
                    }
                    object.saveInBackground {
                        (success: Bool!, error: Error?) -> Void in
                        
                        if (success == false) {
                            
                            self.Alert("Error", Message: (error?.localizedDescription)!)
                            
                        } else {
                            
                            self.Alert("Success", Message: "")
                        }
                    }
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
