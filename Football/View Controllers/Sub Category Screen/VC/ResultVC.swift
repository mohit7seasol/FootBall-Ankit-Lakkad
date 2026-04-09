//
//  ResultVC.swift
//  Football
//
//  Created by Ronik Hirpara on 03/02/25.
//

import UIKit

class ResultVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var matchCollectionView: UICollectionView! {
        didSet {
            self.matchCollectionView.delegate = self
            self.matchCollectionView.dataSource = self
            self.matchCollectionView.register(UINib(nibName: "SeriesMatchCell", bundle: nil), forCellWithReuseIdentifier: "SeriesMatchCell")
            matchCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
            self.matchCollectionView.showsVerticalScrollIndicator = false
            self.matchCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var seriesLbl: UILabel!
    
    var index = -1
    var matches: [MatchResultAll] = []
    var isAscending: Bool = true
    var league: LeagueSeries?
    var isComeFromSeries: Bool = false
    var name = String()
    var nativeAdView = UIView()
    var googleNativeAds = GoogleNativeAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nativeAdView = UIView()
        nativeAdView.backgroundColor = .clear
        self.showAd()
        showLoader()
        DispatchQueue.main.async {
            if self.league?.matches.isEmpty == true {
                self.matchCollectionView.isHidden = true
                self.emptyView.isHidden = false
            } else {
                self.matchCollectionView.isHidden = false
                self.emptyView.isHidden = true
            }
            removeLoader()
            self.matchCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.seriesLbl.text = "Football Serires".localized()
        self.noDataLbl.text = "No Data Available".localized()
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            coordinator.animate(alongsideTransition: { _ in
                if UIDevice.current.orientation.isLandscape {
                    print("Landscape orientation")
                } else if UIDevice.current.orientation.isPortrait {
                    print("Portrait orientation")
                }
                self.matchCollectionView.reloadData()
            })
        }
    }
    
    @IBAction func clickOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension ResultVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return league?.matches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesMatchCell", for: indexPath) as! SeriesMatchCell
        
        if let match = league?.matches[indexPath.row] {
            
            if match.match_info.l_name.isEmpty == true {
                cell.matchNameLbl.text = "Series"
            } else {
                cell.matchNameLbl.text = match.match_info.l_name
            }
            
            cell.matchNameLbl?.text = match.m_name
            cell.resultLbl.text = match.match_info.venue
            
            cell.match1Lbl.text = match.t1_sname
            cell.match2Lbl.text = match.t2_sname
            
            if match.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: match.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            if match.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: match.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            let result = convertTimestamp(match.strt_time_ts)
            cell.dateLbl.text = result.formattedDate
            //cell.timeLbl.text = result.formattedTime
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isComeFromUpcoming = true
            let temp = self.league?.matches[indexPath.row]
            let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
            vc.l_idMain = temp?.l_id
            vc.m_idMain = temp?.m_id
            vc.m_name = temp?.m_name
            vc.Aimg = temp?.t1_flag
            vc.Bimg = temp?.t2_flag
            vc.Aname = temp?.t1_sname
            vc.Bname = temp?.t2_sname
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (self.matchCollectionView.frame.size.width - 42) / 2, height: 250)
        } else {
            return CGSize(width: (self.matchCollectionView.frame.size.width - 32), height: 200)
        }
    }
}

//MARK: - Ads Methods
extension ResultVC {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
                
                headerView.subviews.forEach { $0.removeFromSuperview() }
                headerView.backgroundColor = .clear
                nativeAdView.frame = headerView.bounds
                headerView.addSubview(nativeAdView)
                
                nativeAdView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    nativeAdView.topAnchor.constraint(equalTo: headerView.topAnchor),
                    nativeAdView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
                    nativeAdView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -5),
                    nativeAdView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
                ])
                
                return headerView
            }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            if isUserSubscribe() == true || nativeId == "" || nativeId == "ca"  {
                return CGSize(width: collectionView.frame.width, height: 0)
            } else {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return CGSize(width: collectionView.frame.width, height: 170)
                } else {
                    return CGSize(width: collectionView.frame.width, height: 150)
                }
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
    
}
