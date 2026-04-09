//
//  StatCell.swift
//  Football
//
//  Created by Ronik Hirpara on 13/02/25.
//

import UIKit

class StatCell: UITableViewCell {

    @IBOutlet weak var team1Lbl: Label!
    @IBOutlet weak var team2Lbl: Label!
    @IBOutlet weak var actionLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sepView: UIView!
    @IBOutlet weak var team1Progress: UIProgressView!
    @IBOutlet weak var team2Progress: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
