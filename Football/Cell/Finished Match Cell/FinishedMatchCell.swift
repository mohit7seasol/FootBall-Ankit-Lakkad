//
//  FinishedMatchCell.swift
//  Football
//
//  Created by Ronik Hirpara on 15/02/25.
//

import UIKit
import MarqueeLabel

class FinishedMatchCell: UICollectionViewCell {

    @IBOutlet weak var matchNameLbl: MarqueeLabel!
    @IBOutlet weak var dateLbl: MarqueeLabel!
    @IBOutlet weak var resultLbl: MarqueeLabel!
    @IBOutlet weak var scoreLbl: MarqueeLabel!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var match1Img: UIImageView!
    @IBOutlet weak var match1Lbl: UILabel!
    @IBOutlet weak var match2Img: UIImageView!
    @IBOutlet weak var match2Lbl: UILabel!
    @IBOutlet weak var completeView: View!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.completeView.cornerRadius = self.completeView.frame.height/2
        self.match1Img.layer.cornerRadius = self.match1Img.frame.height/2
        self.match2Img.layer.cornerRadius = self.match2Img.frame.height/2
    }

}

