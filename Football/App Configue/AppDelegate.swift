//
//  AppDelegate.swift
//  Football
//
//  Created by Ronik Hirpara on 03/02/25.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds
import FirebaseCore
import FirebasePerformance

@main
class AppDelegate: UIResponder, UIApplicationDelegate, FullScreenContentDelegate {

    var window: UIWindow?
    var appOpenAd: AppOpenAd?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        isAppStart = true
        self.initView()
        delay(1.5) {
            Task {
                await AppOpenAdManager.shared.loadAd()
            }
        }
        FirebaseApp.configure()
        FirebaseApp.debugDescription()
        // Enable performance monitoring
        Performance.sharedInstance().isInstrumentationEnabled = true
        Performance.sharedInstance().isDataCollectionEnabled = true
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        Task {
            await SubscriptionManager.shared.checkSubscriptionStatus()
        }
        return true
    }
    

    func initView() {
        Task {
            await AppOpenAdManager.shared.loadAd()
        }
        //AdsManager.shared.loadInterstitialAd()
        
    }
    
    func shared() -> AppDelegate {
        return appDelegate //UIApplication.shared.delegate as! AppDelegate
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        isBackgound = true
    }
    
    // MARK: - Loader
    func showLoader() {
        SVProgressHUD.show()
    }
    
    func removeLoader() {
        SVProgressHUD.dismiss()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //AdsManager.shared.requestIDFA()
        if isBackgound {
            isBackgound = false
            tryToPresentAd()
        } else {
            if isAppStart {
                isAppStart = false
                tryToPresentAd()
            }
        }
    }
    
    func requestAppOpenAd() {
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
            })
    }
    
    func tryToPresentAd() {
        if let rwc = UIApplication.shared.windows.last?.rootViewController  {
            requestAppOpenAd()
            self.appOpenAd?.present(from: rwc)
        } else {
            self.requestAppOpenAd()
        }
    }

}

