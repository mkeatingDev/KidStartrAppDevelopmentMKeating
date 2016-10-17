//
//  CommentCell.swift
//  KidStartr
//
//  Created by Matt Keating on 8/3/16.
//  Copyright © 2016 Matt Keating. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet var CommenterTf: UILabel!
    @IBOutlet var CommentTf: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
