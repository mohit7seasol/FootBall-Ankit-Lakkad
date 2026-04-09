//
//  DomesticVC.swift
//  Football
//
//  Created by Ronik Hirpara on 05/02/25.
//

import UIKit

class DomesticVC: UIViewController {

    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var liveMatchCollectionView: UICollectionView! {
        didSet {
            self.liveMatchCollectionView.register(UINib(nibName: "LiveMatchesCell", bundle: nil), forCellWithReuseIdentifier: "LiveMatchesCell")
            self.liveMatchCollectionView.showsVerticalScrollIndicator = false
            self.liveMatchCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var liveEmptyView: UIView!
    @IBOutlet weak var liveEmptyLbl: UILabel!
    
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var upcomingMatchCollectionView: UICollectionView! {
        didSet {
            self.upcomingMatchCollectionView.register(UINib(nibName: "UpcomingMatchesCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingMatchesCell")
            self.upcomingMatchCollectionView.showsVerticalScrollIndicator = false
            self.upcomingMatchCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var upcomingEmptyView: UIView!
    @IBOutlet weak var upcomingEmptyLbl: UILabel!
    
    @IBOutlet weak var finishLbl: UILabel!
    @IBOutlet weak var finishedMatchCollectionView: UICollectionView! {
        didSet {
            self.finishedMatchCollectionView.register(UINib(nibName: "FinishedMatchCell", bundle: nil), forCellWithReuseIdentifier: "FinishedMatchCell")
            self.finishedMatchCollectionView.showsVerticalScrollIndicator = false
            self.finishedMatchCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var finishedEmptyView: UIView!
    @IBOutlet weak var finishedEmptyLbl: UILabel!
    
    @IBOutlet weak var viewForNative: UIView!
    
    var googleNativeAds = GoogleNativeAds()
    
    var index = -1
    var matcheslive: [MatchLiveAll] = []
    var matchesUpcoming: [MatchUpcomingAll] = []
    var matches: [MatchResultAll] = []
    var isAscending: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoader()
        showAd()
        self.fetchLiveMatchesDom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liveLbl.text = "Live Matches".localized()
        self.upcomingLbl.text = "Upcoming Matches".localized()
        self.finishLbl.text = "Finished Matches".localized()
        self.liveEmptyLbl.text  = "No Data Found".localized()
        self.upcomingEmptyLbl.text  = "No Data Found".localized()
        self.finishedEmptyLbl.text  = "No Data Found".localized()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeLoader()
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
                self.liveMatchCollectionView.reloadData()
                self.upcomingMatchCollectionView.reloadData()
                self.finishedMatchCollectionView.reloadData()
            })
        }
    }
    
    func fetchLiveMatchesDom() {
        let url = URL(string: LiveMatchAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = ["spt_typ": 2]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            self.parseJSONLiveDom(data: data)
        }
        task.resume()
    }
    
    func parseJSONLiveDom(data: Data) {
        
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let status = json["status"] as? Bool, status else {
                    removeLoader()
                    print("Status is not true")
                    return
                }
                
                if let result = json["result"] as? [[String: Any]] {
                    for categoryData in result {
                        if let category = categoryData["category"] as? String, category == "Domestic" {
                            if let leaguesData = categoryData["data"] as? [[String: Any]] {
                                for leagueData in leaguesData {
                                    let l_id = leagueData["l_id"] as? String ?? ""
                                    if let matchesData = leagueData["matches"] as? [[String: Any]] {
                                        for matchData in matchesData {
                                            if let m_name = matchData["m_name"] as? String,
                                               let t1_sname = matchData["t1_sname"] as? String,
                                               let t2_sname = matchData["t2_sname"] as? String,
                                               let t1_flag = matchData["t1_flag"] as? String,
                                               let t2_flag = matchData["t2_flag"] as? String,
                                               let strt_time_ts = matchData["strt_time_ts"] as? Int,
                                               let m_id = matchData["m_id"] as? String{
                                                let match = MatchLiveAll(m_name: m_name, t1_sname: t1_sname, t2_sname: t2_sname, t1_flag: t1_flag, t2_flag: t2_flag, strt_time_ts: strt_time_ts, m_id: m_id, l_id: l_id)
                                                self.matcheslive.append(match)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.sortMatchesLive()
                    }
                }
            }
            
        } catch let parsingError {
            print("Parsing Error: \(parsingError)")
        }
        DispatchQueue.main.async {
            self.fetchUpcomigMatchesDom()
        }
    }
    
    func sortMatchesLive() {
        matcheslive.sort(by: isAscending ? (<) : (>))
        liveMatchCollectionView.reloadData()
    }
    
    func fetchUpcomigMatchesDom() {
        let url = URL(string: UpcomingMatchAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = ["spt_typ": 2]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            self.parseJSONUpcomimgDom(data: data)
        }
        task.resume()
        
    }
    
    func parseJSONUpcomimgDom(data: Data) {
        
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let status = json["status"] as? Bool, status else {
                    removeLoader()
                    print("Status is not true")
                    return
                }
                
                if let result = json["result"] as? [[String: Any]] {
                    for categoryData in result {
                        if let category = categoryData["category"] as? String, category == "Domestic" {
                            if let leaguesData = categoryData["data"] as? [[String: Any]] {
                                for leagueData in leaguesData {
                                    let l_id = leagueData["l_id"] as? String ?? ""
                                    if let matchesData = leagueData["matches"] as? [[String: Any]] {
                                        for matchData in matchesData {
                                            if let m_name = matchData["m_name"] as? String,
                                               let t1_sname = matchData["t1_sname"] as? String,
                                               let t2_sname = matchData["t2_sname"] as? String,
                                               let t1_flag = matchData["t1_flag"] as? String,
                                               let t2_flag = matchData["t2_flag"] as? String,
                                               let strt_time_ts = matchData["strt_time_ts"] as? Int,
                                               let m_id = matchData["m_id"] as? String{
                                                let match = MatchUpcomingAll(m_name: m_name, t1_sname: t1_sname, t2_sname: t2_sname, t1_flag: t1_flag, t2_flag: t2_flag, strt_time_ts: strt_time_ts, m_id: m_id, l_id: l_id)
                                                self.matchesUpcoming.append(match)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.sortMatchesUpcoming()
                    }
                }
            }
            
        } catch let parsingError {
            print("Parsing Error: \(parsingError)")
        }
        
        DispatchQueue.main.async { [self] in
            self.fetchCompletedMatchesDom()
        }
    }
    
    func sortMatchesUpcoming() {
        matchesUpcoming.sort(by: isAscending ? (<) : (>))
        upcomingMatchCollectionView.reloadData()
    }
    
    func fetchCompletedMatchesDom() {
        let url = URL(string: ResultMatchAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = ["spt_typ": 2]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            self.parseJSONDom(data: data)
        }
        task.resume()
    }
    
    func parseJSONDom(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let status = json["status"] as? Bool, status else {
                    removeLoader()
                    print("Status is not true")
                    return
                }
                
                if let result = json["result"] as? [[String: Any]] {
                    for categoryData in result {
                        if let category = categoryData["category"] as? String, category == "Domestic" {
                            if let leaguesData = categoryData["data"] as? [[String: Any]] {
                                for leagueData in leaguesData {
                                    let l_id = leagueData["l_id"] as? String ?? ""
                                    if let matchesData = leagueData["matches"] as? [[String: Any]] {
                                        for matchData in matchesData {
                                            if let m_name = matchData["m_name"] as? String,
                                               let result_str = matchData["result_str"] as? String,
                                               let t1_sname = matchData["t1_sname"] as? String,
                                               let t2_sname = matchData["t2_sname"] as? String,
                                               let t1_flag = matchData["t1_flag"] as? String,
                                               let t2_flag = matchData["t2_flag"] as? String,
                                               let t1_goal = matchData["t1_goal"] as? Int,
                                               let t2_goal = matchData["t2_goal"] as? Int,
                                               let strt_time_ts = matchData["strt_time_ts"] as? Int,
                                               let gameState = matchData["gameState"] as? String,
                                               let time = matchData["time"] as? String,
                                               let m_id = matchData["m_id"] as? String{
                                                let match = MatchResultAll(m_name: m_name, result_str: result_str, t1_sname: t1_sname, t2_sname: t2_sname, t1_flag: t1_flag, t2_flag: t2_flag, t1_goal: t1_goal, t2_goal: t2_goal, strt_time_ts: strt_time_ts, gameState: gameState, time: time, m_id: m_id, l_id: l_id)
                                                self.matches.append(match)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.sortMatches()
                    }
                }
            }
            
        } catch let parsingError {
            print("Parsing Error: \(parsingError)")
        }
        
    }
    
    func sortMatches() {
        self.matches.sort(by: self.isAscending ? (<) : (>))
        DispatchQueue.main.async {
            removeLoader()
            self.finishedMatchCollectionView.reloadData()
        }
        
    }
    
}

extension DomesticVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.liveMatchCollectionView:
            if matcheslive.isEmpty == true {
                self.liveMatchCollectionView.isHidden = true
                self.liveEmptyView.isHidden = false
            } else {
                self.liveMatchCollectionView.isHidden = false
                self.liveEmptyView.isHidden = true
            }
            return self.matcheslive.count
        case self.upcomingMatchCollectionView:
            if matchesUpcoming.isEmpty == true {
               self.upcomingMatchCollectionView.isHidden = true
               self.upcomingEmptyView.isHidden = false
           } else {
               self.upcomingMatchCollectionView.isHidden = false
               self.upcomingEmptyView.isHidden = true
           }
            return self.matchesUpcoming.count
        case self.finishedMatchCollectionView:
            if matches.isEmpty == true {
               self.finishedMatchCollectionView.isHidden = true
               self.finishedEmptyView.isHidden = false
           } else {
               self.finishedMatchCollectionView.isHidden = false
               self.finishedEmptyView.isHidden = true
           }
            return self.matches.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.liveMatchCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveMatchesCell", for: indexPath) as! LiveMatchesCell
            
            let temp = self.matcheslive[indexPath.row]
            cell.matchNameLbl.text = temp.m_name
            cell.match1Lbl.text = temp.t1_sname
            cell.match2Lbl.text = temp.t2_sname
            cell.liveView.isHidden = false
            
            if temp.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: temp.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            if temp.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: temp.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            return cell
            
        case self.upcomingMatchCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingMatchesCell", for: indexPath) as! UpcomingMatchesCell
            
            let temp = self.matchesUpcoming[indexPath.row]
            cell.matchNameLbl.text = temp.m_name
            cell.match1Lbl.text = temp.t1_sname
            cell.match2Lbl.text = temp.t2_sname
            
            if temp.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: temp.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            if temp.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: temp.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            let result = convertTimestamp(temp.strt_time_ts)
            cell.dateLbl.text = result.formattedDate
            cell.timeLbl.text = result.formattedTime
            
            return cell
            
        case self.finishedMatchCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FinishedMatchCell", for: indexPath) as! FinishedMatchCell
            
            let temp = self.matches[indexPath.row]
            cell.matchNameLbl.text = temp.m_name
            cell.match1Lbl.text = temp.t1_sname
            cell.match2Lbl.text = temp.t2_sname
            cell.resultLbl.isHidden = false
            cell.resultLbl.text = temp.result_str
            cell.scoreLbl.isHidden = false
            
            cell.scoreLbl.text = "\(temp.t1_goal) - \(temp.t2_goal)"
            cell.completeLbl.text = "\(temp.time)'"
            
            if temp.t1_flag == "" {
                cell.match1Img.image = UIImage(named: "ic_replace")
            } else {
                let urlA = URL(string: temp.t1_flag)
                cell.match1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            if temp.t2_flag == "" {
                cell.match2Img.image = UIImage(named: "ic_replace")
            } else {
                let urlB = URL(string: temp.t2_flag)
                cell.match2Img.sd_setImage(with: urlB, placeholderImage: UIImage(named: "ic_replace"))
            }
            
            let result = convertTimestamp(temp.strt_time_ts)
            cell.dateLbl.text = "\(result.formattedDate) | \(result.formattedTime)"
            
            return cell
        default:
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            switch collectionView {
            case liveMatchCollectionView:
                isComeFromUpcoming = false
                isComeFromResult = false
                let temp = self.matcheslive[indexPath.row]
                let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
                vc.l_idMain = temp.l_id
                vc.m_idMain = temp.m_id
                vc.m_name = temp.m_name
                vc.Aimg = temp.t1_flag
                vc.Bimg = temp.t2_flag
                vc.Aname = temp.t1_sname
                vc.Bname = temp.t2_sname
                self.navigationController?.pushViewController(vc, animated: true)
                
            case upcomingMatchCollectionView:
                
                isComeFromUpcoming = true
                isComeFromResult = false
                let temp = self.matchesUpcoming[indexPath.row]
                let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
                vc.l_idMain = temp.l_id
                vc.m_idMain = temp.m_id
                vc.m_name = temp.m_name
                vc.Aimg = temp.t1_flag
                vc.Bimg = temp.t2_flag
                vc.Aname = temp.t1_sname
                vc.Bname = temp.t2_sname
                self.navigationController?.pushViewController(vc, animated: true)
                
            case finishedMatchCollectionView:
                
                isComeFromUpcoming = false
                isComeFromResult = true
                let temp = self.matches[indexPath.row]
                let vc = StoryBoard.instantiateViewController(withIdentifier: "ScoreDetailsVC") as! ScoreDetailsVC
                vc.l_idMain = temp.l_id
                vc.m_idMain = temp.m_id
                vc.m_name = temp.m_name
                vc.Aimg = temp.t1_flag
                vc.Bimg = temp.t2_flag
                vc.Aname = temp.t1_sname
                vc.Bname = temp.t2_sname
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case liveMatchCollectionView:
            return CGSize(width: (self.liveMatchCollectionView.frame.size.width) / 2, height: 200)
            
        case upcomingMatchCollectionView:
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: (self.upcomingMatchCollectionView.frame.size.width - 10) / 2, height: 200)
            } else {
                return CGSize(width: (self.upcomingMatchCollectionView.frame.size.width - 10), height: 200)
            }
        case finishedMatchCollectionView:
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: (self.finishedMatchCollectionView.frame.size.width - 10) / 2, height: 230)
            } else {
                return CGSize(width: (self.finishedMatchCollectionView.frame.size.width - 10), height: 230)
            }
        default:
            return CGSize(width: (collectionView.frame.size.width) / 2, height: 200)
        }
    }
    
}

extension DomesticVC {
    
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
