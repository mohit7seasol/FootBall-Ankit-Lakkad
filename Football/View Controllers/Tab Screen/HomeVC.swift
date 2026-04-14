//
//  HomeVC.swift
//  Football
//
//  Created by Ronik Hirpara on 03/02/25.
//

import UIKit
import SkeletonView
import StoreKit
import Alamofire

class HomeVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var moreDetailView: View!
    @IBOutlet weak var moreDetailLbl: UILabel!
    @IBOutlet weak var footballTitleLbl: UILabel!
    @IBOutlet weak var footballDEscLbl: UILabel!
    
    @IBOutlet weak var seriesTitleLbl: UILabel!
    @IBOutlet weak var seriesDescLbl: UILabel!
    @IBOutlet weak var viewAllView: UIView!
    @IBOutlet weak var viewAllLbl: UILabel!
    
    @IBOutlet weak var newsView: View!
    @IBOutlet weak var newsThumb1Img: ImageView!
    @IBOutlet weak var news1TitleLbl: UILabel!
    @IBOutlet weak var news1DescLbl: UILabel!
    
    @IBOutlet weak var newsThumb2Img: ImageView!
    @IBOutlet weak var news2TitleLbl: UILabel!
    @IBOutlet weak var news2DescLbl: UILabel!
    
    @IBOutlet weak var newsThumb3Img: ImageView!
    @IBOutlet weak var news3TitleLbl: UILabel!
    @IBOutlet weak var news3DescLbl: UILabel!
    @IBOutlet weak var nativeAdView: UIView!
    @IBOutlet weak var adsViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var stakcHeightConstant: NSLayoutConstraint!
    
    var allNews: [NewsModel] = []
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.Home)
        Task {
            await AdsManager.shared.loadInterstitialAd()
        }
        setIsShowHome(status: true)
        self.showAd()
        self.fetchFreshNews()
        self.moreDetailView.cornerRadius = self.moreDetailView.frame.size.height/2
        self.viewAllView.layer.cornerRadius = self.viewAllView.frame.size.height/2
        
        if isUserSubscribe() == false {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PremiumVC") as! PremiumVC
            vc.superVC = self
            self.present(vc, animated: true)
        }else{
            showRateScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar(animated: true, vc: self)
        self.titleLbl.text = "Football".localized()
        self.moreDetailLbl.text = "Watch Now".localized()
        self.footballTitleLbl.text = "Football Match Streaming Live".localized()
        self.footballDEscLbl.text = "Get real-time updates and stats from the live match".localized()
        self.seriesTitleLbl.text = "Your Complete Guide to the Football Series".localized()
        self.seriesDescLbl.text = "All the Latest Football Series News in One Place".localized()
        self.viewAllLbl.text = "View All".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startBlinking(view: self.moreDetailView)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.stopBlinking(view: self.moreDetailView)
    }
    
    func startBlinking(view: UIView) {
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       options: [.autoreverse, .repeat, .allowUserInteraction],
                       animations: {
            view.alpha = 0
        })
    }

    func stopBlinking(view: UIView) {
        view.layer.removeAllAnimations()
        view.alpha = 1.0
    }
    
    func showRateScreen() {
        // Check if already shown or rated
        if hasUserRespondedToRatePopup() {
            return
        }
        
        let alert = UIAlertController.init(title: "Do you like our App?".localized(), message: "Help us improve the app by answering this quick poll".localized(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "No ❌".localized(), style: .default, handler: { _ in
            self.markRatePopupAsShown()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Yes 👍".localized(), style: .default, handler: { _ in
            self.markRatePopupAsShown()
            self.rateApp()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            // Mark that user has been prompted to rate
            setRateDone(status: true)
        } else {
            if let appStoreURL = URL(string: AppStoreLink) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { success in
                    if success {
                        self.setRateDone(status: true)
                    }
                })
            } else {
                let appStoreURL = URL(string: AppStoreLink)
                UIApplication.shared.openURL(appStoreURL!)
            }
        }
    }

    // MARK: - UserDefaults Helper Methods

    func hasUserRespondedToRatePopup() -> Bool {
        return UserDefaults.standard.bool(forKey: "RatePopupResponded")
    }

    func markRatePopupAsShown() {
        UserDefaults.standard.set(true, forKey: "RatePopupResponded")
        UserDefaults.standard.synchronize()
    }

    func setRateDone(status: Bool) {
        UserDefaults.standard.set(status, forKey: "RateDone")
        UserDefaults.standard.synchronize()
    }

    func shouldShowRatePopup() -> Bool {
        // Check if user has already rated or responded to popup
        let hasRated = UserDefaults.standard.bool(forKey: "RateDone")
        let hasResponded = UserDefaults.standard.bool(forKey: "RatePopupResponded")
        
        return !hasRated && !hasResponded
    }
    
    func showAd() {
        self.showSkeleton()
        if isUserSubscribe() == false {
            self.adsViewHeightConstant.constant = 150
            self.stakcHeightConstant.constant = 150
            self.nativeAdView.showAnimatedSkeleton()
            self.googleNativeAds.loadAds(vc: self) { nativeAdsTemp in
                self.nativeAdView.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.hideSkeleton()
                    self.googleNativeAds.showAdsView4(nativeAd: nativeAdsTemp, view: self.nativeAdView)
                }
            }
            self.googleNativeAds.failAds(vc: self) { fail in
                print(" Home...Native fail....")
                self.nativeAdView.isHidden = true
                self.adsViewHeightConstant.constant = 0
                self.stakcHeightConstant.constant = 0
            }
        } else {
            self.hideSkeleton()
            self.nativeAdView.isHidden = true
            self.adsViewHeightConstant.constant = 0
            self.stakcHeightConstant.constant = 0
        }
        
    }
    
    func showSkeleton() {
        if let adView = Bundle.main.loadNibNamed("SkeletonCustomView5", owner: self, options: nil)?.first as? SkeletonCustomView5 {
            // Add the custom UIView to the adContainerView
            self.nativeAdView.addSubview(adView)
            
            // Set constraints to make sure the adView fills the adContainerView
            adView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: self.nativeAdView.topAnchor),
                adView.leadingAnchor.constraint(equalTo: self.nativeAdView.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: self.nativeAdView.trailingAnchor),
                adView.bottomAnchor.constraint(equalTo: self.nativeAdView.bottomAnchor)
            ])
            adView.view1.showAnimatedGradientSkeleton()
            adView.view2.showAnimatedGradientSkeleton()
            adView.view3.showAnimatedGradientSkeleton()
            adView.view4.showAnimatedGradientSkeleton()
            adView.view5.showAnimatedGradientSkeleton()
        }
    }
    
    func hideSkeleton() {
        for subview in self.nativeAdView.subviews {
            if let adView = subview as? SkeletonCustomView5 {
                adView.removeFromSuperview()
            }
        }
    }
    
