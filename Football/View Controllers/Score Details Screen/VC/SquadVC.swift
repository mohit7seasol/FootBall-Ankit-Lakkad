//
//  SquadVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class SquadVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.register(UINib(nibName: "SquadCell", bundle: nil), forCellReuseIdentifier: "SquadCell")
            self.tblView.register(UINib(nibName: "SquadTeamCell", bundle: nil), forCellReuseIdentifier: "SquadTeamCell")
            self.tblView.showsVerticalScrollIndicator = false
            self.tblView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    
    var m_id:String?
    var l_id:String?
    var index = -1
    var Aname:String?
    var Bname:String?
    var squad1: [Squad] = []
    var filteredArray1: [Squad] = []
    var filteredArray2: [Squad] = []
    var squad2: [Squad] = []
    var TeamA:Bool = false
    var TeamB:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchSquads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchSquads() {
        let url = URL(string: MatchSquadAPI)!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           let parameters = ["spt_typ": 2, "l_id": l_id!, "m_id": m_id!] as [String : Any]
           request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

           URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else { return }

               do {
                   let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                   if let dictionary = jsonResponse as? [String: Any],
                      let result = dictionary["result"] as? [String: Any] {
                       if let t1Squad = result["t1_squad"] as? [[String: Any]] {
                           self.squad1 = t1Squad.compactMap { playerDict in
                               if let name = playerDict["name"] as? String,
                                  let role = playerDict["role"] as? String,
                                  let imageURL = playerDict["image"] as? String {
                                   return Squad(imageURL: imageURL, role: role, name: name)
                               }
                               return nil
                           }
                       }
                       if let t2Squad = result["t2_squad"] as? [[String: Any]] {
                           self.squad2 = t2Squad.compactMap { playerDict in
                               if let name = playerDict["name"] as? String,
                                  let role = playerDict["role"] as? String,
                                  let imageURL = playerDict["image"] as? String {
                                   return Squad(imageURL: imageURL, role: role, name: name)
                               }
                               return nil
                           }
                       }
                   }
                   DispatchQueue.main.async {
                       let indices1 = [1, 2, 3]
                       self.filteredArray1 = indices1.compactMap { index in
                           self.squad1.indices.contains(index) ? self.squad1[index] : nil
                       }
                       
                       let indices2 = [5,6,7]
                       self.filteredArray2 = indices2.compactMap { index in
                           self.squad2.indices.contains(index) ? self.squad2[index] : nil
                       }
                       if self.filteredArray1.isEmpty == true || self.filteredArray2.isEmpty == true {
                           self.tblView.isHidden = true
                           self.noDataView.isHidden = false
                       } else {
                           self.tblView.isHidden = false
                           self.noDataView.isHidden = true
                       }
                       self.tblView.reloadData()
                   }
               } catch {
                   print("Failed to parse JSON")
               }
           }.resume()
       }
        
}

extension SquadVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if self.teamSeg.selectedSegmentIndex == 0 {
            return squad1.count
        } else if self.teamSeg.selectedSegmentIndex == 1 {
            return squad2.count
        } else {*/
        if self.filteredArray1.isEmpty == false || self.filteredArray2.isEmpty == false {
            return self.filteredArray1.count + 5
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 4 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "SquadTeamCell", for: indexPath) as! SquadTeamCell
            
            if indexPath.row == 0 {
                if self.Aname?.isEmpty == false {
                    cell.teamNameLbl.text = self.Aname
                } else {
                    cell.teamNameLbl.text = "TeamA"
                }
            } else if indexPath.row == 4 {
                if self.Bname?.isEmpty == false {
                    cell.teamNameLbl.text = self.Bname
                } else {
                    cell.teamNameLbl.text = "TeamB"
                }
            }
            
            return cell
            
        } else if indexPath.row > 0 && indexPath.row - 1 < self.filteredArray1.count {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "SquadCell", for: indexPath) as! SquadCell
            
            let temp = self.filteredArray1[indexPath.row - 1]
            cell.nameLbl.text = temp.name
            cell.positionLbl.text = temp.role
            cell.squadLbl.text = "Playing Squad"
            cell.squadLbl.textColor = UIColor(red: 0.22, green: 0.69, blue: 0.03, alpha: 1.00)
            
            if isComeFromResult == true {
                cell.squadLbl.isHidden = false
            } else {
                cell.squadLbl.isHidden = true
            }
            
            if indexPath.row == 1 {
                cell.mainView.layer.cornerRadius = 8
                cell.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            if indexPath.row == 3 {
                cell.mainView.layer.cornerRadius = 8
                cell.mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.sepView.isHidden = true
            }
            
            return cell
            
        } else if indexPath.row >= 5 && indexPath.row - 5 < self.filteredArray2.count {
            // Players at index paths 5, 6, 7
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "SquadCell", for: indexPath) as! SquadCell
            
            let temp = self.filteredArray2[indexPath.row - 5] // Adjust index for `filteredArray1`
            cell.nameLbl.text = temp.name
            cell.positionLbl.text = temp.role
            cell.squadLbl.text = "Bench"
            cell.squadLbl.textColor = UIColor(red: 0.92, green: 0.35, blue: 0.24, alpha: 1.00)
            if isComeFromResult == true {
                cell.squadLbl.isHidden = false
            } else {
                cell.squadLbl.isHidden = true
            }
            
            if indexPath.row == 5 {
                cell.mainView.layer.cornerRadius = 8
                cell.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            if indexPath.row == 7 {
                cell.mainView.layer.cornerRadius = 8
                cell.mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.sepView.isHidden = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = StoryBoard.instantiateViewController(withIdentifier: "SquadDetailsVC") as! SquadDetailsVC
            vc.filteredArray = self.squad1
            vc.name = self.Aname
            vc.squadNAme = "Playing Squad"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = StoryBoard.instantiateViewController(withIdentifier: "SquadDetailsVC") as! SquadDetailsVC
            vc.filteredArray = self.squad2
            vc.name = self.Bname
            vc.squadNAme = "Bench"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
