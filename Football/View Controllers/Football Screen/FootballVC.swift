//
//  FootballVC.swift
//  Football
//
//  Created by Ronik Hirpara on 17/02/25.
//

import UIKit

class FootballVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var liveView: View!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var upcomingView: View!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var completedView: View!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var nativeAdView: View!
    @IBOutlet weak var footballLbl: UILabel!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    private weak var pagerVc: CategoryPVC?
    var matchNameArr = ["Live Matches", "Upcoming Matches", "Finished Matches"]
    var googleNativeAds = GoogleNativeAds()
    
    // Calendar Properties
    private var selectedDateIndex = -1
    private var calendar = Calendar.current
    private var currentDate = Date()
    private var selectedDate = Date()
    private var dates: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setupDateCollectionView()
        setupInitialSelection()
        logAnalyticAction(title: "", status: AnalyticEvent.Match)
//        self.showAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.footballLbl.text = "Football".localized()
        self.liveLbl.text = "Live".localized()
        self.upcomingLbl.text = "Upcoming".localized()
        self.completedLbl.text = "Completed".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? CategoryPVC {
            pagerVc = pageViewController
            pagerVc?.tabDelegate = self
        }
    }
    
    private func setupDateCollectionView() {
        dateCollectionView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellWithReuseIdentifier: "DatePickerCell")
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        
        // Make collection view horizontal
        if let layout = dateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 0
        }
        dateCollectionView.showsHorizontalScrollIndicator = false
        dateCollectionView.backgroundColor = .clear
    }
    
    private func setupInitialSelection() {
        // By default select live view
        pagerVc?.moveToPage(index: 0, animated: false)
        updateButtonStates(selected: 0)
    }
    
    private func updateButtonStates(selected index: Int) {
        let selectedColor = UIColor.white
        let selectedTextColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        let unselectedColor = UIColor.clear
        let unselectedTextColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
        
        // Live button
        if index == 0 {
            liveView.backgroundColor = selectedColor
            liveLbl.textColor = selectedTextColor
            liveView.borderWidth = 0
        } else {
            liveView.backgroundColor = unselectedColor
            liveLbl.textColor = unselectedTextColor
            liveView.borderWidth = 1
            liveView.borderColor = unselectedTextColor
        }
        
        // Upcoming button
        if index == 1 {
            upcomingView.backgroundColor = selectedColor
            upcomingLbl.textColor = selectedTextColor
            upcomingView.borderWidth = 0
        } else {
            upcomingView.backgroundColor = unselectedColor
            upcomingLbl.textColor = unselectedTextColor
            upcomingView.borderWidth = 1
            upcomingView.borderColor = unselectedTextColor
        }
        
        // Completed button
        if index == 2 {
            completedView.backgroundColor = selectedColor
            completedLbl.textColor = selectedTextColor
            completedView.borderWidth = 0
        } else {
            completedView.backgroundColor = unselectedColor
            completedLbl.textColor = unselectedTextColor
            completedView.borderWidth = 1
            completedView.borderColor = unselectedTextColor
        }
    }
    
    private func setupCalendar() {
        generateDatesForRange()
        if let todayIndex = dates.firstIndex(where: { calendar.isDate($0, inSameDayAs: Date()) }) {
            selectedDateIndex = todayIndex
            selectedDate = dates[todayIndex]
        } else {
            selectedDateIndex = 0
            selectedDate = dates[0]
        }
        
        DispatchQueue.main.async {
            self.dateCollectionView.reloadData()
            self.scrollToSelectedDate(animated: false)
        }
    }
    
    private func scrollToSelectedDate(animated: Bool) {
        guard selectedDateIndex >= 0 && selectedDateIndex < dates.count else { return }
        let indexPath = IndexPath(item: selectedDateIndex, section: 0)
        dateCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    private func updateDateForAllVCs(_ date: Date) {
        if let pager = pagerVc {
            for vc in pager.arrVc {
                if let liveVC = vc as? LiveVC {
                    liveVC.updateDate(date)
                } else if let upcomingVC = vc as? UpcomingVC {
                    upcomingVC.updateDate(date)
                } else if let completedVC = vc as? CompletedVC {
                    completedVC.updateDate(date)
                }
            }
        }
    }
    
    private func generateDatesForRange() {
        dates.removeAll()
        let today = Date()
        
        // Generate 15 days (7 past, today, 7 future)
        for i in -7...7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
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
            self.nativeAdView.addSubview(adView)
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

    @IBAction func clickONBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnAll(_ sender: Any) {
        pagerVc?.moveToPage(index: 0, animated: true)
        updateButtonStates(selected: 0)
    }
    
    @IBAction func clickOnDomestic(_ sender: Any) {
        pagerVc?.moveToPage(index: 1, animated: true)
        updateButtonStates(selected: 1)
    }
    
    @IBAction func clickOnInternational(_ sender: Any) {
        pagerVc?.moveToPage(index: 2, animated: true)
        updateButtonStates(selected: 2)
    }
}

extension FootballVC: CategoryDelegate {
    
    func didPickItem(currentItem: Int) {
        if currentItem == 0 {
            //matchCat = "All"
            pagerVc?.moveToPage(index: 0, animated: true)
            
            self.liveView.backgroundColor = .white
            self.liveLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            
            self.upcomingLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.upcomingView.backgroundColor = .clear
            self.upcomingView.borderWidth = 1
            self.upcomingView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.completedLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.completedView.backgroundColor = .clear
            self.completedView.borderWidth = 1
            self.completedView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
        } else if currentItem == 1 {
            //matchCat = "Domestic"
            pagerVc?.moveToPage(index: 1, animated: true)
            
            self.liveView.backgroundColor = .clear
            self.liveLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.liveView.borderWidth = 1
            self.liveView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.upcomingLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            self.upcomingView.backgroundColor = .white
             
            self.completedLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.completedView.backgroundColor = .clear
            self.completedView.borderWidth = 1
            self.completedView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
        } else if currentItem == 2 {
            //matchCat = "International"
            pagerVc?.moveToPage(index: 2, animated: true)
            
            self.liveView.backgroundColor = .clear
            self.liveLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.liveView.borderWidth = 1
            self.liveView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.upcomingLbl.textColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            self.upcomingView.backgroundColor = .clear
            self.upcomingView.borderWidth = 1
            self.upcomingView.borderColor = UIColor(red: 0.73, green: 0.77, blue: 0.84, alpha: 1.00)
            
            self.completedLbl.textColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
            self.completedView.backgroundColor = .white
        }
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FootballVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
        let date = dates[indexPath.item]
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        let isSelected = (indexPath.item == selectedDateIndex)
        cell.configure(isSelected: isSelected, dayName: dayFormatter.string(from: date).uppercased(), date: dateFormatter.string(from: date))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedDateIndex != indexPath.item {
            selectedDateIndex = indexPath.item
            selectedDate = dates[indexPath.item]
            dateCollectionView.reloadData()
            scrollToSelectedDate(animated: true)
            updateDateForAllVCs(selectedDate)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set cell size: height 48, width 34 as requested
        return CGSize(width: 34, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Add horizontal insets for better centering
        let totalCellWidth = 34 * CGFloat(dates.count)
        let totalSpacingWidth = 8 * CGFloat(dates.count - 1)
        let totalWidth = totalCellWidth + totalSpacingWidth
        let horizontalInset = (collectionView.frame.width - totalWidth) / 2
        
        if horizontalInset > 0 {
            return UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
