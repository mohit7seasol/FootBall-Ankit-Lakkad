//
//  InfoCell.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import UIKit
import MarqueeLabel

class InfoCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var infoLbl: MarqueeLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sepView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
