//
//  ScoreDetailsVC.swift
//  Football
//
//  Created by Ronik Hirpara on 05/02/25.
//

import UIKit
import MarqueeLabel
import ProgressHUD

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
    
    // MARK: - Match Status Properties (Add these)
    var isLiveMatch: Bool = false
    var isUpcomingMatch: Bool = false
    var isCompletedMatch: Bool = false
    
    // MARK: - New Data Properties for API
    var matchDetails: MatchDetails?
    var matchStats: [MatchStatModel] = []
    var eventsUpdates: [MatchSummaryEvent] = []
    var standings: [Standing] = []
    var h2hMatches: [H2HMatch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.MatchDetails)
        self.showAd()
        
        // Fetch data using new APIs
        ProgressHUD.show()
        fetchAllMatchData()
        
        self.team1Img.layer.cornerRadius = self.team1Img.frame.height/2
        self.team2Img.layer.cornerRadius = self.team2Img.frame.height/2
        
        if isComeFromUpcoming == true {
            self.titleArr = ["Squad","Info","Point Table"]
        } else {
            self.titleArr = ["Live Update","Overview","Lineups","Stats","Head2Head","Info","Point Table"]
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
            pagerVc?.Aimg = self.Aimg
            pagerVc?.Bimg = self.Bimg
            pagerVc?.matchDetails = self.matchDetails
            pagerVc?.stats = self.matchStats
            pagerVc?.eventsUpdates = self.eventsUpdates
            pagerVc?.standings = self.standings
            pagerVc?.h2hMatches = self.h2hMatches
            pagerVc?.tabDelegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Fetch All Match Data
    func fetchAllMatchData() {
        let dispatchGroup = DispatchGroup()
        
        // 1. Fetch Match Details (Info)
        dispatchGroup.enter()
        fetchMatchDetails { [weak self] success in
            if success {
                print("Match Details fetched successfully")
            }
            dispatchGroup.leave()
        }
        
        // 2. Fetch Match Stats
        dispatchGroup.enter()
        fetchMatchStats { [weak self] success in
            if success {
                print("Match Stats fetched successfully")
            }
            dispatchGroup.leave()
        }
        
        // 3. Fetch Match Summary (Live Update & Overview)
        dispatchGroup.enter()
        fetchMatchSummary { [weak self] success in
            if success {
                print("Match Summary fetched successfully")
            }
            dispatchGroup.leave()
        }
        
        // 4. Fetch Standings (Point Table)
        dispatchGroup.enter()
        fetchMatchStandings { [weak self] success in
            if success {
                print("Standings fetched successfully")
            }
            dispatchGroup.leave()
        }
        
        // 5. Fetch Head2Head Matches
        dispatchGroup.enter()
        fetchHead2HeadMatches { [weak self] success in
            if success {
                print("Head2Head matches fetched successfully")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            ProgressHUD.dismiss()
            print("All data fetched")
        }
    }
    
    // MARK: - API Methods
    
    func fetchMatchDetails(completion: @escaping (Bool) -> Void) {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/details?match_id=\(m_idMain ?? "")"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue(APITOKEN, forHTTPHeaderField: "X-RapidAPI-Key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    let home = json["home_team"] as? [String: Any]
                    let away = json["away_team"] as? [String: Any]
                    let tournament = json["tournament"] as? [String: Any]
                    let scores = json["scores"] as? [String: Any]
                    let status = json["match_status"] as? [String: Any]
                    let venue = json["venue"] as? [String: Any]
                    
                    let details = MatchDetails(
                        leagueName: tournament?["name"] as? String ?? "",
                        homeName: home?["name"] as? String ?? self?.Aname ?? "",
                        homeShortName: home?["short_name"] as? String ?? "",
                        awayName: away?["name"] as? String ?? self?.Bname ?? "",
                        awayShortName: away?["short_name"] as? String ?? "",
                        homeLogo: home?["image_path"] as? String ?? self?.Aimg ?? "",
                        awayLogo: away?["image_path"] as? String ?? self?.Bimg ?? "",
                        homeScore: scores?["home"] as? Int ?? 0,
                        awayScore: scores?["away"] as? Int ?? 0,
                        status: status?["stage"] as? String ?? "",
                        liveTime: status?["live_time"] as? String ?? "",
                        referee: json["referee"] as? String ?? "",
                        venueName: venue?["name"] as? String ?? "",
                        venueCity: venue?["city"] as? String ?? "",
                        attendance: venue?["attendance"] as? String ?? "",
                        capacity: venue?["capacity"] as? String ?? "",
                        timestamp: json["timestamp"] as? Int ?? 0
                    )
                    
                    DispatchQueue.main.async {
                        self?.matchDetails = details
                        
                        // Update UI with fetched data
                        self?.team1Lbl.text = details.homeName
                        self?.team2Lbl.text = details.awayName
                        self?.scoreLbl.text = "\(details.homeScore) - \(details.awayScore)"
                        self?.titleNameLbl.text = details.leagueName
                        
                        if !details.liveTime.isEmpty {
                            self?.completedLbl.text = "\(details.liveTime)'"
                        } else if details.status == "Finished" {
                            self?.completedLbl.text = "Completed"
                        } else {
                            self?.completedLbl.text = details.status
                        }
                        
                        if let url = URL(string: details.homeLogo), !details.homeLogo.isEmpty {
                            self?.team1Img.sd_setImage(with: url, placeholderImage: UIImage(named: "splash"))
                        }
                        if let url = URL(string: details.awayLogo), !details.awayLogo.isEmpty {
                            self?.team2Img.sd_setImage(with: url, placeholderImage: UIImage(named: "splash"))
                        }
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print(error)
                completion(false)
            }
        }.resume()
    }
    
    func fetchMatchStats(completion: @escaping (Bool) -> Void) {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/match/stats?match_id=\(m_idMain ?? "")"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue(APITOKEN, forHTTPHeaderField: "X-RapidAPI-Key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let statsArray = json["match"] as? [[String: Any]] {
                    
                    var temp: [MatchStatModel] = []
                    for s in statsArray {
                        let stat = MatchStatModel(
                            name: s["name"] as? String ?? "",
                            home: "\(s["home_team"] ?? "")",
                            away: "\(s["away_team"] ?? "")"
                        )
                        temp.append(stat)
                    }
                    
                    DispatchQueue.main.async {
                        self?.matchStats = temp
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print(error)
                completion(false)
            }
        }.resume()
    }
    
    func fetchMatchSummary(completion: @escaping (Bool) -> Void) {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/match/summary?match_id=\(m_idMain ?? "")"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APITOKEN, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode([MatchSummaryEvent].self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventsUpdates = result
                }
                completion(!result.isEmpty)
            } catch {
                print("Decode error:", error)
                completion(false)
            }
        }.resume()
    }
    
    func fetchMatchStandings(completion: @escaping (Bool) -> Void) {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/standings?type=overall&match_id=\(m_idMain ?? "")"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APITOKEN, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode([Standing].self, from: data)
                
                DispatchQueue.main.async {
                    self?.standings = result
                }
                completion(!result.isEmpty)
            } catch {
                print("Decode error:", error)
                completion(false)
            }
        }.resume()
    }
    
    func fetchHead2HeadMatches(completion: @escaping (Bool) -> Void) {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/h2h?match_id=\(m_idMain ?? "")"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APITOKEN, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let allMatches = try JSONDecoder().decode([H2HMatch].self, from: data)
                
                let filtered = allMatches.filter {
                    let home = $0.home_team?.name?.lowercased() ?? ""
                    let away = $0.away_team?.name?.lowercased() ?? ""
                    
                    let team1 = self?.Aname?.lowercased() ?? ""
                    let team2 = self?.Bname?.lowercased() ?? ""
                    
                    return (home.contains(team1) && away.contains(team2)) ||
                           (home.contains(team2) && away.contains(team1))
                }
                
                let sorted = filtered.sorted {
                    ($0.timestamp ?? 0) > ($1.timestamp ?? 0)
                }
                
                DispatchQueue.main.async {
                    self?.h2hMatches = sorted
                }
                completion(!sorted.isEmpty)
            } catch {
                print("Decode error:", error)
                completion(false)
            }
        }.resume()
    }
    
    // MARK: - Keep your existing methods (showAd, showSkeleton, hideSkeleton, etc.)
    
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

// MARK: - UICollectionView Delegate & DataSource
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
        } else if self.titleArr[indexPath.row] == "Head2Head" {
            pagerVc?.moveToPage(index: 4, animated: true)
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
        let lblWidth = textSize(font: UIFont.systemFont(ofSize: 16, weight: .regular), text: self.titleArr[indexPath.row])
        return CGSize(width: lblWidth+10, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = CGFloat(self.titleArr.count)

        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
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

        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return CGSize(width: 0, height: 0)
    }
}

// MARK: - ScoreDelegate
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
