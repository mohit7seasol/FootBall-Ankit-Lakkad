//
//  MatchListCell.swift
//  Football
//
//  Created by Mohit Kanpara on 10/04/26.
//

import UIKit

class MatchListCell: UICollectionViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel! // Text Formate like when Live then '12 Jun • 06:30 PM', when upcoming then '06:30 PM', when Completed then '06:30 PM'
    
    @IBOutlet weak var teamAFlagImageView: UIImageView!
    @IBOutlet weak var teamBFlagImageView: UIImageView!
    @IBOutlet weak var vsImageView: UIImageView!
    @IBOutlet weak var teamANameLabel: UILabel!
    @IBOutlet weak var teamBNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel! // Text Formate like when Live then '   ● LIVE   ', when upcoming then '   ● UPCOMING   ', when Completed then '   ● COMPLETED   '
    
    @IBOutlet weak var scorLabel: UILabel! // Text Formate like when Completed then '3  :  2'
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
