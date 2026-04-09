//
//  PlayerLiveUpdateCell.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import UIKit
import MarqueeLabel

class PlayerLiveUpdateCell: UITableViewCell {

    @IBOutlet weak var timeLbl: Label!
    @IBOutlet weak var scoreLbl: MarqueeLabel!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var cardTypeLbl: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
