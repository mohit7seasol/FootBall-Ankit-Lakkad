//
//  SeriesCountryListCell.swift
//  Football
//
//  Created by Mohit Kanpara on 13/04/26.
//

import UIKit

class SeriesCountryListCell: UICollectionViewCell {

    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Configure cell appearance
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = #colorLiteral(red: 0.09019607843, green: 0.2431372549, blue: 0.4588235294, alpha: 1)
        contentView.layer.borderWidth = 1
    }

}
