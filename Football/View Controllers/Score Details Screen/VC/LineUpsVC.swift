//
//  LineUpsVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

class LineUpsVC: UIViewController {

    @IBOutlet weak var goal1View: LinesUpCell!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var goal2View: LinesUpCell!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var team1Img: UIImageView!
    @IBOutlet weak var team2Img: UIImageView!
    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var team2ScoreLbl: UILabel!
    @IBOutlet weak var a1View: LinesUpCell!
    @IBOutlet weak var a2View: LinesUpCell!
    @IBOutlet weak var a3View: LinesUpCell!
    @IBOutlet weak var a4View: LinesUpCell!
    @IBOutlet weak var a5View: LinesUpCell!
    @IBOutlet weak var b1View: LinesUpCell!
    @IBOutlet weak var b2View: LinesUpCell!
    @IBOutlet weak var b3View: LinesUpCell!
    @IBOutlet weak var b4View: LinesUpCell!
    @IBOutlet weak var b5View: LinesUpCell!
    @IBOutlet weak var c1View: LinesUpCell!
    @IBOutlet weak var c2View: LinesUpCell!
    @IBOutlet weak var c3View: LinesUpCell!
    @IBOutlet weak var c4View: LinesUpCell!
    @IBOutlet weak var c5View: LinesUpCell!
    @IBOutlet weak var d1View: LinesUpCell!
    @IBOutlet weak var d2View: LinesUpCell!
    @IBOutlet weak var d3View: LinesUpCell!
    @IBOutlet weak var d4View: LinesUpCell!
    @IBOutlet weak var d5View: LinesUpCell!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    
    
    var index = -1
    var m_id:String?
    var l_id:String?
    var Aname:String?
    var Bname:String?
    var Aimg:String?
    var Bimg:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.Aname?.isEmpty == false {
            self.team1Lbl.text = self.Aname
        } else {
            self.team1Lbl.text = "TeamA"
        }
        
        if self.Bname?.isEmpty == false {
            self.team2Lbl.text = self.Bname
        } else {
            self.team2Lbl.text = "TeamB"
        }
        
        if self.Aimg?.isEmpty == false {
            let urlA = URL(string: self.Aimg!)
            self.team1Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
        } else {
            self.team1Img.image = UIImage(named: "ic_replace")!
        }
        
        if self.Bimg?.isEmpty == false {
            let urlA = URL(string: self.Bimg!)
            self.team2Img.sd_setImage(with: urlA, placeholderImage: UIImage(named: "splash"))
        } else {
            self.team2Img.image = UIImage(named: "ic_replace")!
        }
        
