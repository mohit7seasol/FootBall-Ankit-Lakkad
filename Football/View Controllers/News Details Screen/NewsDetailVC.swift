//
//  NewsDetailVC.swift
//  Football
//
//  Created by Ronik Hirpara on 06/02/25.
//

import UIKit
import GoogleMobileAds

class NewsDetailVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var articleLbl: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var bannerAdView: BannerView!
    @IBOutlet weak var adViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newsLbl: UILabel!
    
    var titleName = String()
    var article = String()
    var imgNews = String()
    var descNews = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.NewsDetails)
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
        
        self.setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.newsLbl.text = "News".localized()
        hideTabBar(animated: true, vc: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setUpData() {
        self.titleLbl.text = titleName
        self.detailLbl.text = descNews
        self.articleLbl.text = article
        if let imageUrl = URL(string: imgNews) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.thumbImg.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
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

extension NewsDetailVC : BannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        self.adViewHeight.constant = 50
        self.bannerAdView.isHidden = false
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        self.adViewHeight.constant = 0
        self.bannerAdView.isHidden = true
    }
}
