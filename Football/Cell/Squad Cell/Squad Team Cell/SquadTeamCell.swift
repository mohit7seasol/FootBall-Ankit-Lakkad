//
//  SquadTeamCell.swift
//  Football
//
//  Created by Ronik Hirpara on 20/02/25.
//

import UIKit

class SquadTeamCell: UITableViewCell {

    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var viewAllView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
