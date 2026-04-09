//
//  GetStartedVC.swift
//  Football
//
//  Created by Ronik Hirpara on 24/02/25.
//

import UIKit

class GetStartedVC: UIViewController {

    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var nativeAdView: View!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var getStartBtn: Button!
    
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cornerView.layer.cornerRadius = 30
        self.cornerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topLbl.text = "Ultimate Hub For Football".localized()
        self.bottomLbl.text = "Stay updated with football scores, live matches, team stats, and breaking news.".localized()
        self.getStartBtn.setTitle("Get Started".localized(), for: .normal)
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
    
    @IBAction func clickOnGetStart(_ sender: Any) {
        setIsShowConfirmPrivacyScreen(isShow: true)
        FromGetStarted = true
        let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
