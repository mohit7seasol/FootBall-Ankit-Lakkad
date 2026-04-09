//
//  AdsManager.swift
//  QuickShare
//
//  Created by 7SEASOL-2 on 08/05/24.
//

import Foundation
import UIKit
import GoogleMobileAds
import SVProgressHUD
import AppTrackingTransparency
import AdSupport
import UserMessagingPlatform

protocol AdsManagerDelegate {
    func NativeAdLoad()
    func DidDismissFullScreenContent()
    func NativeAdsDidFailedToLoad()
}

//var interstitialAd: GADInterstitialAd?
//var interstitial: InterstitialAd?
var isNativeLoad : Bool = false
var isAdsLoadFailed = Bool()

var NATIVE_ADS:NativeAd?

class AdsManager: NSObject {
    
    static let shared = AdsManager()
    var delegate: AdsManagerDelegate?
    
    var adLoader: AdLoader!
    var arrNativeAds = [NativeAd]()
    
    var appOpenAd :AppOpenAd?
    var loadTime = Date()
    
    var isMobileAdsStartCalled = Bool()
    var interstitial: InterstitialAd?
    
    //MARK:- TOP VIEW CONTROLLER
    
    var topMostViewController: UIViewController? {
        var currentVc = UIApplication.shared.keyWindow?.rootViewController
        while let presentedVc = currentVc?.presentedViewController {
            if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
                currentVc = navVc
            } else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
                currentVc = tabVc
            } else {
                currentVc = presentedVc
            }
        }
        return currentVc
    }
    
    //MARK: - App Tracking
    
    func requestIDFA() {
      if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            
        })
      } else {
      }
    }

    
    //MARK: - LOAD INTERSTITIAL ADS
    func loadInterstitialAd() async{
        
        if !Reachability.isConnectedToNetwork() && isUserSubscribe() {
            return
        }
        
        /*if interstitial == nil {
            let request = Request()
        //!isAdsLoadFailed ? interstialId : sec_interstialId
            InterstitialAd.load(with: interstialId, request: request) { [self] (ad, error) in
            if let error = error {
                interstitial = nil
                async {
                    await loadInterstitialAd()
                }
                
            } else {
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                
            }
        }
    }*/
        
        do {
            interstitial = try await InterstitialAd.load(
            with: interstialId, request: Request())
          // [START set_the_delegate]
            interstitial?.fullScreenContentDelegate = self
          // [END set_the_delegate]
            print("inter load")
        } catch {
           
          print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - LOAD NATIVE ADS
    
    func createAndLoadNativeAds(numberOfAds: Int) {
        
        if !Reachability.isConnectedToNetwork() && isUserSubscribe(){
            return
        }
        arrNativeAds.removeAll()
        let multipleAdsOptions = MultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = numberOfAds
        
        adLoader = AdLoader(adUnitID: nativeId, rootViewController: topMostViewController,
                            adTypes: [AdLoaderAdType.native],
                               options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(Request())
    }
    
    //MARK:- LOAD APP OPEN ADS
    
    func tryToPresentAppOpenAd() {
        if isUserSubscribe(){
            return
        }

        if let ad = appOpenAd  {
            let rootController = appDelegate.window?.rootViewController
            ad.present(from: rootController!)
            appOpenAd = nil
            requestAppOpenAd()
        } else {
             requestAppOpenAd()
        }
    }
    
    func requestAppOpenAd() {
        if isUserSubscribe(){
            return
        }
        if appOpenAd == nil{
            AppOpenAd.load(
                with: appopenId,
                request: Request(),
                completionHandler: { [self] appOpenAd, error in
                    if let error = error {
                        print("Failed to load app open ad: \(error)")
                        return
                    }
                    self.appOpenAd = appOpenAd
                    self.appOpenAd?.fullScreenContentDelegate = self
                    self.loadTime = Date()
                })
        }
        
    }
    
    //MARK: - PRESENT (INTERSITITAL, NATIVE) ADS
    func showInterstitialAd (_ isLoader:Bool = false, isRandom:Bool = false, ratio:Int = 3,shouldMatchRandom : Int = 2){
        
        
        if interstitial != nil {
            if isLoader {
                SVProgressHUD.show(withStatus: "Loading Ads...")
                
                SVProgressHUD.dismiss(withDelay: 0.5) {
                    self.checkRandomAndPresentInterstitial(isRandom: isRandom, ratio: ratio, shouldMatchRandom: shouldMatchRandom)
                }
            }
            else{
                self.checkRandomAndPresentInterstitial(isRandom: isRandom, ratio: ratio, shouldMatchRandom: shouldMatchRandom)
            }
            
        } else {
            print("intersisital Ad wasn't ready")
            if isNativeLoad{
                if arrNativeAds.count > 0{
        
                }
            }else {
                print("native Ad wasn't ready")
            }
        }
        
        
    }
    
    func checkRandomAndPresentInterstitial( isRandom:Bool, ratio:Int,shouldMatchRandom :Int){
        if isRandom{
            let isRandomMatch = Int.random(in: 1 ... ratio) == shouldMatchRandom
            if isRandomMatch {
                self.presentInterstitialAd()
            }
        }
        else {
            self.presentInterstitialAd()
        }
    }
    
    func presentInterstitialAd() {
        if isUserSubscribe(){
            return
        }
        DispatchQueue.main.async { [self] in
            let rootController = appDelegate.window?.rootViewController
            interstitial?.present(from: rootController!)
            
        }
    }
    
    func presentInterstitialAd1(vc:UIViewController) {
        if isUserSubscribe(){
            return
        }
        //DispatchQueue.main.async {
        if let ad = self.interstitial {
              // [START present_interstitial]
                ad.present(from: vc)
  
              // [END present_interstitial]
            } else {
              print("Ad wasn't ready")
                if FromGetStarted == true {
                    FromGetStarted = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showRateVc"), object: nil)
                }
            }
            
            /*if interstitialAd != nil {
                interstitialAd!.present(fromRootViewController: vc)
            }else{
                print("intersitial not load")
            }*/
        //}
    }
    
    
    //MARK: Request For Content Form
    
    func requestForConsentForm(){
        // Create a UMPRequestParameters object.
        let parameters = RequestParameters()
        // Set tag for under age of consent. false means users are not under age
        // of consent.
        let debugSettings = DebugSettings()
        debugSettings.geography = DebugGeography.EEA
        parameters.debugSettings = debugSettings
        // Request an update for the consent information.
        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) {
            [weak self] requestConsentError in
            guard let self else { return }
            
            if let consentError = requestConsentError {
                // Consent gathering failed.
                return print("Error: \(consentError.localizedDescription)")
            }
            let rootController = appDelegate.window?.rootViewController
            print("rootController - ", rootController!)
            ConsentForm.loadAndPresentIfRequired(from: rootController ?? UIViewController()) {
                [weak self] loadAndPresentError in
                guard let self else { return }
                
                if let consentError = loadAndPresentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                // Consent has been gathered.
                if ConsentInformation.shared.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
            }
        }
        
        // Check if you can initialize the Google Mobile Ads SDK in parallel
        // while checking for new consent information. Consent obtained in
        // the previous session can be used to request ads.
        if ConsentInformation.shared.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            
            self.isMobileAdsStartCalled = true
            
            // Initialize the Google Mobile Ads SDK.
            MobileAds.shared.start()
            
            
        }
    }
    
    func requestForConsentForm(completion: @escaping (Bool) -> Void) {
        // Create a UMPRequestParameters object.
        let parameters = RequestParameters()
        // Set tag for under age of consent. false means users are not under age
        // of consent.
        // parameters.tagForUnderAgeOfConsent = false
        let debugSettings = DebugSettings()
        debugSettings.geography = DebugGeography.EEA
        parameters.debugSettings = debugSettings
        // Request an update for the consent information.
        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { [weak self] requestConsentError in
            guard let self = self else { return }
            
            if let consentError = requestConsentError {
                // Consent gathering failed.
                print("Error: \(consentError.localizedDescription)")
                completion(false) // Consent not granted due to error
                return
            }
            
            let rootController = UIApplication.shared.keyWindow?.rootViewController
            
            ConsentForm.loadAndPresentIfRequired(from: rootController ?? UIViewController()) { [weak self] loadAndPresentError in
                guard let self = self else { return }
                
                if let consentError = loadAndPresentError {
                    // Consent gathering failed.
                    print("Error: \(consentError.localizedDescription)")
                    completion(false) // Consent not granted
                    return
                }
                
                // Consent has been gathered.
                if ConsentInformation.shared.consentStatus == ConsentStatus.obtained {
                    completion(true) // Consent granted
                } else {
                    completion(false) // Consent not granted
                }
            }
        }
        
        // the previous session can be used to request ads.
        if ConsentInformation.shared.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
}


// MARK: - Interstitial Delegate
extension AdsManager: FullScreenContentDelegate {
    
    /*private func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) async {
        await loadInterstitialAd()
        interstitial = nil
    }
    
    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        self.delegate?.DidDismissFullScreenContent()
    }
    
    
    private func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) async {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showRateVc"), object: nil)
        firstTime = true
        interstitial = nil
        await loadInterstitialAd()
    }*/
    
    
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("\(#function) called with error: \(error.localizedDescription)")
      // Clear the interstitial ad.
      interstitial = nil
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
      // Clear the interstitial ad.
      interstitial = nil
        Task {
            await self.loadInterstitialAd()
        }
        if FromGetStarted == true {
            FromGetStarted = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showRateVc"), object: nil)
        }
    }
    
}

