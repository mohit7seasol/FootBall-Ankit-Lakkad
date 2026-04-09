//
//  IntroOneVC.swift
//  Football
//
//  Created by Ronik Hirpara on 26/02/25.
//

import UIKit
import GoogleMobileAds
import Lottie

class IntroOneVC: UIViewController {
    
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var nativeAdView: View!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var nextBtn: Button!
    
    var googleNativeAds = GoogleNativeAds()
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.topImg.image = UIImage(named: "intro1_ic_ipad")
        } else {
            self.topImg.image = UIImage(named: "intro1_ic")
        }
        if isUserSubscribe() == false {
            Task {
              await AdsManager.shared.loadInterstitialAd()
            }
         }
        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topLbl.text = "Get Full Details On Every Match".localized()
        self.bottomLbl.text = "Follow every football match with complete stats and player updates. Stay on top of every goal, assist, and key play.".localized()
        self.nextBtn.setTitle("Next".localized(), for: .normal)
    }
    
    func showAd() {
        self.showSkeleton()
        if isUserSubscribe() == false {
            self.nativeAdView.showAnimatedSkeleton()
            self.googleNativeAds.loadAds(vc: self) { nativeAdsTemp in
                self.nativeAdView.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.hideSkeleton()
                    self.googleNativeAds.showAdsView3(nativeAd: nativeAdsTemp, view: self.nativeAdView)
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
        if let adView = Bundle.main.loadNibNamed("SkeletonCustomView3", owner: self, options: nil)?.first as? SkeletonCustomView3 {
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
            if let adView = subview as? SkeletonCustomView3 {
                adView.removeFromSuperview()
            }
        }
    }

    
    @IBAction func clickOnNext(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "naviToNative"), object: nil)
    }

}

