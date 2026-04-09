//
//  LanguageCell.swift
//  Football
//
//  Created by Ronik Hirpara on 25/02/25.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subNameLbl: UILabel!
    @IBOutlet weak var thumbImg: ImageView!
    @IBOutlet weak var mainView: View!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
