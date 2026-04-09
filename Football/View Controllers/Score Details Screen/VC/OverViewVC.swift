//
//  OverViewVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

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
    var m_id:String?
    var l_id:String?
    var overViewArr = [EventUpdate]()
    var t_1ID:Int?
    var t_2ID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.layer.cornerRadius = 8
        self.fetchMatchOverview { [weak self] updates in
            self?.overViewArr = updates
            DispatchQueue.main.async {
                if self?.overViewArr.isEmpty == true {
                    self?.tblView.isHidden = true
                    self?.noDataView.isHidden = false
                } else {
                    self?.tblView.isHidden = false
                    self?.noDataView.isHidden = true
                }
                self?.tblView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchMatchOverview(completion: @escaping ([EventUpdate]) -> Void) {
        guard let url = URL(string: MatchOverViewAPI) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = ["m_id": m_id!]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let responseObject = try JSONDecoder().decode(MatchOverviewResponse.self, from: data)
                let eventsUpdates = responseObject.result.events_updates
                self.t_1ID = responseObject.result.t1_id
                self.t_2ID = responseObject.result.t2_id
                DispatchQueue.main.async {
                    completion(eventsUpdates)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }

}

extension OverViewVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.overViewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let temp = self.overViewArr[indexPath.row]
        
        if self.t_1ID == temp.t_id {
            
            if temp.playerInName.isEmpty == false {
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
                    //cell.img.image = UIImage(named: "ic_Goal")
                    
                    
                    return cell
                    
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamBOverViewCell", for: indexPath) as? TeamBOverViewCell else {
                        return UITableViewCell()
                    }
                    cell.timeLbl.text = " \(temp.time)' "
                    cell.textLbl.text = temp.text
                    
//                    if temp.card == "Yellow card" {
//                        cell.img.image = UIImage(named: "ic_Yellow")
//                    } else if eventUpdate.card == "Red card" {
//                        cell.img.image = UIImage(named: "ic_Red")
//                    } else if eventUpdate.card == "Green card" {
//                        cell.img.image = UIImage(named: "ic_Green")
//                    } else {
//                        
//                    }
                    
                    return cell
                }
            }

        } else {
            
            if temp.playerInName.isEmpty == false {
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
                    //cell.img.image = UIImage(named: "ic_Goal")
                    
                    return cell
                    
                } else {
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamEOverViewCell", for: indexPath) as? TeamEOverViewCell else {
                        return UITableViewCell()
                    }
                    cell.timeLbl.text = " \(temp.time)' "
                    cell.textLbl.text = temp.text
                    
//                    if eventUpdate.card == "Yellow card" {
//                        cell.img.image = UIImage(named: "ic_Yellow")
//                    } else if eventUpdate.card == "Red card" {
//                        cell.img.image = UIImage(named: "ic_Red")
//                    } else if eventUpdate.card == "Green card" {
//                        cell.img.image = UIImage(named: "ic_Green")
//                    } else {
//                        
//                    }
                    
                    return cell
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let temp = self.overViewArr[indexPath.row]
        if temp.playerInName.isEmpty == false {
            return 100
        } else {
            return 100
        }

        
    }
    
}

