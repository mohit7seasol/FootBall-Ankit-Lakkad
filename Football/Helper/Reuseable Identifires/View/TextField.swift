//
//  TextField.swift
//  Business Card
//
//  Created by admin on 05/01/23.
//

import Foundation
import UIKit

// @IBDesignable
class TextField: UITextField {
    
    // MARK: - Apply Localization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBInspectable
    var localizationText: String = "" {
        didSet {
            if localizationText.isEmpty {
                localizationText = self.placeholder ?? ""
                applyLocalization()
            } else {
                applyLocalization()
            }
        }
    }
    
    @objc func applyLocalization() {
        self.placeholder = localizationText
    }
}
