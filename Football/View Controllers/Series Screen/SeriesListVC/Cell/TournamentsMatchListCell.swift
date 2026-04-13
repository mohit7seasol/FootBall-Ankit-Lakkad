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
    @IBOutlet weak var dateLabel: UILabel! // Text formate like: '12 Jun • 06:30 PM'
    
    @IBOutlet weak var teamAflagImageView: UIImageView!
    @IBOutlet weak var teamANameLabel: MarqueeLabel!
    
    @IBOutlet weak var teamBFlagImageView: UIImageView!
    @IBOutlet weak var teamBnameLabel: MarqueeLabel!
    
    @IBOutlet weak var scoreLabel: UILabel! // Text formate like: '0  :  2'
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
