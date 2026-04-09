//
//  NewsVC.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import UIKit
import Alamofire

class NewsVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
            self.tblView.register(UINib(nibName: "ADTableCell", bundle: nil), forCellReuseIdentifier: "ADTableCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var newsLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    
    var googleNativeAds = GoogleNativeAds()
    
    var allNews: [NewsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.News)
        self.showAd()
        showLoader()
        self.fetchFreshNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar(animated: true, vc: self)
        self.newsLbl.text = "News".localized()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeLoader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    
    @IBAction func clickOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension NewsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return self.allNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "ADTableCell") as! ADTableCell
            cell.showSkeleton()
            if isUserSubscribe() == false {
                cell.nativeAdView.showAnimatedSkeleton()
                self.googleNativeAds.loadAds(vc: self) { nativeAdsTemp in
                    cell.nativeAdView.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        cell.hideSkeleton()
                        self.googleNativeAds.showAdsView4(nativeAd: nativeAdsTemp, view: cell.nativeAdView)
                    }
                }
                self.googleNativeAds.failAds(vc: self) { fail in
                    print(" Home...Native fail....")
                    cell.nativeAdView.isHidden = true
                }
            } else {
                cell.hideSkeleton()
                cell.nativeAdView.isHidden = true
            }
            return cell
        }
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        let temp = self.allNews[indexPath.row]
        cell.titleLbl.text = temp.title
        cell.detailLbl.text = temp.subDesc
        
        if let imageUrl = URL(string: temp.imageUrl) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.thumbImg?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let temp = self.allNews[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
            vc.titleName = temp.title
            vc.descNews = temp.subDesc
            vc.article = temp.article
            vc.imgNews = temp.imageUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }
        return 120
    }
}

//MARK: - News API Call
extension NewsVC {
    func fetchFreshNews() {
        let params: [String: Any] = [
            "category": ["Football"]
        ]
        
        AF.request("\(NewsAPI)fresh-news",
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate(statusCode: 200..<300)
        .responseData { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let data):
                // Decode off the main thread
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let decoder = JSONDecoder()
                        let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                        let dataArr = newsResponse.data
                        
                        // Back to main for UI updates
                        DispatchQueue.main.async {
                            removeLoader()
                            self.allNews = dataArr
                            self.tblView.reloadData()
                        }
                    } catch {
                        // decoding failed — show/log details on main thread
                        DispatchQueue.main.async {
                            print("❌ Decoding error:", error.localizedDescription)
                            if let json = String(data: data, encoding: .utf8) {
                                print("🧾 Server response: \(json)")
                            }
                        }
                    }
                }
                
            case .failure(let afError):
                // network/HTTP error — handle on main thread
                DispatchQueue.main.async {
                    print("❌ Network error:", afError.localizedDescription)
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("🧾 Server response: \(jsonString)")
                    }
                }
            }
        }
    }
}
