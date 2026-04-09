//
//  LinesUpCell.swift
//  Football
//
//  Created by Ronik Hirpara on 13/02/25.
//

import UIKit
import MarqueeLabel

class LinesUpCell: UIView {
    
    @IBOutlet weak var shirtNoLbl: UILabel!
    @IBOutlet weak var playerImgLbl: UIImageView!
    @IBOutlet weak var playerNameLbl: MarqueeLabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp(){
        Bundle.main.loadNibNamed("LinesUpCell", owner: self)
        addSubview(mainView)
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.frame = self.bounds
        self.nameView.layer.cornerRadius = self.nameView.frame.size.height/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
