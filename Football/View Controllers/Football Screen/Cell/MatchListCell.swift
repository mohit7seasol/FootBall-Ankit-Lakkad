//
//  MatchListCell.swift
//  Football
//
//  Created by Mohit Kanpara on 10/04/26.
//

import UIKit

class MatchListCell: UICollectionViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var teamAFlagImageView: UIImageView!
    @IBOutlet weak var teamBFlagImageView: UIImageView!
    @IBOutlet weak var vsImageView: UIImageView!
    @IBOutlet weak var teamANameLabel: UILabel!
    @IBOutlet weak var teamBNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        contentView.backgroundColor = .white
        
        teamAFlagImageView.layer.cornerRadius = teamAFlagImageView.frame.height / 2
        teamAFlagImageView.clipsToBounds = true
        teamBFlagImageView.layer.cornerRadius = teamBFlagImageView.frame.height / 2
        teamBFlagImageView.clipsToBounds = true
        
        vsImageView.tintColor = UIColor(white: 0.7, alpha: 1.0)
    }
    
    func configureForLive(match: Match) {
        // Configure date view for live
        dateView.layer.cornerRadius = dateView.frame.height / 2
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(named: "#83ACDB")?.cgColor
        dateView.backgroundColor = .clear
        
        dateLabel.text = match.formattedDateTime
        dateLabel.sizeToFit()
        dateViewWidthConstant.constant = dateLabel.frame.width + 24
        
        // Configure status
        statusLabel.text = "  ● LIVE  "
        statusLabel.textColor = UIColor(named: "#FF171B")
        statusLabel.backgroundColor = UIColor(named: "#FF171B")?.withAlphaComponent(0.1)
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor(named: "#FFD0D1")?.cgColor
        statusLabel.clipsToBounds = true
        
        // Hide score label for live
        scorLabel.isHidden = true
        vsImageView.isHidden = false
        
        // Set team info
        teamANameLabel.text = match.homeName
        teamBNameLabel.text = match.awayName
        
        // Load images
        loadTeamImages(homeLogo: match.homeLogo, awayLogo: match.awayLogo)
    }
    
    func configureForUpcoming(match: Match) {
        // Configure date view for upcoming
        dateView.layer.cornerRadius = dateView.frame.height / 2
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(named: "#83ACDB")?.cgColor
        dateView.backgroundColor = .clear
        
        dateLabel.text = match.formattedTime
        dateLabel.sizeToFit()
        dateViewWidthConstant.constant = dateLabel.frame.width + 24
        
        // Configure status
        statusLabel.text = "  ● UPCOMING  "
        statusLabel.textColor = UIColor(named: "#F77F00")
        statusLabel.backgroundColor = UIColor(named: "#F77F00")?.withAlphaComponent(0.1)
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor(named: "#FEDAB3")?.cgColor
        statusLabel.clipsToBounds = true
        
        // Hide score label for upcoming
        scorLabel.isHidden = true
        vsImageView.isHidden = false
        
        // Set team info
        teamANameLabel.text = match.homeName
        teamBNameLabel.text = match.awayName
        
        // Load images
        loadTeamImages(homeLogo: match.homeLogo, awayLogo: match.awayLogo)
    }
    
    func configureForCompleted(match: Match) {
        // Configure date view for completed
        dateView.layer.cornerRadius = dateView.frame.height / 2
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(named: "#83ACDB")?.cgColor
        dateView.backgroundColor = .clear
        
        dateLabel.text = match.formattedTime
        dateLabel.sizeToFit()
        dateViewWidthConstant.constant = dateLabel.frame.width + 24
        
        // Configure status
        statusLabel.text = "  ● COMPLETED  "
        statusLabel.textColor = UIColor(named: "#39B007")
        statusLabel.backgroundColor = UIColor(named: "#39B007")?.withAlphaComponent(0.1)
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor(named: "#B0FF8F")?.cgColor
        statusLabel.clipsToBounds = true
        
        // Show score label for completed
        scorLabel.isHidden = false
        if let homeScore = match.homeScore, let awayScore = match.awayScore {
            scorLabel.text = "\(homeScore)  :  \(awayScore)"
        }
        vsImageView.isHidden = true
        
        // Set team info
        teamANameLabel.text = match.homeName
        teamBNameLabel.text = match.awayName
        
        // Load images
        loadTeamImages(homeLogo: match.homeLogo, awayLogo: match.awayLogo)
    }
    
    private func loadTeamImages(homeLogo: String, awayLogo: String) {
        if let url = URL(string: homeLogo) {
            teamAFlagImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_flag"))
        } else {
            teamAFlagImageView.image = UIImage(named: "placeholder_flag")
        }
        
        if let url = URL(string: awayLogo) {
            teamBFlagImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_flag"))
        } else {
            teamBFlagImageView.image = UIImage(named: "placeholder_flag")
        }
    }
}
