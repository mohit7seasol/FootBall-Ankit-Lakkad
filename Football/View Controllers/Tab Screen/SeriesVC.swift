//
//  SeriesVC.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import UIKit

class SeriesVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var domesticView: View!
    @IBOutlet weak var domesticLbl: UILabel!
    
    @IBOutlet weak var internationalView: View!
    @IBOutlet weak var internationalLbl: UILabel!
    
    @IBOutlet weak var clubView: View!
    @IBOutlet weak var clubLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    @IBOutlet weak var seriesLbl: UILabel!
    
    private weak var pagerVc: SeriesPVC?
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.Series)
        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        showTabBar(animated: true, vc: self)
        self.seriesLbl.text = "Football Series".localized()
        self.domesticLbl.text = "Domestic".localized()
        self.internationalLbl.text = "International".localized()
        self.clubLbl.text = "Club Football".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? SeriesPVC {
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
    
    @IBAction func clickOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnDomestic(_ sender: Any) {
        pagerVc?.moveToPage(index: 0, animated: true)
        
        self.domesticView.backgroundColor = .white
        self.domesticLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        
        self.internationalLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.internationalView.backgroundColor = .clear
        self.internationalView.borderWidth = 1
        self.internationalView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.clubLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.clubView.backgroundColor = .clear
        self.clubView.borderWidth = 1
        self.clubView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
    }
    
    @IBAction func clickOnInternational(_ sender: Any) {
        pagerVc?.moveToPage(index: 1, animated: true)
        
        self.domesticView.backgroundColor = .clear
        self.domesticLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.domesticView.borderWidth = 1
        self.domesticView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.internationalLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        self.internationalView.backgroundColor = .white
         
        self.clubLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.clubView.backgroundColor = .clear
        self.clubView.borderWidth = 1
        self.clubView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
    }
    
    @IBAction func clickOnClub(_ sender: Any) {
        pagerVc?.moveToPage(index: 2, animated: true)
        
        self.domesticView.backgroundColor = .clear
        self.domesticLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.domesticView.borderWidth = 1
        self.domesticView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.internationalLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        self.internationalView.backgroundColor = .clear
        self.internationalView.borderWidth = 1
        self.internationalView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        self.clubLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        self.clubView.backgroundColor = .white
    }    
    
}

extension SeriesVC: SeriesDelegate {
    
    func didPickItem(currentItem: Int) {
        if currentItem == 0 {
            pagerVc?.moveToPage(index: 0, animated: true)
            
            self.domesticView.backgroundColor = .white
            self.domesticLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            
            self.internationalLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.internationalView.backgroundColor = .clear
            self.internationalView.borderWidth = 1
            self.internationalView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.clubLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.clubView.backgroundColor = .clear
            self.clubView.borderWidth = 1
            self.clubView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        } else if currentItem == 1 {
            pagerVc?.moveToPage(index: 1, animated: true)
            
            self.domesticView.backgroundColor = .clear
            self.domesticLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.domesticView.borderWidth = 1
            self.domesticView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.internationalLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            self.internationalView.backgroundColor = .white
             
            self.clubLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.clubView.backgroundColor = .clear
            self.clubView.borderWidth = 1
            self.clubView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        } else if currentItem == 2 {
            pagerVc?.moveToPage(index: 2, animated: true)
            
            self.domesticView.backgroundColor = .clear
            self.domesticLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.domesticView.borderWidth = 1
            self.domesticView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.internationalLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.internationalView.backgroundColor = .clear
            self.internationalView.borderWidth = 1
            self.internationalView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.clubLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            self.clubView.backgroundColor = .white
        }
    }
    
}
