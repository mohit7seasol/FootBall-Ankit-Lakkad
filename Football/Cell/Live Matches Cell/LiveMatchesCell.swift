//
//  LiveMatchesCell.swift
//  Football
//
//  Created by Ronik Hirpara on 15/02/25.
//

import UIKit
import MarqueeLabel

class LiveMatchesCell: UICollectionViewCell {

    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var redDotView: UIView!
    @IBOutlet weak var matchNameLbl: MarqueeLabel!
    @IBOutlet weak var match1Lbl: UILabel!
    @IBOutlet weak var match1Img: UIImageView!
    @IBOutlet weak var match2Lbl: UILabel!
    @IBOutlet weak var match2Img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.liveView.layer.cornerRadius = self.liveView.bounds.height / 2
//        self.match1Img.layer.cornerRadius = self.match1Img.bounds.height / 2
//        self.match2Img.layer.cornerRadius = self.match2Img.bounds.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        match1Img.image = nil
        match2Img.image = nil
        matchNameLbl.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.liveView.layer.cornerRadius = self.liveView.bounds.height / 2
        self.match1Img.layer.cornerRadius = self.match1Img.bounds.height / 2
        self.match2Img.layer.cornerRadius = self.match2Img.bounds.height / 2
        
        self.liveView.clipsToBounds = true
        self.match1Img.clipsToBounds = true
        self.match2Img.clipsToBounds = true
    }

}
