//
//  FootballVC.swift
//  Football
//
//  Created by Ronik Hirpara on 17/02/25.
//

import UIKit
import ProgressHUD

class FootballVC: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var upcomingView: UIView!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var footballLbl: UILabel!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var toDayButton: UIButton!
    @IBOutlet weak var nativeAdView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var matchCollection: UICollectionView!
    @IBOutlet weak var matchCollectionHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonStackHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var addViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var stackHeightViewConstant: NSLayoutConstraint!
    
    var googleNativeAds = GoogleNativeAds()
    
    // MARK: - Match Status Properties (Add these)
    var isLiveMatch: Bool = false
    var isUpcomingMatch: Bool = false
    var isCompletedMatch: Bool = false
    
    // Calendar Properties
    private var selectedDateIndex = -1
    private var calendar = Calendar.current
    private var currentDate = Date()
    private var selectedDate = Date()
    private var dates: [Date] = []
    
    // Match Properties
    var allMatches: [Match] = []
    var currentFilter: MatchFilter = .live
    var matchesFiltered: [Match] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCalendar()
        setupCollectionViews()
        setupButtons()
        subscribe()
        logAnalyticAction(title: "", status: AnalyticEvent.Match)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMatches(for: selectedDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update collection view height after layout
        if matchesFiltered.count > 0 {
            matchCollectionHeightConstant.constant = matchCollection.contentSize.height
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            coordinator.animate(alongsideTransition: { _ in
                self.matchCollection.collectionViewLayout.invalidateLayout()
                self.matchCollection.reloadData()
            })
        }
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        configureProgressHUD()
        footballLbl.text = "Football".localized()
        liveLbl.text = "Live".localized()
        upcomingLbl.text = "Upcoming".localized()
        completedLbl.text = "Finished".localized()
        noDataLabel.text = "No matches found".localized()
        toDayButton.setTitle("Today".localized(), for: .normal)
        
        toDayButton.layer.cornerRadius = toDayButton.frame.height / 2
        
        // Disable collection view scrolling since it's inside scroll view
        matchCollection.isScrollEnabled = false
    }
    
    private func configureProgressHUD() {
        // Remove background
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorAnimation = UIColor(hex: "#173E75")
        
        // Optional customizations
        ProgressHUD.animationType = .lineScaling
    }
    
    private func setupCollectionViews() {
        // Date Collection View
        dateCollectionView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellWithReuseIdentifier: "DatePickerCell")
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        
        if let layout = dateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 0
        }
        dateCollectionView.showsHorizontalScrollIndicator = false
        dateCollectionView.backgroundColor = .clear
        
        // Match Collection View
        matchCollection.register(UINib(nibName: "MatchListCell", bundle: nil), forCellWithReuseIdentifier: "MatchListCell")
        matchCollection.delegate = self
        matchCollection.dataSource = self
        
        if let layout = matchCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.estimatedItemSize = .zero
        }
    }
    
    private func setupButtons() {
        liveView.layer.cornerRadius = liveView.frame.height / 2
        upcomingView.layer.cornerRadius = upcomingView.frame.height / 2
        completedView.layer.cornerRadius = completedView.frame.height / 2
        
        updateButtonStates(selected: .live)
    }
    
    private func updateButtonStates(selected: MatchFilter) {
        let selectedColor = UIColor(red: 0.09, green: 0.24, blue: 0.46, alpha: 1.00)
        let selectedTextColor = UIColor.white
        let unselectedColor = UIColor.clear
        let unselectedTextColor = #colorLiteral(red: 0.5293739438, green: 0.5293739438, blue: 0.5293739438, alpha: 1)
        
        switch selected {
        case .live:
            liveView.backgroundColor = selectedColor
            upcomingView.backgroundColor = unselectedColor
            completedView.backgroundColor = unselectedColor
            liveLbl.textColor = selectedTextColor
            upcomingLbl.textColor = unselectedTextColor
            completedLbl.textColor = unselectedTextColor
            liveView.layer.borderWidth = 0
            upcomingView.layer.borderWidth = 1
            completedView.layer.borderWidth = 1
            upcomingView.layer.borderColor = unselectedTextColor.cgColor
            completedView.layer.borderColor = unselectedTextColor.cgColor
            
        case .scheduled:
            liveView.backgroundColor = unselectedColor
            upcomingView.backgroundColor = selectedColor
            completedView.backgroundColor = unselectedColor
            liveLbl.textColor = unselectedTextColor
            upcomingLbl.textColor = selectedTextColor
            completedLbl.textColor = unselectedTextColor
            liveView.layer.borderWidth = 1
            upcomingView.layer.borderWidth = 0
            completedView.layer.borderWidth = 1
            liveView.layer.borderColor = unselectedTextColor.cgColor
            completedView.layer.borderColor = unselectedTextColor.cgColor
            
        case .completed:
            liveView.backgroundColor = unselectedColor
            upcomingView.backgroundColor = unselectedColor
            completedView.backgroundColor = selectedColor
            liveLbl.textColor = unselectedTextColor
            upcomingLbl.textColor = unselectedTextColor
            completedLbl.textColor = selectedTextColor
            liveView.layer.borderWidth = 1
            upcomingView.layer.borderWidth = 1
            completedView.layer.borderWidth = 0
            liveView.layer.borderColor = unselectedTextColor.cgColor
            upcomingView.layer.borderColor = unselectedTextColor.cgColor
        }
    }
    
    private func updateMatchTypeVisibility() {
        if calendar.isDateInToday(selectedDate) {
            buttonStackView.isHidden = false
            buttonStackHeightConstant.constant = 35
            if currentFilter != .live {
                currentFilter = .live
                updateButtonStates(selected: .live)
                applyFilter()
            }
        } else {
            buttonStackView.isHidden = true
            buttonStackHeightConstant.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: currentDate)
    }
    
    private func setupCalendar() {
        generateDatesForRange()
        updateMonthLabel()
        if let todayIndex = dates.firstIndex(where: { calendar.isDate($0, inSameDayAs: Date()) }) {
            selectedDateIndex = todayIndex
            selectedDate = dates[todayIndex]
        } else {
            selectedDateIndex = 0
            selectedDate = dates[0]
        }
        updateMatchTypeVisibility()
        DispatchQueue.main.async {
            self.dateCollectionView.reloadData()
            self.dateCollectionView.scrollToItem(at: IndexPath(item: self.selectedDateIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func generateDatesForRange() {
        dates.removeAll()
        let today = Date()
        
        for i in -7...7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
    }
    
    private func setToday() {
        currentDate = Date()
        selectedDate = Date()
        setupCalendar()
        fetchMatches(for: selectedDate)
        updateMatchTypeVisibility()
    }
    
    private func apiDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func convertTimestamp(_ timestamp: Int) -> (formattedDate: String, formattedTime: String) {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        return (dateFormatter.string(from: date), timeFormatter.string(from: date))
    }
    
    // MARK: - Match Fetching
    private func fetchMatches(for date: Date) {
        ProgressHUD.show()
        
        // Show placeholder while loading
        DispatchQueue.main.async { [weak self] in
            self?.matchCollection.isHidden = true
            self?.noDataView.isHidden = false
            self?.matchCollectionHeightConstant.constant = 0
        }
        
        FootballAPIService.shared.fetchMatches(for: date) { [weak self] matches in
            guard let self = self else {
                ProgressHUD.dismiss()
                return
            }
            
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.allMatches = matches
                self.applyFilter()
            }
        }
    }
    
    private func applyFilter() {
        if calendar.isDateInToday(selectedDate) {
            switch currentFilter {
            case .live:
                matchesFiltered = allMatches.filter { $0.isInProgress }
                    .sorted { $0.timestamp < $1.timestamp }
                print("Live matches count: \(matchesFiltered.count)")
            case .scheduled:
                matchesFiltered = allMatches.filter { !$0.isStarted && !$0.isInProgress && !$0.isFinished }
                    .sorted { $0.timestamp < $1.timestamp }
                print("Upcoming matches count: \(matchesFiltered.count)")
            case .completed:
                matchesFiltered = allMatches.filter { $0.isFinished }
                    .sorted { $0.timestamp > $1.timestamp }
                print("Finished matches count: \(matchesFiltered.count)")
            }
        } else {
            matchesFiltered = allMatches
            if selectedDate < Date() {
                matchesFiltered.sort { $0.timestamp > $1.timestamp }
                print("Past matches count: \(matchesFiltered.count)")
            } else {
                matchesFiltered.sort { $0.timestamp < $1.timestamp }
                print("Future matches count: \(matchesFiltered.count)")
            }
        }
        
        // Update UI on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.matchCollection.reloadData()
            self.updatePlaceholderVisibility()
            
            if self.matchesFiltered.count > 0 {
                self.matchCollection.setContentOffset(.zero, animated: false)
            }
            
            // Update collection view height constraint based on content size
            // Use asyncAfter to ensure content size is calculated
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.matchCollectionHeightConstant.constant = self.matchCollection.contentSize.height
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func updatePlaceholderVisibility() {
        if matchesFiltered.isEmpty {
            matchCollection.isHidden = true
            noDataView.isHidden = false
            matchCollectionHeightConstant.constant = 0
        } else {
            noDataView.isHidden = true
            matchCollection.isHidden = false
        }
    }
    
    // MARK: - Ads
    func subscribe() {
        showSkeletonView()
        if isUserSubscribe() == false {
            self.addViewHeightConstant.constant = 154
            self.stackHeightViewConstant.constant = 154
            self.googleNativeAds.loadAds(vc: self) { nativeAdsTemp in
                self.nativeAdView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.hideSkeletonView()
                    self.googleNativeAds.showAdsView4(nativeAd: nativeAdsTemp, view: self.nativeAdView)
                }
            }
            self.googleNativeAds.failAds(vc: self) { fail in
                print("Native ad failed to load")
                self.nativeAdView.isHidden = true
                self.addViewHeightConstant.constant = 0
                self.stackHeightViewConstant.constant = 0
            }
        } else {
            self.hideSkeletonView()
            nativeAdView.isHidden = true
            self.addViewHeightConstant.constant = 0
            self.stackHeightViewConstant.constant = 0
        }
    }
    
    func showSkeletonView() {
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
    
    func hideSkeletonView() {
        for subview in self.nativeAdView.subviews {
            if let adView = subview as? SkeletonCustomView4 {
                adView.removeFromSuperview()
            }
        }
    }
    private func handleDateSelection(at index: Int) {
        guard selectedDateIndex != index else { return }
        
//        self.showInterAds()
        self.selectedDateIndex = index
        self.selectedDate = dates[index]
        self.fetchMatches(for: selectedDate)
        self.updateMatchTypeVisibility()
        
        DispatchQueue.main.async {
            self.dateCollectionView.reloadData()
            self.dateCollectionView.scrollToItem(at: IndexPath(item: self.selectedDateIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.matchCollection.setContentOffset(.zero, animated: false)
        }
    }
    // MARK: - Actions
    @IBAction func clickONBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func liveButtonTap(_ sender: Any) {
        currentFilter = .live
        updateButtonStates(selected: .live)
        
        // Show loading indicator
        ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.applyFilter()
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func upcomingButtonAction(_ sender: Any) {
        currentFilter = .scheduled
        updateButtonStates(selected: .scheduled)
        
        // Show loading indicator
        ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.applyFilter()
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func completedButtonAction(_ sender: Any) {
        currentFilter = .completed
        updateButtonStates(selected: .completed)
        
        // Show loading indicator
        ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.applyFilter()
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func todayButtonTap(_ sender: UIButton) {
        setToday()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension FootballVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            return dates.count
        } else {
            return matchesFiltered.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
            let date = dates[indexPath.item]
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            
            let isSelected = (indexPath.item == selectedDateIndex)
            cell.configure(isSelected: isSelected, dayName: dayFormatter.string(from: date).uppercased(), date: dateFormatter.string(from: date))
            
            // Set click listener for date cell
            cell.dateSelectButton.setOnClickListener { [weak self] in
                self?.handleDateSelection(at: indexPath.item)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchListCell", for: indexPath) as! MatchListCell
            let match = matchesFiltered[indexPath.item]
            
            cell.dateView.layer.borderColor = #colorLiteral(red: 0.5137838125, green: 0.6742060781, blue: 0.8591089845, alpha: 1)
            
            // Configure cell based on current filter and date
            if calendar.isDateInToday(selectedDate) {
                switch currentFilter {
                case .live:
                    cell.configureForLive(match: match)
                case .scheduled:
                    cell.configureForUpcoming(match: match)
                case .completed:
                    cell.configureForCompleted(match: match)
                }
            } else {
                // For non-today dates, show as completed or upcoming based on date
                if selectedDate < Date() {
                    cell.configureForCompleted(match: match)
                } else {
                    cell.configureForUpcoming(match: match)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != dateCollectionView {
            showInterAd()
            // Handle match selection
            let match = matchesFiltered[indexPath.item]
            
            // Navigate to ScoreDetailsVC
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
            vc.m_idMain = match.matchId
            vc.l_idMain = match.tournamentId
            vc.m_name = match.leagueName
            vc.Aname = match.homeName
            vc.Bname = match.awayName
            vc.Aimg = match.homeLogo
            vc.Bimg = match.awayLogo
            
            // Set based on match status
            if match.isInProgress {
                vc.isLiveMatch = true
            } else if match.isFinished {
                vc.isCompletedMatch = true
            } else {
                vc.isUpcomingMatch = true
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: 34, height: 48)
        } else {
            let height: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 180 : 160
            let width = collectionView.frame.width - 24
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dateCollectionView {
            return 8
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == dateCollectionView {
            let totalCellWidth = 34 * CGFloat(dates.count)
            let totalSpacingWidth = 8 * CGFloat(dates.count - 1)
            let totalWidth = totalCellWidth + totalSpacingWidth
            let horizontalInset = (collectionView.frame.width - totalWidth) / 2
            
            if horizontalInset > 0 {
                return UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
            } else {
                return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        } else {
            return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }
    }
}
