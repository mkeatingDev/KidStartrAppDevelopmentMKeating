//
//  ProjectViewCell.swift
//  KidStartr
//
//  Created by Matt Keating on 1/2/17.
//  Copyright © 2017 Matt Keating. All rights reserved.
//

import UIKit

class ProjectsViewCell: UITableViewCell {
    
    @IBOutlet var LeaderTF: UILabel!
    @IBOutlet var TitleTF: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
