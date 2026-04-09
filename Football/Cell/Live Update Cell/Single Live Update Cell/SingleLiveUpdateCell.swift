//
//  SingleLiveUpdateCell.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import UIKit
import MarqueeLabel

class SingleLiveUpdateCell: UITableViewCell {

    @IBOutlet weak var scoreLbl: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
