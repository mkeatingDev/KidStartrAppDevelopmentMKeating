//
//  Signup.swift
//  KidStartrApp
//
//  Created by Matt Keating on 5/8/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class Signup: UIViewController, UITextFieldDelegate {

    @IBOutlet var UsernameTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    @IBOutlet var CheckPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.UsernameTF.delegate = self
        self.PasswordTF.delegate = self
        self.CheckPasswordTF.delegate = self
        
        self.addBottomLineToTextField(UsernameTF)
        self.addBottomLineToTextField(PasswordTF)
        self.addBottomLineToTextField(CheckPasswordTF)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func signUp(){
        
        let user = PFUser()
        user.username = UsernameTF.text
        user.password = PasswordTF.text
        user["Name"] = UsernameTF.text
        user["FavAnimal"] = ""
        user["FavFood"] = ""
        user["FavSubject"] = ""
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                // They done messed up
                self.Alert("Error", Message: error.localizedDescription)
            } else {
                // Yeats it was a success
                self.performSegue(withIdentifier: "SignUpToLogin", sender: nil)
            }
        }
    }
    @IBAction func SignupButtonPressed(_ sender: AnyObject) {
        
        if (UsernameTF.text != "" && PasswordTF.text != "" && CheckPasswordTF.text != ""){
            if PasswordTF.text == CheckPasswordTF.text{
                signUp()
            }else{
                self.Alert("Error", Message: "Passwords do not match")
            }
        }else{
            self.Alert("Error", Message: "Please fill in all fields")
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
