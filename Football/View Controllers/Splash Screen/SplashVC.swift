//
//  SplashVC.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import UIKit
import Lottie
import SwiftyJSON
import AWSCore

class SplashVC: UIViewController {

    @IBOutlet weak var animationImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(naviToTab), name: NSNotification.Name(rawValue: "naviToTab"), object: nil)
        self.webservice_getJSON_api(url: getJSON, params: [:], header: [:])
        self.designSetUP()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func designSetUP() {
        if let gifURL = Bundle.main.url(forResource: "Football", withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL) {
            
            let image = UIImage.gif(data: gifData)
            animationImgView.image = image
            animationImgView.contentMode = .scaleAspectFit
        }
    }
    
    func naviToGetStart() {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as! GetStartedVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func naviToHome() {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func naviToIntroOne() {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func naviToIntroTwo() {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "IntroTwoVC") as! IntroTwoVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToLanguage() {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        vc.isFromSplash = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpNavi() {
        
        if isShowLanguage() == true {
            self.navigateToLanguage()
        } else if !isShowIntroOne() {
            self.naviToIntroOne()
        } else if !isShowConfirmPrivacyScreen() {
            self.naviToGetStart()
        } else {
            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
        }
      
    }
    
    func navigateToVc() {
        let credentials = AWSStaticCredentialsProvider(accessKey: ACCESS, secretKey: SECRET)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentials)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        AdsManager.shared.requestForConsentForm { (isConsentGranted) in
            
            if isConsentGranted {
                isComeFromSplash = true
                appOpenHome = true
                AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
            } else {
                isComeFromSplash = true
                appOpenHome = true
                Task {
                    await AppOpenAdManager.shared.loadAd()
                }
                AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
            }
        }
    }
    
    @objc func naviToTab() {
        
        if isShowLanguage() == false {
            self.navigateToLanguage()
        } else if !isShowIntroOne() {
            self.naviToIntroOne()
        } else if !isShowConfirmPrivacyScreen() {
            self.naviToGetStart()
        } else {
            self.naviToHome()
        }
       
    }

}

extension SplashVC {
    func webservice_getJSON_api(url : String,params : NSDictionary,header:[String:String]) {
        WebServices().CallGlobalAPI(url: url, headers: header, parameters: params, httpMethod: "GET", progressView: false, uiView : self.view) {(  jsonResponse:JSON? ,  strErrorMessage:String) in
            if strErrorMessage.count != 0
            {
            }
            else
            {
                let jsonDict = jsonResponse!.dictionaryValue
                if jsonDict.isEmpty {
                } else {
                    
                    bannerId = jsonDict["bannerId"]?.stringValue ?? ""
                    nativeId = jsonDict["nativeId"]?.stringValue ?? ""
                    interstialId = jsonDict["interstialId"]?.stringValue ?? ""
                    appopenId = jsonDict["appopenId"]?.stringValue ?? ""
                    rewardId = jsonDict["rewardId"]?.stringValue ?? ""
                    sec_bannerId = jsonDict["secBannerId"]?.stringValue ?? ""
                    sec_nativeId = jsonDict["secNativeId"]?.stringValue ?? ""
                    sec_interstialId = jsonDict["secInterstialId"]?.stringValue ?? ""
                    sec_appopenId = jsonDict["secAppopenId"]?.stringValue ?? ""
                    sec_rewardId = jsonDict["secRewardId"]?.stringValue ?? ""
                    addButtonColor = jsonDict["addButtonColor"]?.stringValue ?? "#7462FF"
                    
#if DEBUG
                    APITOKEN = "4c8a6959d4mshdda890c244de333p1a9559jsnfa944e297289"
#else
                    APITOKEN = jsonDict["extraFields"]?["tokenId"].stringValue ?? ""
#endif
                    
                    var customInterstial = jsonDict["customInterstial"]?.intValue ?? 0
                    afterClick = jsonDict["afterClick"]?.intValue ?? 2
                    
                    if let extraFields = jsonDict["extraFields"]?.dictionary {
                    
                        nativeId2 = extraFields["secNativeId"]?.stringValue ?? ""
                        NewsAPI = extraFields["story"]?.stringValue ?? ""
                    } else {
                        // "extraFields" key not found or not a dictionary
                        print("extraFields key not found or not a dictionary")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+7) {
                        self.navigateToVc()
                    }
                }
            }
        }
    }
}

