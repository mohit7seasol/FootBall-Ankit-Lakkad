//
//  CompletedVC.swift
//  Football
//
//  Created by Ronik Hirpara on 05/02/25.
//

import UIKit
import ProgressHUD

class CompletedVC: UIViewController {
    
    @IBOutlet weak var viewForNative: UIView!
    @IBOutlet weak var completedCollection: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    
    var googleNativeAds = GoogleNativeAds()
    var completedMatches: [Match] = []
    var selectedDate = Date()
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchCompletedMatches()
        showAd()
    }
    
    private func setupCollectionView() {
        completedCollection.register(UINib(nibName: "MatchListCell", bundle: nil), forCellWithReuseIdentifier: "MatchListCell")
        completedCollection.delegate = self
        completedCollection.dataSource = self
        
        if let layout = completedCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
        }
    }
    
    private func fetchCompletedMatches() {
        ProgressHUD.show()
        
        FootballAPIService.shared.fetchMatches(for: selectedDate) { [weak self] matches in
            guard let self = self else { return }
            self.completedMatches = matches.filter { $0.isFinished }
                .sorted { $0.timestamp > $1.timestamp }
            
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                
                if self.completedMatches.isEmpty {
                    self.completedCollection.isHidden = true
                    self.noDataView.isHidden = false
                } else {
                    self.completedCollection.isHidden = false
                    self.noDataView.isHidden = true
                    self.completedCollection.reloadData()
                }
            }
        }
    }
    
    func updateDate(_ date: Date) {
        selectedDate = date
        fetchCompletedMatches()
    }
}

extension CompletedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return completedMatches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchListCell", for: indexPath) as! MatchListCell
        let match = completedMatches[indexPath.item]
        cell.configureForCompleted(match: match)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showInterAd()
        // Navigate to match details
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 180 : 160
        let width = collectionView.frame.width - 24
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}

extension CompletedVC {
    
    func showAd() {
        self.showSkeleton()
        if isUserSubscribe() == false {
            self.viewForNative.showAnimatedSkeleton()
            self.googleNativeAds.loadAds(vc: self) { nativeAdsTemp in
                self.viewForNative.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.hideSkeleton()
                    self.googleNativeAds.showAdsView3(nativeAd: nativeAdsTemp, view: self.viewForNative)
                }
            }
            self.googleNativeAds.failAds(vc: self) { fail in
                print(" Home...Native fail....")
                self.viewForNative.isHidden = true
            }
        } else {
            self.hideSkeleton()
            self.viewForNative.isHidden = true
            
        }
        
    }
    
    func showSkeleton() {
        if let adView = Bundle.main.loadNibNamed("SkeletonCustomView3", owner: self, options: nil)?.first as? SkeletonCustomView3 {
            // Add the custom UIView to the adContainerView
            self.viewForNative.addSubview(adView)
            
            // Set constraints to make sure the adView fills the adContainerView
            adView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: self.viewForNative.topAnchor),
                adView.leadingAnchor.constraint(equalTo: self.viewForNative.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: self.viewForNative.trailingAnchor),
                adView.bottomAnchor.constraint(equalTo: self.viewForNative.bottomAnchor)
            ])
            adView.view1.showAnimatedGradientSkeleton()
            adView.view2.showAnimatedGradientSkeleton()
            adView.view3.showAnimatedGradientSkeleton()
            adView.view4.showAnimatedGradientSkeleton()
            adView.view5.showAnimatedGradientSkeleton()

        }
    }
    
    func hideSkeleton() {
        for subview in self.viewForNative.subviews {
            if let adView = subview as? SkeletonCustomView3 {
                adView.removeFromSuperview()
            }
        }
    }
}
