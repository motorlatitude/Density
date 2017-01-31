//
//  characterTableViewCell.swift
//  Density
//
//  Created by Lennart Hase on 30/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit

class characterTableViewCell: UITableViewCell {

    @IBOutlet weak var emblem: UIImageView?
    @IBOutlet weak var emblemIcon: UIImageView?
    @IBOutlet weak var classNameLabel: UILabel?
    @IBOutlet weak var characterLevelLabel: UILabel?
    @IBOutlet weak var characterLightLevelLabel: UILabel?
    @IBOutlet weak var raceGenderLabel: UILabel?
    @IBOutlet weak var levelProgress: UIProgressView?
    var characterData: [String: Any]?
    var characterRaceData: [String: Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        levelProgress?.transform = (levelProgress?.transform)!.scaledBy(x: 1, y: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
