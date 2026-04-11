//
//  OverViewVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

// MARK: - Converted Event Model for UI
struct ConvertedEvent {
    let time: String
    let t_id: Int  // 1 for home, 2 for away
    let playerInName: String
    let playerOutName: String
    let text: String
    let card: String
    let eventType: String
}

class OverViewVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "TeamAOverViewCell", bundle: nil), forCellReuseIdentifier: "TeamAOverViewCell")
            self.tblView.register(UINib(nibName: "TeamBOverViewCell", bundle: nil), forCellReuseIdentifier: "TeamBOverViewCell")
            self.tblView.register(UINib(nibName: "TeamCOverViewCell", bundle: nil), forCellReuseIdentifier: "TeamCOverViewCell")
            self.tblView.register(UINib(nibName: "TeamDOverViewCell", bundle: nil), forCellReuseIdentifier: "TeamDOverViewCell")
            self.tblView.register(UINib(nibName: "TeamEOverViewCell", bundle: nil), forCellReuseIdentifier: "TeamEOverViewCell")
            self.tblView.register(UINib(nibName: "TeamFOverViewCell", bundle: nil), forCellReuseIdentifier: "TeamFOverViewCell")
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
    var convertedEvents: [ConvertedEvent] = []
    var t_1ID: Int = 1
    var t_2ID: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.layer.cornerRadius = 8
        self.noDataLbl.text = "No data Available".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMatchSummary()
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
                    self?.convertEventsToUIModel()
                    self?.tblView.reloadData()
                    
                    if self?.convertedEvents.isEmpty == true {
                        self?.tblView.isHidden = true
                        self?.noDataView.isHidden = false
                    } else {
                        self?.tblView.isHidden = false
                        self?.noDataView.isHidden = true
                    }
                }
            } catch {
                print("Decode error:", error)
            }
        }.resume()
    }
    
    func convertEventsToUIModel() {
        convertedEvents.removeAll()
        
        for event in eventsUpdates {
            let isHome = event.team?.lowercased() == "home"
            let teamId = isHome ? t_1ID : t_2ID
            
            let minute = event.minutes ?? ""
            let players = event.players ?? []
            
            let subIn = players.first(where: { $0.type?.contains("In") == true })
            let subOut = players.first(where: { $0.type?.contains("Out") == true })
            let eventType = players.first?.type ?? ""
            
            let fallbackPlayer = players.first?.name ?? ""
            let fallbackType = players.first?.type ?? ""
            let text = (event.description?.isEmpty == false) ? event.description! : (!fallbackPlayer.isEmpty ? fallbackPlayer : fallbackType)
            
            var cardType = ""
            if eventType.contains("Yellow") {
                cardType = "Yellow card"
            } else if eventType.contains("Red") {
                cardType = "Red card"
            } else if eventType.contains("Goal") || eventType.contains("Penalty") {
                cardType = "Goal"
            }
            
            let convertedEvent = ConvertedEvent(
                time: minute,
                t_id: teamId,
                playerInName: subIn?.name ?? "",
                playerOutName: subOut?.name ?? "",
                text: text,
                card: cardType,
                eventType: eventType
            )
            convertedEvents.append(convertedEvent)
        }
    }
}

extension OverViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.convertedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = self.convertedEvents[indexPath.row]
        
        if self.t_1ID == temp.t_id {
            if !temp.playerInName.isEmpty && !temp.playerOutName.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamAOverViewCell", for: indexPath) as? TeamAOverViewCell else {
                    return UITableViewCell()
                }
                cell.timeLbl.text = " \(temp.time)' "
                cell.inPlayerLbl.text = temp.playerInName
                cell.outPlayerLbl.text = temp.playerOutName
                return cell
            } else {
                if temp.card == "Goal" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCOverViewCell", for: indexPath) as? TeamCOverViewCell else {
                        return UITableViewCell()
                    }
                    cell.timeLbl.text = " \(temp.time)' "
                    cell.textLbl.text = temp.text
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamBOverViewCell", for: indexPath) as? TeamBOverViewCell else {
                        return UITableViewCell()
                    }
                    cell.timeLbl.text = " \(temp.time)' "
                    cell.textLbl.text = temp.text
                    return cell
                }
            }
        } else {
            if !temp.playerInName.isEmpty && !temp.playerOutName.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDOverViewCell", for: indexPath) as? TeamDOverViewCell else {
                    return UITableViewCell()
                }
                cell.timeLbl.text = " \(temp.time)' "
                cell.inPlayerLbl.text = temp.playerInName
                cell.outPlayerLbl.text = temp.playerOutName
                return cell
            } else {
                if temp.card == "Goal" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamFOverViewCell", for: indexPath) as? TeamFOverViewCell else {
                        return UITableViewCell()
                    }
                    cell.timeLbl.text = " \(temp.time)' "
                    cell.textLbl.text = temp.text
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamEOverViewCell", for: indexPath) as? TeamEOverViewCell else {
                        return UITableViewCell()
                    }
                    cell.timeLbl.text = " \(temp.time)' "
                    cell.textLbl.text = temp.text
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let temp = self.convertedEvents[indexPath.row]
        if !temp.playerInName.isEmpty && !temp.playerOutName.isEmpty {
            return 80
        }
        return 58
    }
}
