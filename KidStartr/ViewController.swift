//
//  ViewController.swift
//  KidStartrApp
//
//  Created by Matt Keating on 5/7/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var UsernameTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.UsernameTF.delegate = self
        self.PasswordTF.delegate = self
        
        self.addBottomLineToTextField(UsernameTF)
        self.addBottomLineToTextField(PasswordTF)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func logIn(){
        let username = UsernameTF.text
        let password = PasswordTF.text
        
        PFUser.logInWithUsername(inBackground: username!, password:password!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegue(withIdentifier: "LoginToTabController", sender: nil)
            } else {
                // The login failed. Check error to see why.
                let errorString = error?.localizedDescription
                // They done messed up
                self.Alert("Error", Message: errorString!)
            }
        }
    }
    @IBAction func LoginPressed(_ sender: AnyObject) {
        logIn()
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
