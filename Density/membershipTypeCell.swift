//
//  membershipTypeCell.swift
//  Density
//
//  Created by Lennart Hase on 31/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit

class membershipTypeCell: UITableViewCell {
    
    @IBOutlet weak var serviceIcon: UIImageView?
    @IBOutlet weak var serviceName: UILabel?
    @IBOutlet weak var serviceType: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