//    @objc func showRateVc() {
//        self.showRateScreen()
//    }
    
    @IBAction func premiumTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PremiumVC") as! PremiumVC
        self.present(vc, animated: true)
    }
    
    @IBAction func clickOnFootball(_ sender: Any) {
        showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let vc = StoryBoard.instantiateViewController(withIdentifier: "FootballVC") as! FootballVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickOnSeries(_ sender: Any) {
        showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let vc = StoryBoard.instantiateViewController(withIdentifier: "SeriesListVC") as! SeriesListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickOnNews(_ sender: Any) {
        showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let vc = StoryBoard.instantiateViewController(withIdentifier: "NewsVC") as! NewsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickOnSetting(_ sender: Any) {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "SettingVc") as! SettingVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - News API Call
extension HomeVC {
    func fetchFreshNews() {
        let params: [String: Any] = [
            "category": ["Football"]
        ]
        
        AF.request("\(NewsAPI)fresh-news",
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate(statusCode: 200..<300)
        .responseData { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let data):
                // Decode off the main thread
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let decoder = JSONDecoder()
                        let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                        let dataArr = newsResponse.data
                        
                        // Back to main for UI updates
                        DispatchQueue.main.async {
                            self.allNews = Array(dataArr.prefix(3))
                            self.setUpNewsData()
                        }
                    } catch {
                        // decoding failed — show/log details on main thread
                        DispatchQueue.main.async {
                            print("❌ Decoding error:", error.localizedDescription)
                            if let json = String(data: data, encoding: .utf8) {
                                print("🧾 Server response: \(json)")
                            }
                        }
                    }
                }
                
            case .failure(let afError):
                // network/HTTP error — handle on main thread
                DispatchQueue.main.async {
                    print("❌ Network error:", afError.localizedDescription)
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("🧾 Server response: \(jsonString)")
                    }
                }
            }
        }
    }
    
    private func setUpNewsData() {
        self.news1TitleLbl.text = self.allNews[0].title
        self.news1DescLbl.text = self.allNews[0].subDesc
        if let imageUrl = URL(string: self.allNews[0].imageUrl) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.newsThumb1Img.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        self.news2TitleLbl.text = self.allNews[1].title
        self.news2DescLbl.text = self.allNews[1].subDesc
        if let imageUrl = URL(string: self.allNews[1].imageUrl) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.newsThumb2Img.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        self.news3TitleLbl.text = self.allNews[2].title
        self.news3DescLbl.text = self.allNews[2].subDesc
        if let imageUrl = URL(string: self.allNews[2].imageUrl) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.newsThumb3Img.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
