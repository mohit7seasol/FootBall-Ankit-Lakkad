//
//  InfoVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var topView: View!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var index = -1
    var m_id: String?
    var l_id: String?
    var matchDetails: MatchDetails?
    var titleArr: [String] = []
    var infoArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.layer.cornerRadius = 8
        self.noDataLbl.text = "No data Available".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let details = matchDetails {
            updateUI(with: details)
        } else {
            fetchMatchDetails()
        }
    }
    
    func updateUI(with details: MatchDetails) {
        titleArr = ["Match", "Series", "Date", "Time", "Venue"]
        
        let result = convertTimestamp(details.timestamp)
        infoArr = [details.leagueName, details.homeName, result.formattedDate, result.formattedTime, "\(details.venueName), \(details.venueCity)"]
        
        DispatchQueue.main.async {
            if self.infoArr.isEmpty {
                self.tblView.isHidden = true
                self.topView.isHidden = true
                self.noDataView.isHidden = false
            } else {
                self.tblView.isHidden = false
                self.topView.isHidden = false
                self.noDataView.isHidden = true
                self.tblView.reloadData()
            }
        }
    }
    
    // MARK: - Reference Code API
    func fetchMatchDetails() {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/details?match_id=\(m_id ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue(APITOKEN, forHTTPHeaderField: "X-RapidAPI-Key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let tournament = json["tournament"] as? [String: Any]
                    let venue = json["venue"] as? [String: Any]
                    let timestamp = json["timestamp"] as? Int ?? 0
                    
                    let leagueName = tournament?["name"] as? String ?? ""
                    let venueName = venue?["name"] as? String ?? ""
                    let cityName = venue?["city"] as? String ?? ""
                    
                    let details = MatchDetails(
                        leagueName: leagueName,
                        homeName: "",
                        homeShortName: "",
                        awayName: "",
                        awayShortName: "",
                        homeLogo: "",
                        awayLogo: "",
                        homeScore: 0,
                        awayScore: 0,
                        status: "",
                        liveTime: "",
                        referee: "",
                        venueName: venueName,
                        venueCity: cityName,
                        attendance: "",
                        capacity: "",
                        timestamp: timestamp
                    )
                    
                    DispatchQueue.main.async {
                        self?.updateUI(with: details)
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func convertTimestamp(_ timestamp: Int) -> (formattedDate: String, formattedTime: String) {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM"
        let formattedDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        let formattedTime = dateFormatter.string(from: date)
        return (formattedDate, formattedTime)
    }
}

extension InfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        
        cell.titleLbl.text = self.titleArr[indexPath.row]
        cell.infoLbl.text = self.infoArr[indexPath.row]
        
        if indexPath.row == 1 {
            cell.infoLbl.textColor = UIColor(red: 0.13, green: 0.38, blue: 1.00, alpha: 1.00)
        } else {
            cell.infoLbl.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.00)
        }
        
        if indexPath.row == self.infoArr.count - 1 {
            cell.mainView.layer.cornerRadius = 8
            cell.mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.sepView.isHidden = true
        } else {
            cell.sepView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
