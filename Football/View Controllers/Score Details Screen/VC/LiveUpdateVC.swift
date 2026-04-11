//
//  LiveUpdateVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class LiveUpdateVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "SingleLiveUpdateCell", bundle: nil), forCellReuseIdentifier: "SingleLiveUpdateCell")
            self.tblView.register(UINib(nibName: "PlayerLiveUpdateCell", bundle: nil), forCellReuseIdentifier: "PlayerLiveUpdateCell")
            self.tblView.register(UINib(nibName: "ScoreLiveUpdateCell", bundle: nil), forCellReuseIdentifier: "ScoreLiveUpdateCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var index = -1
    var m_id: String?
    var l_id: String?
    var eventsUpdates: [MatchSummaryEvent] = []
    var commentaryData: [Commentary] = []
    var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDataLbl.text = "No data Available".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !eventsUpdates.isEmpty {
            updateUIWithEvents()
        } else {
            fetchMatchSummary()
        }
        startAutoRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func updateUIWithEvents() {
        commentaryData.removeAll()
        
        for event in eventsUpdates {
            let minutes = event.minutes ?? ""
            let description = event.description ?? ""
            let players = event.players ?? []
            
            let playerName = players.first?.name ?? ""
            let eventType = players.first?.type ?? ""
            
            var cardType = ""
            if eventType.contains("Yellow") {
                cardType = "Yellow card"
            } else if eventType.contains("Red") {
                cardType = "Red card"
            }
            
            let commentary = Commentary(
                time: minutes,
                text: description,
                player1Name: playerName,
                cardType: cardType,
                teamName: event.team ?? ""
            )
            commentaryData.append(commentary)
        }
        
        DispatchQueue.main.async {
            if self.commentaryData.isEmpty {
                self.tblView.isHidden = true
                self.noDataView.isHidden = false
            } else {
                self.tblView.isHidden = false
                self.noDataView.isHidden = true
                self.tblView.reloadData()
            }
        }
    }
    
    func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.fetchMatchSummary()
        }
    }
    
    // MARK: - Reference Code API
    func fetchMatchSummary() {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/match/summary?match_id=\(m_id ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APITOKEN, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("API Error:", error?.localizedDescription ?? "")
                return
            }
            
            do {
                let result = try JSONDecoder().decode([MatchSummaryEvent].self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventsUpdates = result
                    self?.updateUIWithEvents()
                }
            } catch {
                print("Decode error:", error)
            }
        }.resume()
    }
}

extension LiveUpdateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentaryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = self.commentaryData[indexPath.row]
        
        if temp.time == "0'" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLiveUpdateCell", for: indexPath) as? SingleLiveUpdateCell else {
                return UITableViewCell()
            }
            cell.scoreLbl.text = temp.text
            return cell
        } else {
            if temp.player1Name == "" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreLiveUpdateCell", for: indexPath) as? ScoreLiveUpdateCell else {
                    return UITableViewCell()
                }
                cell.timeLbl.text = " \(temp.time) "
                cell.scoreLbl.text = temp.text
                cell.cardTypeLbl.text = temp.cardType
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerLiveUpdateCell", for: indexPath) as? PlayerLiveUpdateCell else {
                    return UITableViewCell()
                }
                cell.timeLbl.text = " \(temp.time) "
                cell.scoreLbl.text = temp.text
                cell.cardTypeLbl.text = temp.cardType
                cell.playerNameLbl.text = temp.player1Name
                cell.countryLbl.text = temp.teamName
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let temp = self.commentaryData[indexPath.row]
        
        if temp.time == "0'" {
            return 40
        } else {
            if temp.player1Name == "" {
                return 85
            } else {
                return 100
            }
        }
    }
}
