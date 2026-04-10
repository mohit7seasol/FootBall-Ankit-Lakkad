//
//  FootballVC.swift
//  Football
//
//  Created by Ronik Hirpara on 17/02/25.
//

import UIKit

class FootballVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var liveView: View!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var upcomingView: View!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var completedView: View!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    @IBOutlet weak var footballLbl: UILabel!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    
    private weak var pagerVc: CategoryPVC?
    var matchNameArr = ["Live Matches", "Upcoming Matches", "Finished Matches"]
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.Match)
//        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.footballLbl.text = "Football".localized()
        self.liveLbl.text = "Live".localized()
        self.upcomingLbl.text = "Upcoming".localized()
        self.completedLbl.text = "Completed".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? CategoryPVC {
            pagerVc = pageViewController
            pagerVc?.tabDelegate = self
        }
    }
    
    func showAd() {
        self.showSkeleton()
        if isUserSubscribe() == false {
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
            }
        } else {
            self.hideSkeleton()
            self.nativeAdView.isHidden = true
            
        }
        
    }
    
    func showSkeleton() {
        if let adView = Bundle.main.loadNibNamed("SkeletonCustomView4", owner: self, options: nil)?.first as? SkeletonCustomView4 {
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
            adView.view6.showAnimatedGradientSkeleton()
        }
    }
    
    func hideSkeleton() {
        for subview in self.nativeAdView.subviews {
            if let adView = subview as? SkeletonCustomView4 {
                adView.removeFromSuperview()
            }
        }
    }

    @IBAction func clickONBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnAll(_ sender: Any) {
        //matchCat = "All"
        pagerVc?.moveToPage(index: 0, animated: true)
        
        self.liveView.backgroundColor = .white
        self.liveLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        
        self.upcomingLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.upcomingView.backgroundColor = .clear
        self.upcomingView.borderWidth = 1
        self.upcomingView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.completedLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.completedView.backgroundColor = .clear
        self.completedView.borderWidth = 1
        self.completedView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
    }
    
    @IBAction func clickOnDomestic(_ sender: Any) {
        //matchCat = "Domestic"
        pagerVc?.moveToPage(index: 1, animated: true)
        
        self.liveView.backgroundColor = .clear
        self.liveLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.liveView.borderWidth = 1
        self.liveView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.upcomingLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        self.upcomingView.backgroundColor = .white
         
        self.completedLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.completedView.backgroundColor = .clear
        self.completedView.borderWidth = 1
        self.completedView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
    }
    
    @IBAction func clickOnInternational(_ sender: Any) {
        //matchCat = "International"
        pagerVc?.moveToPage(index: 2, animated: true)
        
        self.liveView.backgroundColor = .clear
        self.liveLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.liveView.borderWidth = 1
        self.liveView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.upcomingLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.upcomingView.backgroundColor = .clear
        self.upcomingView.borderWidth = 1
        self.upcomingView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.completedLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        self.completedView.backgroundColor = .white
    }
    
}

extension FootballVC: CategoryDelegate {
    
    func didPickItem(currentItem: Int) {
        if currentItem == 0 {
            //matchCat = "All"
            pagerVc?.moveToPage(index: 0, animated: true)
            
            self.liveView.backgroundColor = .white
            self.liveLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            
            self.upcomingLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.upcomingView.backgroundColor = .clear
            self.upcomingView.borderWidth = 1
            self.upcomingView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.completedLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.completedView.backgroundColor = .clear
            self.completedView.borderWidth = 1
            self.completedView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
        } else if currentItem == 1 {
            //matchCat = "Domestic"
            pagerVc?.moveToPage(index: 1, animated: true)
            
            self.liveView.backgroundColor = .clear
            self.liveLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.liveView.borderWidth = 1
            self.liveView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.upcomingLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            self.upcomingView.backgroundColor = .white
             
            self.completedLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.completedView.backgroundColor = .clear
            self.completedView.borderWidth = 1
            self.completedView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
        } else if currentItem == 2 {
            //matchCat = "International"
            pagerVc?.moveToPage(index: 2, animated: true)
            
            self.liveView.backgroundColor = .clear
            self.liveLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.liveView.borderWidth = 1
            self.liveView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.upcomingLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.upcomingView.backgroundColor = .clear
            self.upcomingView.borderWidth = 1
            self.upcomingView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.completedLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            self.completedView.backgroundColor = .white
        }
    }
}
