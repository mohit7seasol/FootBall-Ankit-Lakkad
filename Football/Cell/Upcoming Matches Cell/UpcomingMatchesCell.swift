//
//  UpcomingMatchesCell.swift
//  Football
//
//  Created by Ronik Hirpara on 15/02/25.
//

import UIKit
import MarqueeLabel

class UpcomingMatchesCell: UICollectionViewCell {

    @IBOutlet weak var matchNameLbl: MarqueeLabel!
    @IBOutlet weak var match1Lbl: MarqueeLabel!
    @IBOutlet weak var match2Lbl: MarqueeLabel!
    @IBOutlet weak var match1Img: UIImageView!
    @IBOutlet weak var match2Img: UIImageView!
    @IBOutlet weak var dateLbl: MarqueeLabel!
    @IBOutlet weak var timeLbl: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.match1Img.layer.cornerRadius = self.match1Img.bounds.height / 2
        self.match2Img.layer.cornerRadius = self.match2Img.bounds.height / 2
        
    }

}
