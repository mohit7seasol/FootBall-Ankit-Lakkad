//
//  ScoreTitleCell.swift
//  Football
//
//  Created by Ronik Hirpara on 05/02/25.
//

import UIKit

class ScoreTitleCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sepView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(isSelected: Bool) {
        
        if isSelected {
            titleLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            sepView.isHidden = false
            
        } else {
            titleLbl.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.00)
            sepView.isHidden = true
        }
        
    }

}

/*
 squd
 info
 point table
 live update
 over view
 lineups
 stats
 */
