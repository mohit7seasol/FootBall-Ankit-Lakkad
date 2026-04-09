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
    var m_id:String?
    var l_id:String?
    var titleArr : [String] = []
    var infoArr : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.layer.cornerRadius = 8
        self.fetchMatchInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchMatchInfo() {
           // Define the API URL
        let url = URL(string: MatchInfoAPI)!
           
           // Create the request
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           // Define the parameters
           let parameters: [String: Any] = [
               "spt_typ": 2,
               "l_id": l_id!,
               "m_id": m_id!
           ]
           
           // Set the HTTP body
           request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
           
           // Create the URL session
           let session = URLSession.shared
           
           // Create the data task
           let task = session.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("Error: \(error)")
                   return
               }
               
               guard let data = data else {
                   print("No data received")
                   return
               }
               
               do {
                   // Parse the JSON response
                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let statusCode = json["statusCode"] as? Int, statusCode == 200,
                      let result = json["result"] as? [String: Any] {
                       
                       // Extract the values
                       let mName = result["m_name"] as? String ?? "N/A"
                       let lName = result["l_name"] as? String ?? "N/A"
                       let venue = result["venue"] as? String ?? "N/A"
                       let startTimeTimestamp = result["strt_time_ts"] as? TimeInterval ?? 0
                       
                       // Convert timestamp to date
                       let startTime = Date(timeIntervalSince1970: startTimeTimestamp)
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateStyle = .medium
                       dateFormatter.timeStyle = .short
                       let startTimeString = dateFormatter.string(from: startTime)
                       
                       let result = convertTimestamp(Int(startTimeTimestamp))
                       let date =  result.formattedDate
                       let time  = result.formattedTime
                       
                       // Update UI on the main thread
                       self.titleArr = ["Match","Series","Date","Time","Venue"]
                       self.infoArr = [mName, lName, lName, date, time]
                       DispatchQueue.main.async {
                           if self.infoArr.isEmpty == true {
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
                   } else {
                       print("Invalid response")
                   }
               } catch {
                   print("Error parsing JSON: \(error)")
               }
           }
           
           // Start the task
           task.resume()
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
