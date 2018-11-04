//
//  tableViewCell.swift
//  QuickMeet
//
//  Created by Tyler Chan on 11/3/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    @IBOutlet var personImage: UIImageView!
    @IBOutlet var personName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
