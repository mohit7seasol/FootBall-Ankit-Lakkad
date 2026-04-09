//
//  IntroNativeVC.swift
//  Football
//
//  Created by Ronik Hirpara on 15/04/25.
//

import UIKit

class IntroNativeVC: UIViewController {

    @IBOutlet weak var nativeAdView: UIView!
    
    var index = -1
    var googleNativeAds = GoogleNativeAds()
    var timer: Timer?
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoader()
        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer?.invalidate()
        removeLoader()
    }
    
    func showAd() {
        //self.showSkeleton()
        if isUserSubscribe() == false {
            self.nativeAdView.showAnimatedSkeleton()
            self.googleNativeAds.loadAds2(vc: self) { nativeAdsTemp in
                self.nativeAdView.isHidden = false
                removeLoader()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.googleNativeAds.showAdsView5(nativeAd: nativeAdsTemp, view: self.nativeAdView)
                }
            }
            self.googleNativeAds.failAds2(vc: self) { fail in
                print(" Home...Native fail....")
                self.nativeAdView.isHidden = true
                showLoader()
            }
        } else {
            self.nativeAdView.isHidden = true
            showLoader()
            
        }
        
    }
    
    func startTimer() {
        self.counter = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.counter += 1
        
        if self.counter == 4 {
            self.timer?.invalidate()
            self.timer = nil
            setIsIntroOne(status: true)
            let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as! GetStartedVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
