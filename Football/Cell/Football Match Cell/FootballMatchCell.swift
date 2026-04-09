//
//  FootballMatchCell.swift
//  Football
//
//  Created by Ronik Hirpara on 15/02/25.
//

import UIKit

class FootballMatchCell: UITableViewCell {

    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var clcView: UICollectionView! {
        didSet {
            self.clcView.delegate = self
            self.clcView.dataSource = self
            self.clcView.register(UINib(nibName: "LiveMatchesCell", bundle: nil), forCellWithReuseIdentifier: "LiveMatchesCell")
            self.clcView.register(UINib(nibName: "UpcomingMatchesCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingMatchesCell")
            self.clcView.register(UINib(nibName: "FinishedMatchCell", bundle: nil), forCellWithReuseIdentifier: "FinishedMatchCell")
            self.clcView.register(UINib(nibName: "AdCell", bundle: nil), forCellWithReuseIdentifier: "AdCell")
            self.clcView.showsVerticalScrollIndicator = false
            self.clcView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var lblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noDAtaView: UIView!
    
    var matchName = "Live Matches"
    var matcheslive: [MatchLiveAll] = []
    var matchesUpcoming: [MatchUpcomingAll] = []
    var matches: [MatchResultAll] = []
    var googleNativeAds = GoogleNativeAds()
    var superVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clcView.isHidden = false
        noDAtaView.isHidden = true
    }

//    func reloadData(live : [MatchLiveAll], upComming : [MatchUpcomingAll], result : [MatchResultAll], isAd: Bool){
//        matcheslive = live
//        matchesUpcoming = upComming
//        matches = result
//        
//        DispatchQueue.main.async {
//            print("\nmatcheslive --------------------", self.matcheslive)
//            print("matchesUpcoming --------------------", self.matchesUpcoming)
//            print("matches --------------------", self.matches)
//            
//            let list = (self.matchName == "Live Matches" ? self.matcheslive : self.matchName == "Upcoming Matches" ? self.matchesUpcoming : self.matchName == "Finished Matches" ? self.matches : [])
//            self.clcView.isHidden = list.isEmpty
//            self.noDAtaView.isHidden = !list.isEmpty
//            
//            if live.count > 0 || upComming.count > 0 || result.count > 0 {
//                self.clcView.reloadData()
//            }
//        }
//    }
    
    func reloadData(live : [MatchLiveAll], upComming : [MatchUpcomingAll], result : [MatchResultAll], isAd: Bool) {

        matcheslive = live
        matchesUpcoming = upComming
        matches = result

        DispatchQueue.main.async {
            var hasData = false

            switch self.matchName {
            case "Live Matches":
                hasData = !self.matcheslive.isEmpty
            case "Upcoming Matches":
                hasData = !self.matchesUpcoming.isEmpty
            case "Finished Matches":
                hasData = !self.matches.isEmpty
            case "Ads":
                hasData = true
            default:
                hasData = false
            }

            self.clcView.isHidden = !hasData
            self.noDAtaView.isHidden = hasData

            self.clcView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension FootballMatchCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.matchName == "Live Matches" {
//            if matcheslive.isEmpty == true {
//                self.clcView.isHidden = true
//                self.noDAtaView.isHidden = false
//            } else {
//                self.clcView.isHidden = false
//                self.noDAtaView.isHidden = true
//            }
//            return self.matcheslive.count
//            
//        } else if self.matchName == "Ads" {
//            self.clcView.isHidden = false
//            self.noDAtaView.isHidden = true
//            return 1
//            
//        }else if self.matchName == "Upcoming Matches" {
//            if matchesUpcoming.isEmpty == true {
//               self.clcView.isHidden = true
//               self.noDAtaView.isHidden = false
//           } else {
//               self.clcView.isHidden = false
//               self.noDAtaView.isHidden = true
//           }
//            return self.matchesUpcoming.count
//
//        } else if self.matchName == "Finished Matches" {
//            if matches.isEmpty == true {
//               self.clcView.isHidden = true
//               self.noDAtaView.isHidden = false
//           } else {
//               self.clcView.isHidden = false
//               self.noDAtaView.isHidden = true
//           }
//            return self.matches.count
//            
//        }
//        return 10
        switch matchName {
            case "Live Matches": return matcheslive.count
            case "Ads": return 1
            case "Upcoming Matches": return matchesUpcoming.count
            case "Finished Matches": return matches.count
            default: return 0
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        lblHeight.constant = 25
        if self.matchName == "Live Matches" {
            
            let cell = self.clcView.dequeueReusableCell(withReuseIdentifier: "LiveMatchesCell", for: indexPath) as! LiveMatchesCell
            
            let temp = self.matcheslive[indexPath.row]
            cell.matchNameLbl.text = temp.m_name
            cell.match1Lbl.text = temp.t1_sname
            cell.match2Lbl.text = temp.t2_sname
            cell.liveView.isHidden = false
            
            if temp.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: temp.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
            }
            
            if temp.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: temp.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "splash"))
            }
            
            return cell
            
        } else if self.matchName == "Ads" {
            lblHeight.constant = 0
            let cell = self.clcView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
            
            cell.showSkeleton()
            if isUserSubscribe() == false {
                cell.nativeAdView.showAnimatedSkeleton()
                self.googleNativeAds.loadAds(vc: self.superVC!) { nativeAdsTemp in
                    cell.nativeAdView.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        cell.hideSkeleton()
                        self.googleNativeAds.showAdsView1(nativeAd: nativeAdsTemp, view: cell.nativeAdView)
                    }
                }
                self.googleNativeAds.failAds(vc: self.superVC!) { fail in
                    print(" Home...Native fail....")
                    cell.nativeAdView.isHidden = true
                }
            } else {
                cell.hideSkeleton()
                cell.nativeAdView.isHidden = true
            }
            
            return cell
            
        }else if self.matchName == "Upcoming Matches" {
            
            let cell = self.clcView.dequeueReusableCell(withReuseIdentifier: "UpcomingMatchesCell", for: indexPath) as! UpcomingMatchesCell
            
            let temp = self.matchesUpcoming[indexPath.row]
            cell.matchNameLbl.text = temp.m_name
            cell.match1Lbl.text = temp.t1_sname
            cell.match2Lbl.text = temp.t2_sname
            
            if temp.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: temp.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
            }
            
            if temp.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: temp.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "splash"))
            }
            
            let result = convertTimestamp(temp.strt_time_ts)
            cell.dateLbl.text = result.formattedDate
            cell.timeLbl.text = result.formattedTime
            
            return cell
            
        } else if self.matchName == "Finished Matches" {
            
            let cell = self.clcView.dequeueReusableCell(withReuseIdentifier: "FinishedMatchCell", for: indexPath) as! FinishedMatchCell
            
            let temp = self.matches[indexPath.row]
            cell.matchNameLbl.text = temp.m_name
            cell.match1Lbl.text = temp.t1_sname
            cell.match2Lbl.text = temp.t2_sname
            cell.resultLbl.isHidden = false
            cell.resultLbl.text = temp.result_str
            cell.scoreLbl.isHidden = false
            
            cell.scoreLbl.text = "\(temp.t1_goal) - \(temp.t2_goal)"
            cell.completeLbl.text = "\(temp.time)'"
            
            if temp.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: temp.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
            }
            
            if temp.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: temp.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "splash"))
            }
            
            let result = convertTimestamp(temp.strt_time_ts)
            cell.dateLbl.text = "\(result.formattedDate) | \(result.formattedTime)"
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.superVC?.showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.matchName == "Live Matches" {
                
                isComeFromUpcoming = false
                isComeFromResult = false
                let temp = self.matcheslive[indexPath.row]
                let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
                vc.l_idMain = temp.l_id
                vc.m_idMain = temp.m_id
                vc.m_name = temp.m_name
                vc.Aimg = temp.t1_flag
                vc.Bimg = temp.t2_flag
                vc.Aname = temp.t1_sname
                vc.Bname = temp.t2_sname
                self.superVC?.navigationController?.pushViewController(vc, animated: true)
                
            } else if self.matchName == "Upcoming Matches" {
                
                isComeFromUpcoming = true
                isComeFromResult = false
                let temp = self.matchesUpcoming[indexPath.row]
                let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
                vc.l_idMain = temp.l_id
                vc.m_idMain = temp.m_id
                vc.m_name = temp.m_name
                vc.Aimg = temp.t1_flag
                vc.Bimg = temp.t2_flag
                vc.Aname = temp.t1_sname
                vc.Bname = temp.t2_sname
                self.superVC?.navigationController?.pushViewController(vc, animated: true)
                
            } else if self.matchName == "Finished Matches" {
                
                isComeFromUpcoming = false
                isComeFromResult = true
                let temp = self.matches[indexPath.row]
                let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
                vc.l_idMain = temp.l_id
                vc.m_idMain = temp.m_id
                vc.m_name = temp.m_name
                vc.Aimg = temp.t1_flag
                vc.Bimg = temp.t2_flag
                vc.Aname = temp.t1_sname
                vc.Bname = temp.t2_sname
                self.superVC?.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.matchName == "Live Matches" {
            
            return CGSize(width: (self.clcView.frame.size.width) / 2, height: 200)
            
        } else if self.matchName == "Ads" {
            
            return CGSize(width: (self.clcView.frame.size.width), height: 350)
            
        } else if self.matchName == "Upcoming Matches" {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: (self.clcView.frame.size.width - 10) / 2, height: 200)
            } else {
                return CGSize(width: (self.clcView.frame.size.width - 10), height: 200)
            }
        } else if self.matchName == "Finished Matches" {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: (self.clcView.frame.size.width - 10) / 2, height: 230)
            } else {
                return CGSize(width: (self.clcView.frame.size.width - 10), height: 230)
            }
        }
        return CGSize(width: (self.clcView.frame.size.width) / 2, height: 200)
    }
    
}
