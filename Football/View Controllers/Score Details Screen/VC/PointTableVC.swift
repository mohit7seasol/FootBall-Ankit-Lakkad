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
    var teams: [Team] = []
    var l_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.layer.cornerRadius = 8
        self.fetchTeamStandings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchTeamStandings() {
        guard let url = URL(string: MatchPointTableAPI) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "spt_typ": 2,
            "l_id": l_id!,
            "is_latest": true
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TeamStandingsResponse.self, from: data)
                guard response.status, let result = response.result, let standings = result.team_standings, !standings.isEmpty else {
                    print("No data available")
                    return
                }
                
                self.teams = standings.flatMap { $0.standings }
                
                DispatchQueue.main.async {
                    if self.teams.isEmpty == true {
                        self.tblView.isHidden = true
                        self.topView.isHidden = true
                        self.noDataView.isHidden = false
                    } else {
                        self.tblView.isHidden = false
                        self.topView.isHidden = false
                        self.noDataView.isHidden = true
                    }
                    self.tblView.reloadData()
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        
        task.resume()
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
