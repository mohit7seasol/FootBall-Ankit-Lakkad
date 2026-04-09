//
//  SquadDetailsVC.swift
//  Football
//
//  Created by Ronik Hirpara on 20/02/25.
//

import UIKit
import GoogleMobileAds

class SquadDetailsVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "SquadCell", bundle: nil), forCellReuseIdentifier: "SquadCell")
            self.tblView.register(UINib(nibName: "SquadTeamCell", bundle: nil), forCellReuseIdentifier: "SquadTeamCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var bannerAdView: BannerView!
    @IBOutlet weak var adViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var footballLbl: UILabel!
    
    
    var filteredArray: [Squad] = []
    var name:String?
    var squadNAme:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isUserSubscribe() == false {
            if bannerId == "" {
                self.adViewHeight.constant = 0
                bannerAdView.isHidden = true
            } else {
                bannerAdView.isHidden = false
                loadBannerAd()
            }
        } else {
            self.adViewHeight.constant = 0
            bannerAdView.isHidden = true
        }
        
        if self.filteredArray.isEmpty == true {
            self.tblView.isHidden = true
            self.noDataView.isHidden = false
        } else {
            self.tblView.isHidden = false
            self.noDataView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
        self.footballLbl.text = "Football".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func loadBannerAd() {
        bannerAdView.adUnitID = bannerId
        bannerAdView.delegate = self
        bannerAdView.rootViewController = self
        bannerAdView.adSize = getAdSize(for: self)
        
        let request = Request()
        bannerAdView.load(request)
    }
    
    private func getAdSize(for activity: UIViewController) -> AdSize {
        let defaultDisplay = UIScreen.main
        let displayMetrics = UIScreen.main.bounds.size
        let widthInPoints = displayMetrics.width
        
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: widthInPoints)
        
        return adSize
    }
    
    @IBAction func clickOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension SquadDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.filteredArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "SquadTeamCell", for: indexPath) as! SquadTeamCell
            
            cell.viewAllView.isHidden = true
            
            if indexPath.row == 0 {
                if self.name?.isEmpty == false {
                    cell.teamNameLbl.text = self.name
                } else {
                    cell.teamNameLbl.text = "TeamA"
                }
            } 
            
            return cell
            
        } else if indexPath.row > 0 && indexPath.row - 1 < self.filteredArray.count {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "SquadCell", for: indexPath) as! SquadCell
            
            let temp = self.filteredArray[indexPath.row - 1]
            cell.nameLbl.text = temp.name
            cell.positionLbl.text = temp.role
            
            if self.squadNAme == "Playing Squad" {
                cell.squadLbl.text = "Playing Squad"
                cell.squadLbl.textColor = UIColor(red: 0.22, green: 0.69, blue: 0.03, alpha: 1.00)
            } else if self.squadNAme == "Bench" {
                cell.squadLbl.text = "Bench"
                cell.squadLbl.textColor = UIColor(red: 0.92, green: 0.35, blue: 0.24, alpha: 1.00)
            }
            
            if isComeFromResult == true {
                cell.squadLbl.isHidden = false
            } else {
                cell.squadLbl.isHidden = true
            }
            
            if indexPath.row == 1 {
                cell.mainView.layer.cornerRadius = 8
                cell.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            if indexPath.row == self.filteredArray.count - 1 {
                cell.mainView.layer.cornerRadius = 8
                cell.mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.sepView.isHidden = true
            }
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension SquadDetailsVC : BannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        self.adViewHeight.constant = 50
        self.bannerAdView.isHidden = false
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        self.adViewHeight.constant = 0
        self.bannerAdView.isHidden = true
    }
}
