//
//  InitialViewController.swift
//  KidStartr
//
//  Created by Matt Keating on 7/17/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//
import UIKit
import Parse

class InitialViewController: UIViewController {

    @IBOutlet var SignUp: UIButton!
    @IBOutlet var Login: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.editButtons(SignUp)
        self.editButtons(Login)
    }
    override func viewDidAppear(_ animated: Bool) {
        if(PFUser.current() != nil){
            //user is already logged in
            self.performSegue(withIdentifier: "loggedIn", sender: nil)

        }else{
            //do nothing
        }
    }
    func editButtons(_ button: UIButton){
        button.layer.borderWidth = 1.0
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor.gray.cgColor
        button.clipsToBounds = true
    }
}
