//
//  reminderCustomCell.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 30/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import UIKit

class reminderCustomCell: UITableViewCell {
  
    @IBOutlet weak var reminderLbl: UILabel!
    @IBOutlet weak var switchControls: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
