//
//  ProjectsCell.swift
//  KidStartr
//
//  Created by Matt Keating on 6/20/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit

class ProjectsCell: UITableViewCell {

    @IBOutlet var LeaderTF: UILabel!
    @IBOutlet var TitleTF: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
