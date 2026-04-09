//
//  SquadCell.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class SquadCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sepView: UIView!
    @IBOutlet weak var squadLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
