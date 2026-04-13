//
//  TournamentsMatchListCell.swift
//  Football
//
//  Created by Mohit Kanpara on 13/04/26.
//

import UIKit
import MarqueeLabel

class TournamentsMatchListCell: UICollectionViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var teamAflagImageView: UIImageView!
    @IBOutlet weak var teamANameLabel: MarqueeLabel!
    
    @IBOutlet weak var teamBFlagImageView: UIImageView!
    @IBOutlet weak var teamBnameLabel: MarqueeLabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure cell appearance
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red: 0.082, green: 0.098, blue: 0.122, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update date view corner radius to be half of its height
        dateView.layer.cornerRadius = dateView.frame.height / 2
    }
}
