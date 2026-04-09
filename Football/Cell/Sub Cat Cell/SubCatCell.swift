//
//  SubCatCell.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import UIKit
import MarqueeLabel

class SubCatCell: UITableViewCell {

    @IBOutlet weak var matchNameLbl: MarqueeLabel!
    @IBOutlet weak var dateLbl: MarqueeLabel!
    @IBOutlet weak var resultLbl: MarqueeLabel!
    @IBOutlet weak var match1Img: UIImageView!
    @IBOutlet weak var match1Lbl: UILabel!
    @IBOutlet weak var match2Img: UIImageView!
    @IBOutlet weak var match2Lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.match1Img.layer.cornerRadius = self.match1Img.frame.height/2
        self.match2Img.layer.cornerRadius = self.match2Img.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
