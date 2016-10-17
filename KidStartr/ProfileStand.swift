//
//  ProfileStand.swift
//  KidStartr
//
//  Created by Matt Keating on 6/16/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit
import Parse

class ProfileStand: UIViewController {

    @IBOutlet var NameTF: UILabel!
    @IBOutlet var UsernameTF: UILabel!
    
    @IBOutlet var FavAnimalTF: UILabel!
    @IBOutlet var FavFoodTF: UILabel!
    @IBOutlet var FavSubjectTF: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            let user = PFUser.current()
            
           NameTF.text = user?["Name"] as? String
            UsernameTF.text = "Username: " + (user?.username)!
            
            if(user?["FavAnimal"] as? String == ""){
                FavAnimalTF.text = "(None)"
            }else{
                FavAnimalTF.text = user?["FavAnimal"] as? String

            }
            if(user?["FavFood"] as? String == ""){
                FavFoodTF.text = "(None)"
            }else{
                FavFoodTF.text = user?["FavFood"] as? String
                
            }
            if(user?["FavSubject"] as? String == ""){
                FavSubjectTF.text = "(None)"
            }else{
                FavSubjectTF.text = user?["FavSubject"] as? String
                
            }
            
        }else{
            //Never should be triggered
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
