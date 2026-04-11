//
//  StatsVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class StatsVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "StatCell", bundle: nil), forCellReuseIdentifier: "StatCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var statsLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var index = -1
    var m_id: String?
    var l_id: String?
    var stats: [MatchStatModel] = []
    var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.layer.cornerRadius = 8
        self.noDataLbl.text = "No data Available".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMatchStats()
        startAutoRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.fetchMatchStats()
        }
    }
    
    // MARK: - Reference Code API
    func fetchMatchStats() {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/match/stats?match_id=\(m_id ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue(APITOKEN, forHTTPHeaderField: "X-RapidAPI-Key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            
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
                        self?.stats = temp
                        
                        if self?.stats.isEmpty == true {
                            self?.tblView.isHidden = true
                            self?.statsLbl.isHidden = true
                            self?.noDataView.isHidden = false
                        } else {
                            self?.tblView.isHidden = false
                            self?.statsLbl.isHidden = false
                            self?.noDataView.isHidden = true
                            self?.tblView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func normalizeValue(_ value: Double, minValue: Double = 0, maxValue: Double) -> Double {
        guard maxValue > minValue else { return 0 }
        return (value - minValue) / (maxValue - minValue)
    }
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatCell
        
        let temp = self.stats[indexPath.row]
//        cell.actionLbl?.text = temp.name
//        cell.team1Lbl.text = temp.home
//        cell.team2Lbl.text = temp.away
        
//        let homeValue = Float(temp.home) ?? 0
//        let awayValue = Float(temp.away) ?? 0
//        let total = homeValue + awayValue
        
//        if total > 0 {
//            cell.team1Progress.progress = homeValue / total
//            cell.team2Progress.progress = awayValue / total
//        } else {
//            cell.team1Progress.progress = 0.5
//            cell.team2Progress.progress = 0.5
//        }
        
        if indexPath.row == self.stats.count - 1 {
            cell.mainView.layer.cornerRadius = 8
            cell.mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.sepView.isHidden = true
        } else {
            cell.sepView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
