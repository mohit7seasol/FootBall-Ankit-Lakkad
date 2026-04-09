//
//  ScoreDetailsVC.swift
//  Football
//
//  Created by Ronik Hirpara on 05/02/25.
//

import UIKit
import MarqueeLabel

class ScoreDetailsVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleNameLbl: MarqueeLabel!
    @IBOutlet weak var team1Img: UIImageView!
    @IBOutlet weak var team2Img: UIImageView!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var completedLbl: MarqueeLabel!
    
    @IBOutlet weak var clcView: UICollectionView! {
        didSet {
            self.clcView.register(UINib(nibName: "ScoreTitleCell", bundle: nil), forCellWithReuseIdentifier: "ScoreTitleCell")
            self.clcView.showsVerticalScrollIndicator = false
            self.clcView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var footballLbl: UILabel!
    
    @IBOutlet weak var team1GoalLbl: UILabel!
    @IBOutlet weak var team1RLbl: UILabel!
    @IBOutlet weak var team1YLbl: UILabel!
    @IBOutlet weak var team1KickLbl: UILabel!
    @IBOutlet weak var team2KickLbl: UILabel!
    @IBOutlet weak var team2YLbl: UILabel!
    @IBOutlet weak var team2RLbl: UILabel!
    @IBOutlet weak var team2GoalLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    
    var selectedIndex : Int = 0
    var titleArr : [String] = []
    private let kItemPadding = 50
    private weak var pagerVc: ScoreDetailsPVC?
    var m_idMain:String?
    var l_idMain:String?
    var m_name:String?
    var Aname:String?
    var Bname:String?
    var Aimg:String?
    var Bimg:String?
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.MatchDetails)
        self.showAd()
        DispatchQueue.main.async {
            self.fetchMatchData()
        }
        self.team1Img.layer.cornerRadius = self.team1Img.frame.height/2
        self.team2Img.layer.cornerRadius = self.team2Img.frame.height/2
        
        if isComeFromUpcoming == true {
            self.titleArr = ["Squad","Info","Point Table"]
        } else {
            self.titleArr = ["Live Update","Overview","Lineups","Stats","Squad","Info","Point Table"]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.footballLbl.text = "Football".localized()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? ScoreDetailsPVC {
            pagerVc = pageViewController
            pagerVc?.m_idMain = self.m_idMain
            pagerVc?.l_idMain = self.l_idMain
            pagerVc?.Aname = self.Aname
            pagerVc?.Bname = self.Bname
            pagerVc?.tabDelegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func fetchMatchData() {
        fetchMatchTabs { [weak self] result in
            guard let self = self, let result = result else { return }
            DispatchQueue.main.async {
                self.team1GoalLbl.text = "\(result.t1_cornerKicks ?? 0)"
                self.team1RLbl.text = "\(result.t1_redCards ?? 0)"
                self.team1YLbl.text = "\(result.t1_yellowCards ?? 0)"
                self.team1KickLbl.text = "\(result.t1_penalties ?? 0)"
                
                self.scoreLbl.text = "\(result.t1_scr ?? 0) - \(result.t2_scr ?? 0)"
                self.completedLbl.text = "\(result.time ?? "") Completed"
                
                self.team2GoalLbl.text = "\(result.t2_cornerKicks ?? 0)"
                self.team2RLbl.text = "\(result.t2_redCards ?? 0)"
                self.team2YLbl.text = "\(result.t2_yellowCards ?? 0)"
                self.team2KickLbl.text = "\(result.t2_penalties ?? 0)"
                self.titleNameLbl.text = self.m_name
            }
        }
        
        DispatchQueue.main.async {
            if self.m_name?.isEmpty == false {
                self.navigationItem.title = self.m_name
            } else {
                self.navigationItem.title = ""
            }
            
            if self.Aname?.isEmpty == false {
                self.team1Lbl.text = self.Aname
            } else {
                self.team1Lbl.text = "TeamA"
            }
            
            if self.Bname?.isEmpty == false {
                self.team2Lbl.text = self.Bname
            } else {
                self.team2Lbl.text = "TeamB"
            }
            
            if self.Aimg?.isEmpty == false {
                let urlA = URL(string: self.Aimg!)
                self.team1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
            } else {
                self.team1Img.image = UIImage(named: "ic_replace")!
            }
            
            if self.Bimg?.isEmpty == false {
                let urlA = URL(string: self.Bimg!)
                self.team2Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
            } else {
                self.team2Img.image = UIImage(named: "ic_replace")!
            }
        }
    }
    
    func fetchMatchTabs(completion: @escaping (ResultDataLive?) -> Void) {
        let url = URL(string: MatchTabAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = ["spt_typ": 2, "l_id": l_idMain!, "m_id": m_idMain!] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error:", error ?? "Unknown error")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MatchTabsResponse.self, from: data)
                if response.status, let result = response.result {
                    completion(result)
                } else {
                    completion(nil)
                }
            } catch {
                print("JSON decoding error:", error)
                completion(nil)
            }
        }.resume()
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
    

}

extension ScoreDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clcView.dequeueReusableCell(withReuseIdentifier: "ScoreTitleCell", for: indexPath) as! ScoreTitleCell
        cell.titleLbl.text = self.titleArr[indexPath.row]
        cell.config(isSelected: indexPath.row == self.selectedIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clcView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        self.selectedIndex = indexPath.row
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.clcView.reloadData()
        }
        
        print("------------------------------", self.titleArr[indexPath.row])
        if self.titleArr[indexPath.row] == "Live Update" {
            pagerVc?.moveToPage(index: 0, animated: true)
        } else if self.titleArr[indexPath.row] == "Overview" {
            pagerVc?.moveToPage(index: 1, animated: true)
        } else if self.titleArr[indexPath.row] == "Lineups" {
            pagerVc?.moveToPage(index: 2, animated: true)
        } else if self.titleArr[indexPath.row] == "Stats" {
            pagerVc?.moveToPage(index: 3, animated: true)
        } else if self.titleArr[indexPath.row] == "Squad" {
            if isComeFromUpcoming == true {
                pagerVc?.moveToPage(index: 0, animated: true)
            } else {
                pagerVc?.moveToPage(index: 4, animated: true)
            }
        } else if self.titleArr[indexPath.row] == "Info" {
            if isComeFromUpcoming == true {
                pagerVc?.moveToPage(index: 1, animated: true)
            } else {
                pagerVc?.moveToPage(index: 5, animated: true)
            }
        } else if self.titleArr[indexPath.row] == "Point Table" {
            if isComeFromUpcoming == true {
                pagerVc?.moveToPage(index: 2, animated: true)
            } else {
                pagerVc?.moveToPage(index: 6, animated: true)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //return CGSize(width: (self.clcView.bounds.width), height: 20)
        
        let lblWidth = textSize(font: UIFont.systemFont(ofSize: 16, weight: .regular), text: self.titleArr[indexPath.row])
        return CGSize(width: lblWidth+10, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cellCount = CGFloat(self.titleArr.count)

        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.

                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                if isComeFromUpcoming == true {
                    return UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 90)
                } else {
                    return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                }
            }
            
        }
        return UIEdgeInsets.zero
    }
    
}

