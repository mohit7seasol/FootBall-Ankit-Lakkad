//
//  DatePickerCell.swift
//  Football
//
//  Created by Mohit Kanpara on 10/04/26.
//

import UIKit

class DatePickerCell: UICollectionViewCell {

    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateSelectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update corner radius when layout changes
        dateButton.layer.cornerRadius = dateButton.frame.width / 2
    }
    
    private func setupUI() {
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, weight: .medium)
        dayNameLabel.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 14 : 12, weight: .medium)
        dateButton.layer.masksToBounds = true
    }
    
    func configure(isSelected: Bool, dayName: String, date: String) {
        dayNameLabel.text = dayName
        dateButton.setTitle(date, for: .normal)
        
        if isSelected {
            dateButton.backgroundColor = .white
            // Fix: Use UIColor(hex:) instead of UIColor(named:)
            dateButton.setTitleColor(UIColor(#colorLiteral(red: 0.09019607843, green: 0.2431372549, blue: 0.4588235294, alpha: 1)), for: .normal)
            dateButton.layer.cornerRadius = dateButton.frame.width / 2
            dateButton.layer.borderWidth = 0
            dayNameLabel.textColor = .white
        } else {
            dateButton.backgroundColor = .clear
            dateButton.setTitleColor(.white, for: .normal)
            dateButton.layer.cornerRadius = dateButton.frame.width / 2
            dateButton.layer.borderWidth = 0
            dayNameLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
        }
    }
}
