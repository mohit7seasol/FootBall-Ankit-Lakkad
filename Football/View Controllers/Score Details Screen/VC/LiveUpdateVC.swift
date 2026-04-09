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
    var m_id:String?
    var l_id:String?
    var commentaryArr: [Commentary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchData() {
        let url = URL(string: MatchLiveUpdateAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["m_id": m_id!, "min": 0, "refid": 0]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let result = json?["result"] as? [String: Any],
                   let dataArray = result["data"] as? [[String: Any]] {
                    self.commentaryArr = dataArray.map { Commentary(dictionary: $0) }
                    DispatchQueue.main.async {
                        if self.commentaryArr.isEmpty == true {
                            self.tblView.isHidden = true
                            self.noDataView.isHidden = false
                        } else {
                            self.tblView.isHidden = false
                            self.noDataView.isHidden = true
                        }
                        self.tblView.reloadData()
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}

extension LiveUpdateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentaryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = self.commentaryArr[indexPath.row]
        
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
        let temp = self.commentaryArr[indexPath.row]
        
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