extension ScoreDetailsVC: MICollectionViewBubbleLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, itemSizeAt indexPath: NSIndexPath) -> CGSize {
        let title = self.titleArr[indexPath.row]
        var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!])
        let spacing = 18.0
        let totalWidth = Float(size.width + spacing + CGFloat(kItemPadding * 2))
        size.width = CGFloat(ceilf(totalWidth))
        size.height = 20

        //...Checking if item width is greater than collection view width then set item width == collection view width.
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return CGSize(width: 0, height: 0) //size
    }
    
}

extension ScoreDetailsVC: ScoreDelegate {
    
    func didPickItem(currentItem: Int) {
        if currentItem == 0 {
            pagerVc?.moveToPage(index: 0, animated: true)
        } else if currentItem == 1 {
            pagerVc?.moveToPage(index: 1, animated: true)
        } else if currentItem == 2 {
            pagerVc?.moveToPage(index: 2, animated: true)
        } else if currentItem == 3 {
            pagerVc?.moveToPage(index: 3, animated: true)
        } else if currentItem == 4 {
            if isComeFromUpcoming == true {
                pagerVc?.moveToPage(index: 0, animated: true)
            } else {
                pagerVc?.moveToPage(index: 4, animated: true)
            }
        } else if currentItem == 5 {
            if isComeFromUpcoming == true {
                pagerVc?.moveToPage(index: 1, animated: true)
            } else {
                pagerVc?.moveToPage(index: 5, animated: true)
            }
        } else if currentItem == 6 {
            if isComeFromUpcoming == true {
                pagerVc?.moveToPage(index: 2, animated: true)
            } else {
                pagerVc?.moveToPage(index: 6, animated: true)
            }
        }
    }
}
