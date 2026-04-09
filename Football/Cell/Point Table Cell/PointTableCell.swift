//
//  PointTableCell.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import UIKit

class PointTableCell: UITableViewCell {

    @IBOutlet weak var teamLbl: UILabel!
    @IBOutlet weak var mLbl: UILabel!
    @IBOutlet weak var wLbl: UILabel!
    @IBOutlet weak var lLbl: UILabel!
    @IBOutlet weak var dLbl: UILabel!
    @IBOutlet weak var ptsLbl: UILabel!
    @IBOutlet weak var sepView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
