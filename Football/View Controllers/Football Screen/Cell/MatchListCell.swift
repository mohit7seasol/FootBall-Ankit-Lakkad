//
//  MatchListCell.swift
//  Football
//
//  Created by Mohit Kanpara on 10/04/26.
//

import UIKit
import MarqueeLabel

class MatchListCell: UICollectionViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var teamAFlagImageView: UIImageView!
    @IBOutlet weak var teamBFlagImageView: UIImageView!
    @IBOutlet weak var vsImageView: UIImageView!
    @IBOutlet weak var teamANameLabel: MarqueeLabel!
    @IBOutlet weak var teamBNameLabel: MarqueeLabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scorLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
        dateView.layer.cornerRadius = dateView.frame.height / 2
        teamAFlagImageView.layer.cornerRadius = teamAFlagImageView.frame.height / 2
        teamBFlagImageView.layer.cornerRadius = teamBFlagImageView.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset constraints to avoid conflicts
        dateViewWidthConstant.constant = 80
        teamANameLabel.text = ""
        teamBNameLabel.text = ""
        teamAFlagImageView.image = nil
        teamBFlagImageView.image = nil
        statusLabel.text = ""
        scorLabel.text = ""
    }
    
    private func setupUI() {
        mainView.layer.cornerRadius = 16
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = #colorLiteral(red: 0.09019607843, green: 0.2431372549, blue: 0.4588235294, alpha: 1)
        mainView.backgroundColor = .white
        
        // Remove any existing constraints that might cause conflicts
        teamAFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        teamBFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        vsImageView.tintColor = UIColor(white: 0.7, alpha: 1.0)
        vsImageView.image = UIImage(systemName: "vs")
        
        statusLabel.clipsToBounds = true
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        // Setup marquee labels
        teamANameLabel.type = .continuous
        teamANameLabel.speed = .duration(8)
        teamANameLabel.fadeLength = 10
        teamANameLabel.leadingBuffer = 0
        teamANameLabel.trailingBuffer = 20
        
        teamBNameLabel.type = .continuous
        teamBNameLabel.speed = .duration(8)
        teamBNameLabel.fadeLength = 10
        teamBNameLabel.leadingBuffer = 0
        teamBNameLabel.trailingBuffer = 20
        
        // Set content compression resistance priorities
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        teamANameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        teamBNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupConstraints() {
        // Set fixed size for flag images to avoid constraint conflicts
        let flagSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 40
        
        NSLayoutConstraint.activate([
            teamAFlagImageView.widthAnchor.constraint(equalToConstant: flagSize),
            teamAFlagImageView.heightAnchor.constraint(equalToConstant: flagSize),
            teamBFlagImageView.widthAnchor.constraint(equalToConstant: flagSize),
            teamBFlagImageView.heightAnchor.constraint(equalToConstant: flagSize)
        ])
    }
    
    func configureForLive(match: Match) {
        // Configure date view for live
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(red: 0.514, green: 0.675, blue: 0.859, alpha: 1.0).cgColor // #83ACDB
        dateView.backgroundColor = .clear
        
        dateLabel.text = match.formattedDateTime
        dateLabel.sizeToFit()
        // Calculate width with proper padding
        let dateWidth = dateLabel.intrinsicContentSize.width + 40
        dateViewWidthConstant.constant = dateWidth
        
        // Configure status for LIVE
        statusLabel.text = "  ● LIVE  "
        statusLabel.textColor = UIColor(red: 1.0, green: 0.09, blue: 0.106, alpha: 1.0) // #FF171B
        statusLabel.backgroundColor = UIColor(red: 1.0, green: 0.09, blue: 0.106, alpha: 0.1)
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor(red: 1.0, green: 0.816, blue: 0.82, alpha: 1.0).cgColor // #FFD0D1
        
        // Hide score label for live
        scorLabel.isHidden = true
        vsImageView.isHidden = false
        
        // Set team info with marquee
        teamANameLabel.text = match.homeName
        teamBNameLabel.text = match.awayName
        teamANameLabel.restartLabel()
        teamBNameLabel.restartLabel()
        
        // Load images
        loadTeamImages(homeLogo: match.homeLogo, awayLogo: match.awayLogo)
        
        // Force layout update
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func configureForUpcoming(match: Match) {
        // Configure date view for upcoming
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(red: 0.514, green: 0.675, blue: 0.859, alpha: 1.0).cgColor // #83ACDB
        dateView.backgroundColor = .clear
        
        dateLabel.text = match.formattedTime
        dateLabel.sizeToFit()
        // Calculate width with proper padding
        let dateWidth = dateLabel.intrinsicContentSize.width + 32
        dateViewWidthConstant.constant = dateWidth
        
        // Configure status for UPCOMING
        statusLabel.text = "  ● UPCOMING  "
        statusLabel.textColor = UIColor(red: 0.969, green: 0.498, blue: 0.0, alpha: 1.0) // #F77F00
        statusLabel.backgroundColor = UIColor(red: 0.969, green: 0.498, blue: 0.0, alpha: 0.1)
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor(red: 0.996, green: 0.855, blue: 0.702, alpha: 1.0).cgColor // #FEDAB3
        
        // Hide score label for upcoming
        scorLabel.isHidden = true
        vsImageView.isHidden = false
        
        // Set team info with marquee
        teamANameLabel.text = match.homeName
        teamBNameLabel.text = match.awayName
        teamANameLabel.restartLabel()
        teamBNameLabel.restartLabel()
        
        // Load images
        loadTeamImages(homeLogo: match.homeLogo, awayLogo: match.awayLogo)
        
        // Force layout update
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func configureForCompleted(match: Match) {
        // Configure date view for completed
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(red: 0.514, green: 0.675, blue: 0.859, alpha: 1.0).cgColor // #83ACDB
        
        dateLabel.text = match.formattedTime
        dateLabel.sizeToFit()
        // Calculate width with proper padding
        let dateWidth = dateLabel.intrinsicContentSize.width + 32
        dateViewWidthConstant.constant = dateWidth
        
        // Configure status for COMPLETED
        statusLabel.text = "  ● COMPLETED  "
        statusLabel.textColor = UIColor(red: 0.224, green: 0.69, blue: 0.027, alpha: 1.0) // #39B007
        statusLabel.backgroundColor = UIColor(red: 0.224, green: 0.69, blue: 0.027, alpha: 0.1)
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor(red: 0.69, green: 1.0, blue: 0.561, alpha: 1.0).cgColor // #B0FF8F
        
        // Show score label for completed
        scorLabel.isHidden = false
        if let homeScore = match.homeScore, let awayScore = match.awayScore {
            scorLabel.text = "\(homeScore)  :  \(awayScore)"
        }
        vsImageView.isHidden = true
        
        // Set team info with marquee
        teamANameLabel.text = match.homeName
        teamBNameLabel.text = match.awayName
        teamANameLabel.restartLabel()
        teamBNameLabel.restartLabel()
        
        // Load images
        loadTeamImages(homeLogo: match.homeLogo, awayLogo: match.awayLogo)
        
        // Force layout update
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func loadTeamImages(homeLogo: String, awayLogo: String) {
        let placeholderImage = UIImage(named: "placeholder_flag")
        
        if let url = URL(string: homeLogo), !homeLogo.isEmpty {
            teamAFlagImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            teamAFlagImageView.image = placeholderImage
        }
        
        if let url = URL(string: awayLogo), !awayLogo.isEmpty {
            teamBFlagImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            teamBFlagImageView.image = placeholderImage
        }
    }
}
