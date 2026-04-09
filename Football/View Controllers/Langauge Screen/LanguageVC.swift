//
//  LanguageVC.swift
//  Football
//
//  Created by Ronik Hirpara on 25/02/25.
//

import UIKit

struct LanguageModel {
    var name: String
    var code: String
    var subName: String
}

class LanguageVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var doneBtn: Button!
    @IBOutlet weak var langaugeLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    
    var arrLanguage: [LanguageModel] = [
        .init(name: "English", code: "en", subName: "English"),
        .init(name: "Hindi", code: "hi", subName: "हिन्दी"),
        .init(name: "German", code: "de", subName: "Deutsch"),
        .init(name: "Danish", code: "da", subName: "Dansk"),
        .init(name: "Italian", code: "it", subName: "Italiana"),
        .init(name: "Portuguese", code: "pt-PT", subName: "Português"),
        .init(name: "Spanish", code: "es", subName: "Española"),
        .init(name: "Turkish", code: "tr", subName: "Türkçe"),
        .init(name: "French", code: "fr", subName: "Français"),
        .init(name: "Russian", code: "ru", subName: "Русский"),
        .init(name: "Chinese", code: "zh-Hant", subName: "中國人"),
        .init(name: "Japanese", code: "ja", subName: "日本語"),
        .init(name: "Dutch", code: "nl", subName: "Nederlands"),
        .init(name: "Korean", code: "ko", subName: "한국인")
        
    ]
    var googleNativeAds = GoogleNativeAds()
    var selectedLanguage = LanguageModel.init(name: "English", code: "en", subName: "English")
    var selected:Int? = 0
    var isFromSplash = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.Language)
        self.showAd()
        selectedLanguage.code = UserDefaults.standard.string(forKey: Preference.sharedInstance.App_LANGUAGE_KEY) ?? "en"
        self.tblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectedLanguageManage()
    }
    
    func showAd() {
        self.showSkeleton()
        if isUserSubscribe() == false {
            self.nativeAdView.showAnimatedSkeleton()
            self.googleNativeAds.loadAds(vc: self) { nativeAdsTemp in
                self.nativeAdView.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.hideSkeleton()
                    self.googleNativeAds.showAdsView6(nativeAd: nativeAdsTemp, view: self.nativeAdView)
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
    
    func selectedLanguageManage() {
        if selectedLanguage.code == "en" {
            selected = 0
        }
        else if selectedLanguage.code == "hi" {
            selected = 1
        }
        else if selectedLanguage.code == "de" {
            selected = 2
        }
        else if selectedLanguage.code == "da" {
            selected = 3
        }
        else if selectedLanguage.code == "it" {
            selected = 4
        }
        else if selectedLanguage.code == "pt-PT" {
            selected = 5
        }
        else if selectedLanguage.code == "es" {
            selected = 6
        }
        else if selectedLanguage.code == "tr" {
            selected = 7
        }
        else if selectedLanguage.code == "fr" {
            selected = 8
        }
        else if selectedLanguage.code == "ru" {
            selected = 9
        }
        else if selectedLanguage.code == "zh-Hant" {
            selected = 10
        }
        else if selectedLanguage.code == "ja" {
            selected = 11
        }
        else if selectedLanguage.code == "nl" {
            selected = 12
        }
        else if selectedLanguage.code == "ko" {
            selected = 13
        }
    }
    
    @IBAction func clickOnDone(_ sender: Any) {
        Bundle.setLanguage(lang: selectedLanguage.code)
        setLanguageCode(str: selectedLanguage.code)
        setIsLanguage(status: true)
        if self.isFromSplash {
            let vc = StoryBoard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}

extension LanguageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        
        cell.nameLbl.text = "\(self.arrLanguage[indexPath.row].subName) "
        cell.subNameLbl.text = "(\(self.arrLanguage[indexPath.row].name))"
        cell.thumbImg.image = UIImage(named: self.arrLanguage[indexPath.row].code)
        if selected == indexPath.row {
            cell.mainView.borderColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            cell.mainView.borderWidth = 1
        } else {
            cell.mainView.borderColor = .clear
            cell.mainView.borderWidth = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLanguage = self.arrLanguage[indexPath.row]
        self.selected = indexPath.row
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
