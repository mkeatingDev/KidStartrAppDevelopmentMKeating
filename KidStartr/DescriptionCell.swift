//
//  DescriptionCell.swift
//  KidStartr
//
//  Created by Matt Keating on 1/9/17.
//  Copyright © 2017 Matt Keating. All rights reserved.
//

import UIKit

struct DescObj{
    let Name: String
    let Description: String
}

class DescriptionCell: UITableViewCell {
    
    @IBOutlet var NameTF: UILabel!
    @IBOutlet var DescriptionTF: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