// MARK: - NativeAd Loader Delegate
extension AdsManager: NativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        isNativeLoad = true
        arrNativeAds.append(nativeAd)
        self.delegate?.NativeAdLoad()
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        isNativeLoad = false
    }
    
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {

    }
    
}


// MARK: - Google Banner Ads -

class GoogleBannerAds: NSObject, BannerViewDelegate {
    
    var view: BannerView!
    
    func loadAds(vc: UIViewController, view : BannerView) {
        if isUserSubscribe(){
            return
        }
        view.isHidden = true
        let viewWidth = view.frame.size.width
        self.view = view
        self.view.adSize = currentOrientationAnchoredAdaptiveBanner(width: viewWidth)
        self.view.adUnitID = bannerId
        self.view.rootViewController = vc
        self.view.delegate = self
        self.view.load(Request())
    }
    
    // MARK: GADBannerViewDelegate Methods
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        view.isHidden = false
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        view.isHidden = true
    }

}


// MARK: - Google Native Ads -
class GoogleNativeAds: NSObject, NativeAdLoaderDelegate {
  
    var completion: ((NativeAd) -> Void)?
    var fail: ((Error) -> Void)?
    var adLoader: AdLoader!
    
    func loadAds(vc: UIViewController,  completion: @escaping (NativeAd) -> Void) {
        if isUserSubscribe(){
            return
        }
        self.completion = completion
        
        let multipleAdsOptions = MultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 1
        self.adLoader = AdLoader(adUnitID: nativeId, rootViewController: vc, adTypes: [AdLoaderAdType.native], options: [multipleAdsOptions])
        self.adLoader.delegate = self
        self.adLoader.load(Request())
        
    }
    
