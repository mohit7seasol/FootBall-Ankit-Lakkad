//
//  DomesticSeriesCell.swift
//  Football
//
//  Created by Ronik Hirpara on 14/02/25.
//

import UIKit
import MarqueeLabel

class DomesticSeriesCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
