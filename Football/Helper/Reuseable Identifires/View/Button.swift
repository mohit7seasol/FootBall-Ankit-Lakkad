import UIKit

// @IBDesignable
class Button: UIButton {
    
    var tblIndex = 0
    var tblSection = 0
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
  
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
  
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
  
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
  
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
  
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
  
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    // MARK: - Apply Localization
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    @IBInspectable
    var localizationText: String = "" {
        didSet {
            if localizationText.isEmpty {
                localizationText = self.title(for: .normal) ?? ""
                applyLocalization()
            } else {
                applyLocalization()
            }
        }
    }
    
    @objc func applyLocalization() {
        if localizationText.isEmpty {
            self.setTitle(self.title(for: .normal), for: .normal)
        } else {
            self.setTitle(localizationText, for: .normal)
        }
    }
}