    func failAds( vc: UIViewController, fail: @escaping (Error) -> Void ) {
        if isUserSubscribe(){
            return
        }
        self.fail = fail
    }
    
    func loadAds2(vc: UIViewController,  completion: @escaping (NativeAd) -> Void) {
        if isUserSubscribe(){
            return
        }
        self.completion = completion
        
        let multipleAdsOptions = MultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 1
        self.adLoader = AdLoader(adUnitID: nativeId2, rootViewController: vc, adTypes: [AdLoaderAdType.native], options: [multipleAdsOptions])
        self.adLoader.delegate = self
        self.adLoader.load(Request())
        
    }
    
    func failAds2( vc: UIViewController, fail: @escaping (Error) -> Void ) {
        if isUserSubscribe(){
            return
        }
        self.fail = fail
    }
    
    
    // MARK: - GADNativeAdLoaderDelegate Methods
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        //  print("Native completion..")
        self.completion!(nativeAd)
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        self.fail?(error)
        debugPrint("Error: \(error.localizedDescription)")
    }
    
    // MARK: - Load View Methods
    
    let googleNativeAdsCustomeView1: GoogleNativeAdsCustomeView1 = GoogleNativeAdsCustomeView1.instanceFromNib() as! GoogleNativeAdsCustomeView1
    /// Load big native ads
    func showAdsView1(nativeAd: NativeAd, view: UIView) {
        view.isHidden = false
        displaySubViewtoParentView(view, subview: googleNativeAdsCustomeView1)
        googleNativeAdsCustomeView1.nativeAd = nativeAd
        googleNativeAdsCustomeView1.setup()
    }
    
    let googleNativeAdsCustomeView2: GoogleNativeAdsCustomeView2 = GoogleNativeAdsCustomeView2.instanceFromNib() as! GoogleNativeAdsCustomeView2
    /// Load Ads like table view cell (Like Banner Ads)
    func showAdsView2(nativeAd: NativeAd, view: UIView) {
        view.isHidden = false
        displaySubViewtoParentView(view, subview: googleNativeAdsCustomeView2)
        googleNativeAdsCustomeView2.nativeAd = nativeAd
        googleNativeAdsCustomeView2.setup()
    }
    
    let googleNativeAdsCustomeView4: GoogleNativeAdsCustomeView4 = GoogleNativeAdsCustomeView4.instanceFromNib() as! GoogleNativeAdsCustomeView4
    /// Load Ads like table view cell (Like Banner Ads)
    func showAdsView4(nativeAd: NativeAd, view: UIView) {
        view.isHidden = false
        displaySubViewtoParentView(view, subview: googleNativeAdsCustomeView4)
        googleNativeAdsCustomeView4.nativeAd = nativeAd
        googleNativeAdsCustomeView4.setup()
    }
    
    let googleNativeAdsCustomeView3: GoogleNativeAdsCustomeView3 = GoogleNativeAdsCustomeView3.instanceFromNib() as! GoogleNativeAdsCustomeView3
    /// Load Ads like table view cell (Like Banner Ads)
    func showAdsView3(nativeAd: NativeAd, view: UIView) {
        view.isHidden = false
        displaySubViewtoParentView(view, subview: googleNativeAdsCustomeView3)
        googleNativeAdsCustomeView3.nativeAd = nativeAd
        googleNativeAdsCustomeView3.setup()
    }
    
    let googleNativeAdsCustomeView5: GoogleNativeAdsCustomeView5 = GoogleNativeAdsCustomeView5.instanceFromNib() as! GoogleNativeAdsCustomeView5
    /// Load Ads like table view cell (Like Banner Ads)
    func showAdsView5(nativeAd: NativeAd, view: UIView) {
        view.isHidden = false
        displaySubViewtoParentView(view, subview: googleNativeAdsCustomeView5)
        googleNativeAdsCustomeView5.nativeAd = nativeAd
        googleNativeAdsCustomeView5.setup()
    }
    
    let googleNativeAdsCustomeView6: GoogleNativeAdsCustomeView6 = GoogleNativeAdsCustomeView6.instanceFromNib() as! GoogleNativeAdsCustomeView6
    /// Load Ads like table view cell (Like Banner Ads)
    func showAdsView6(nativeAd: NativeAd, view: UIView) {
        view.isHidden = false
        displaySubViewtoParentView(view, subview: googleNativeAdsCustomeView6)
        googleNativeAdsCustomeView6.nativeAd = nativeAd
        googleNativeAdsCustomeView6.setup()
    }
    
}


