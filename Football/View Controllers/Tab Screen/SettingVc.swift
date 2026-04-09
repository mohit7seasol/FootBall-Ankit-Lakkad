//
//  SettingVc.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import UIKit
import MessageUI

class SettingVc: UIViewController, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var settingLbl: UILabel!
    @IBOutlet weak var feedbackLbl: UILabel!
    @IBOutlet weak var feedbackDescLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var shareDescLbl: UILabel!
    @IBOutlet weak var rateAppLbl: UILabel!
    @IBOutlet weak var rateDEscLbl: UILabel!
    @IBOutlet weak var privacyLbl: UILabel!
    @IBOutlet weak var privacyDescLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var langaugeDescLbl: UILabel!
    @IBOutlet weak var termsTopLbl: UILabel!
    @IBOutlet weak var termsBottomLbl: UILabel!
    @IBOutlet weak var eulaTopLbl: UILabel!
    @IBOutlet weak var eulaBottomLbl: UILabel!
    @IBOutlet weak var premiumTopLbl: UILabel!
    @IBOutlet weak var premiumBottomLbl: UILabel!
    
    let mailComposer = MFMailComposeViewController()
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.Settings)
        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.languageLbl.text = "Language".localized()
        self.langaugeDescLbl.text = "App language changed.".localized()
        self.feedbackLbl.text = "Feedback".localized()
        self.feedbackDescLbl.text = "Valuable insights to enhance our app".localized()
        self.shareLbl.text = "Share App".localized()
        self.shareDescLbl.text = "Easily share the app with anyone.".localized()
        self.rateAppLbl.text = "Rate App".localized()
        self.rateDEscLbl.text = "Give your feedback and rate the app.".localized()
        self.privacyLbl.text = "Privacy Policy".localized()
        self.privacyDescLbl.text = "Read our Privacy Policy for more details.".localized()
        self.settingLbl.text = "Settings".localized()
        self.termsTopLbl.text = "Terms Of Use".localized()
        self.termsBottomLbl.text = "Accept the terms to move forward.".localized()
        self.eulaTopLbl.text = "EULA".localized()
        self.eulaBottomLbl.text = "Accept the EULA to move forward.".localized()
        self.premiumTopLbl.text = "Unlock Full Premium Access".localized()
        self.premiumBottomLbl.text = "Go Premium".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([MAIL])
            mail.setSubject(APP_NAME)
            mail.modalPresentationStyle = .overFullScreen
            present(mail, animated: true)
        } else if let emailUrl = createEmailUrl(to: MAIL, subject: APP_NAME) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    func createEmailUrl(to: String, subject: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)")
        
        if let defaultUrl = defaultUrl, UIApplication.shared.canOpenURL(defaultUrl) {
            return defaultUrl
        } else if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
    
    @IBAction func premiumTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PremiumVC") as! PremiumVC
        self.present(vc, animated: true)
    }
    
    @IBAction func clickOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnFeedback(_ sender: Any) {
        self.sendEmail()
    }
    
    @IBAction func clickOnRate(_ sender: Any) {
        if let url = URL.init(string: REVIEW_LINK) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func clickOnShare(_ sender: Any) {
        if let appStoreLink = URL(string: SHARE_ID), !appStoreLink.absoluteString.isEmpty {
            
            let objectsToShare = [appStoreLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickOnPrivacy(_ sender: Any) {
        logAnalyticAction(title: "", status: AnalyticEvent.Privacy)
        if let url = URL.init(string: PRIVACY_POLICY) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func clickOnLangauge(_ sender: Any) {
        let vc = StoryBoard.instantiateViewController(identifier: "LanguageVC") as! LanguageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termsTapped(_ sender: UIButton) {
        logAnalyticAction(title: "", status: AnalyticEvent.Terms)
        if let url = URL.init(string: TERM_AND_CONDITION) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func eulaTapped(_ sender: UIButton) {
        logAnalyticAction(title: "", status: AnalyticEvent.Eula)
        if let url = URL.init(string: EULA) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
