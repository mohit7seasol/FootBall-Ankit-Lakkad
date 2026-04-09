//
//  InternationalSeriesVC.swift
//  Football
//
//  Created by Ronik Hirpara on 14/02/25.
//

import UIKit

class InternationalSeriesVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "DomesticSeriesCell", bundle: nil), forCellReuseIdentifier: "DomesticSeriesCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    
    var index = -1
    var matchesData: [MatchesDataSeries] = []
    var sortedDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoader()
        fetchCompletedMatches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noDataLbl.text = "No Data Available".localized()
    }

    func fetchCompletedMatches() {
        let url = URL(string: SeriesMatchAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "spt_typ": 2,
            "category": "International",
            "limit": 30,
            "filter_date": "",
            "l_id": "",
            "team_id": ""
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            self.parseJSON(data: data)
        }
        task.resume()
    }
    
    func parseJSON(data: Data) {
        do {
            let apiResponse = try JSONDecoder().decode(APIResponseSeries.self, from: data)
            guard apiResponse.status else {
                removeLoader()
                print("Status is not true")
                return
                
            }
            self.matchesData = apiResponse.result.matchesData
            DispatchQueue.main.async {
                removeLoader()
                self.tblView.reloadData()
            }
        } catch {
            removeLoader()
            print("Parsing Error: \(error)")
        }
    }
    
    func formatDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }

    

}

extension InternationalSeriesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.matchesData.count < 1 {
            self.tblView.isHidden = true
            self.emptyView.isHidden = false
        } else {
            self.tblView.isHidden = false
            self.emptyView.isHidden = true
        }
        return self.matchesData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchesData[section].leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "DomesticSeriesCell", for: indexPath) as! DomesticSeriesCell
        
        let league = self.matchesData[indexPath.section].leagues[indexPath.row]
        let dates = self.matchesData[indexPath.section].date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dates) else {
            fatalError("Invalid date format")
        }
        dateFormatter.dateFormat = "EEEE, dd MMM"
        let formattedDateString = dateFormatter.string(from: date)
        cell.dateLbl.text = formattedDateString
        
        cell.nameLbl.text = league.l_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showInterAd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let league = self.matchesData[indexPath.section].leagues[indexPath.row]
            let vc = StoryBoard.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
            //vc.navigationItem.title = league.l_name
            vc.name = league.l_name
            vc.isComeFromSeries = true
            vc.league = league
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
}
