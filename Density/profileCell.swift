//
//  profileTableViewCell.swift
//  Density
//
//  Created by Lennart Hase on 03/02/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit

class profileCell: UITableViewCell {

    @IBOutlet weak var header:UIImageView?
    @IBOutlet weak var profileIcon:UIImageView?
    @IBOutlet weak var displayUsername:UILabel?
    @IBOutlet weak var userTitleDisplay:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradient = CAGradientLayer()
        gradient.frame = (header?.bounds)!
        gradient.colors = [UIColor(red:0.10, green:0.11, blue:0.13, alpha:0.2).cgColor,UIColor(red:0.10, green:0.11, blue:0.13, alpha:1).cgColor]
        header?.layer.insertSublayer(gradient, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