        self.fetchLineupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.noDataLbl.text = "No data Available".localized()
    }
    
    func fetchLineupData() {
        let url = URL(string: "https://apis.sportstiger.com/Prod/football-match-lineup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["m_id": m_id!]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(String(describing: error))")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(LineupResponse.self, from: data)
                DispatchQueue.main.async {
                    self.team1ScoreLbl.text = response.result.lineup_updates.t1_formation
                    self.team2ScoreLbl.text = response.result.lineup_updates.t2_formation
                    
                    if response.result.lineup_updates.t1_Squad.isEmpty == false {
                        self.goal1View.isHidden = false
                        self.stackView1.isHidden = false
                        self.stackView2.isHidden = false
                        self.scrlView.isHidden = false
                        self.noDataView.isHidden = true
                        self.updateUI1(with: response.result.lineup_updates.t1_Squad)
                    } else {
                        self.goal1View.isHidden = true
                        self.stackView1.isHidden = true
                        self.stackView2.isHidden = true
                        self.scrlView.isHidden = true
                        self.noDataView.isHidden = false
                    }
                    
                    if response.result.lineup_updates.t2_Squad.isEmpty == false {
                        self.goal2View.isHidden = false
                        self.stackView3.isHidden = false
                        self.stackView4.isHidden = false
                        self.scrlView.isHidden = false
                        self.noDataView.isHidden = true
                        self.updateUI2(with: response.result.lineup_updates.t2_Squad)
                    } else {
                        self.goal2View.isHidden = true
                        self.stackView3.isHidden = true
                        self.stackView4.isHidden = true
                        self.scrlView.isHidden = true
                        self.noDataView.isHidden = false
                    }
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    func updateUI1(with players: [Player]) {
        guard players.count >= 11 else { return }
        
        if let goalkeeper = players.first(where: { $0.position == "Goalkeeper" }) {
            setData(view: goal1View, lbltitle: goalkeeper.playerName, count: "\(goalkeeper.shirtnumber)")
        }
        
        // Filter out the Goalkeeper and set the rest of the players in different labels
        let otherPlayers = players.filter { $0.position != "Goalkeeper" }
        
        // Ensure there are enough players for all labels
        guard otherPlayers.count >= 10 else { return }
        
        // Set the remaining players' data in different labels
        setData(view: a1View, lbltitle: otherPlayers[0].playerName, count: "\(otherPlayers[0].shirtnumber)")
        setData(view: a2View, lbltitle: otherPlayers[1].playerName, count: "\(otherPlayers[1].shirtnumber)")
        setData(view: a3View, lbltitle: otherPlayers[2].playerName, count: "\(otherPlayers[2].shirtnumber)")
        setData(view: a4View, lbltitle: otherPlayers[3].playerName, count: "\(otherPlayers[3].shirtnumber)")
        setData(view: a5View, lbltitle: otherPlayers[4].playerName, count: "\(otherPlayers[4].shirtnumber)")
        
        setData(view: b1View, lbltitle: otherPlayers[5].playerName, count: "\(otherPlayers[5].shirtnumber)")
        setData(view: b2View, lbltitle: otherPlayers[6].playerName, count: "\(otherPlayers[6].shirtnumber)")
        setData(view: b3View, lbltitle: otherPlayers[7].playerName, count: "\(otherPlayers[7].shirtnumber)")
        setData(view: b4View, lbltitle:  otherPlayers[8].playerName, count: "\(otherPlayers[8].shirtnumber)")
        setData(view: b5View, lbltitle:  otherPlayers[9].playerName, count: "\(otherPlayers[9].shirtnumber)")
    }
    
    func setData(view: LinesUpCell, lbltitle:String, count:String) {
        view.playerNameLbl.text = lbltitle
        view.shirtNoLbl.text = count
    }
    
    func updateUI2(with players: [Player]) {
        guard players.count >= 11 else { return }
        
        if let goalkeeper = players.first(where: { $0.position == "Goalkeeper" }) {
            setData(view: goal2View, lbltitle: goalkeeper.playerName, count: "\(goalkeeper.shirtnumber)")
        }
        
        // Filter out the Goalkeeper and set the rest of the players in different labels
        let otherPlayers = players.filter { $0.position != "Goalkeeper" }
        
        // Ensure there are enough players for all labels
        guard otherPlayers.count >= 10 else { return }
        
        // Set the remaining players' data in different labels
        setData(view: c1View, lbltitle: otherPlayers[0].playerName, count: "\(otherPlayers[0].shirtnumber)")
        setData(view: c2View, lbltitle: otherPlayers[1].playerName, count: "\(otherPlayers[1].shirtnumber)")
        setData(view: c3View, lbltitle: otherPlayers[2].playerName, count: "\(otherPlayers[2].shirtnumber)")
        setData(view: c4View, lbltitle: otherPlayers[3].playerName, count: "\(otherPlayers[3].shirtnumber)")
        setData(view: c5View, lbltitle: otherPlayers[4].playerName, count: "\(otherPlayers[4].shirtnumber)")
        
        setData(view: d1View, lbltitle: otherPlayers[5].playerName, count: "\(otherPlayers[5].shirtnumber)")
        setData(view: d2View, lbltitle: otherPlayers[6].playerName, count: "\(otherPlayers[6].shirtnumber)")
        setData(view: d3View, lbltitle: otherPlayers[7].playerName, count: "\(otherPlayers[7].shirtnumber)")
        setData(view: d4View, lbltitle:  otherPlayers[8].playerName, count: "\(otherPlayers[8].shirtnumber)")
        setData(view: d5View, lbltitle:  otherPlayers[9].playerName, count: "\(otherPlayers[9].shirtnumber)")
    }

}
