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
    var m_id:String?
    var l_id:String?
    var matchStatsArr: [MatchStat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.layer.cornerRadius = 8
        self.fetchMatchStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchMatchStats() {
        let url = URL(string: MatchStatsAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["m_id": m_id!]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data")
                return
            }
            
            do {
                let matchStatsResponse = try JSONDecoder().decode(MatchStatsResponse.self, from: data)
                
                if let matchStats = matchStatsResponse.result?.matchStats, !matchStats.isEmpty {
                    self.matchStatsArr = matchStats
                    DispatchQueue.main.async {
                        if self.matchStatsArr.isEmpty == true {
                            self.tblView.isHidden = true
                            self.statsLbl.isHidden = true
                            self.noDataView.isHidden = false
                        } else {
                            self.tblView.isHidden = false
                            self.statsLbl.isHidden = false
                            self.noDataView.isHidden = true
                        }
                        self.tblView.reloadData()
                    }
                } else {
                    print("Result is empty")
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func normalizeValue(_ value: Double, minValue: Double = 0, maxValue: Double) -> Double {
        guard maxValue > minValue else { return 0 } // Avoid division by zero
        return (value - minValue) / (maxValue - minValue)
    }


}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchStatsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatCell
        
        let temp = self.matchStatsArr[indexPath.row]
        cell.actionLbl?.text = temp.type
        cell.team1Lbl.text = "\(temp.t1Stats)"
        cell.team2Lbl.text = "\(temp.t2Stats)"
        
        print("\nt1Stats --------------- \(temp.t1Stats)")
        print("\nt2Stats --------------- \(temp.t2Stats)")
        
        let bigValue1 = 100.0
        let bigValue2 = 100.0
        
        cell.team1Progress.progress = Float(self.normalizeValue(Double(temp.t1Stats), maxValue: bigValue1))
//        print("\nteam 1 ---------------", Float(self.normalizeValue(Double(temp.t1Stats), maxValue: bigValue1)), temp.t1Stats, bigValue1)
//        print("\nteam 2 ---------------", Float(self.normalizeValue(Double(temp.t2Stats), maxValue: bigValue2)), temp.t2Stats, bigValue2)
        cell.team2Progress.progress = Float(self.normalizeValue(Double(temp.t2Stats), maxValue: bigValue2))
        
        if indexPath.row == self.matchStatsArr.count - 1 {
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
