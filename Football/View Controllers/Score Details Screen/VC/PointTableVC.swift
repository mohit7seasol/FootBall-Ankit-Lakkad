//
//  PointTableVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class PointTableVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "PointTableCell", bundle: nil), forCellReuseIdentifier: "PointTableCell")
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
    var standings: [Standing] = []
    var teams: [Team] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.layer.cornerRadius = 8
        self.noDataLbl.text = "No data Available".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !standings.isEmpty {
            updateUIWithStandings()
        } else {
            fetchMatchStandings()
        }
    }
    
    func updateUIWithStandings() {
        teams = standings.map { standing in
            Team(
                tname: standing.name ?? "",
                P: standing.matches_played ?? 0,
                W: standing.wins ?? 0,
                L: standing.losses ?? 0,
                D: standing.draws ?? 0,
                PTS: standing.points ?? 0
            )
        }
        teams.sort { $0.PTS > $1.PTS }
        
        DispatchQueue.main.async {
            if self.teams.isEmpty {
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
    func fetchMatchStandings() {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/standings?type=overall&match_id=\(m_id ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APITOKEN, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode([Standing].self, from: data)
                
                DispatchQueue.main.async {
                    self?.standings = result
                    self?.updateUIWithStandings()
                }
            } catch {
                print("Decode error:", error)
            }
        }.resume()
    }
}

extension PointTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "PointTableCell", for: indexPath) as! PointTableCell
        
        let temp = teams[indexPath.row]
        
        cell.teamLbl.text = temp.tname
        cell.mLbl.text = "\(temp.P)"
        cell.wLbl.text = "\(temp.W)"
        cell.lLbl.text = "\(temp.L)"
        cell.dLbl.text = "\(temp.D)"
        cell.ptsLbl.text = "\(temp.PTS)"
        
        if indexPath.row == self.teams.count - 1 {
            cell.mainView.layer.cornerRadius = 8
            cell.mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.sepView.isHidden = true
        } else {
            cell.sepView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
