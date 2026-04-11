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
    var m_id: String?
    var l_id: String?
    var Aname: String?
    var Bname: String?
    var Aimg: String?
    var Bimg: String?
    var matchDetails: MatchDetails?
    var lineupData: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDataLbl.text = "No data Available".localized()
        setupTeamInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !lineupData.isEmpty {
            processLineupData()
        } else {
            fetchLineupData()
        }
    }
    
    func setupTeamInfo() {
        if let details = matchDetails {
            team1Lbl.text = details.homeName
            team2Lbl.text = details.awayName
            if let url = URL(string: details.homeLogo) {
                team1Img.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_EmptyFlag"))
            }
            if let url = URL(string: details.awayLogo) {
                team2Img.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_EmptyFlag"))
            }
        } else {
            team1Lbl.text = Aname ?? "TeamA"
            team2Lbl.text = Bname ?? "TeamB"
            if let url = URL(string: Aimg ?? "") {
                team1Img.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_EmptyFlag"))
            }
            if let url = URL(string: Bimg ?? "") {
                team2Img.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_EmptyFlag"))
            }
        }
    }
    
    func setData(view: LinesUpCell, lbltitle: String, count: String) {
        view.playerNameLbl.text = lbltitle
        view.shirtNoLbl.text = count
    }
    
    // MARK: - Reference Code API
    func fetchLineupData() {
        let urlString = "https://flashscore4.p.rapidapi.com/api/flashscore/v2/matches/match/lineups?match_id=\(m_id ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("flashscore4.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APITOKEN, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("API Error:", error?.localizedDescription ?? "")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                guard let teams = result, teams.count >= 2 else { return }
                
                DispatchQueue.main.async {
                    self?.lineupData = teams
                    self?.processLineupData()
                }
            } catch {
                print("JSON Error:", error)
            }
        }.resume()
    }
    
    func processLineupData() {
        guard lineupData.count >= 2 else { return }
        
        let homeTeam = lineupData[0]
        let awayTeam = lineupData[1]
        
        let homeFormation = homeTeam["predictedFormation"] as? String
        let awayFormation = awayTeam["predictedFormation"] as? String
        
        team1ScoreLbl.text = homeFormation
        team2ScoreLbl.text = awayFormation
        
        let scoreView = team1ScoreLbl.superview
        scoreView?.isHidden = (homeFormation?.isEmpty ?? true) && (awayFormation?.isEmpty ?? true)
        
        var homePlayers = homeTeam["startingLineups"] as? [[String: Any]] ?? []
        if homePlayers.isEmpty {
            homePlayers = homeTeam["predictedLineups"] as? [[String: Any]] ?? []
        }
        
        var awayPlayers = awayTeam["startingLineups"] as? [[String: Any]] ?? []
        if awayPlayers.isEmpty {
            awayPlayers = awayTeam["predictedLineups"] as? [[String: Any]] ?? []
        }
        
        if !homePlayers.isEmpty {
            updateHomePlayers(homePlayers)
        } else {
            goal1View.isHidden = true
            stackView1.isHidden = true
            stackView2.isHidden = true
            scrlView.isHidden = true
            noDataView.isHidden = false
        }
        
        if !awayPlayers.isEmpty {
            updateAwayPlayers(awayPlayers)
        } else {
            goal2View.isHidden = true
            stackView3.isHidden = true
            stackView4.isHidden = true
            scrlView.isHidden = true
            noDataView.isHidden = false
        }
        
        if !homePlayers.isEmpty || !awayPlayers.isEmpty {
            noDataView.isHidden = true
            scrlView.isHidden = false
        }
    }
    
    func updateHomePlayers(_ players: [[String: Any]]) {
        guard players.count >= 11 else {
            goal1View.isHidden = true
            stackView1.isHidden = true
            stackView2.isHidden = true
            return
        }
        
        let goalkeeper = players[0]
        setData(view: goal1View, lbltitle: goalkeeper["fieldName"] as? String ?? "", count: "")
        
        let others = Array(players.dropFirst())
        
        setData(view: a1View, lbltitle: others[0]["fieldName"] as? String ?? "", count: "")
        setData(view: a2View, lbltitle: others[1]["fieldName"] as? String ?? "", count: "")
        setData(view: a3View, lbltitle: others[2]["fieldName"] as? String ?? "", count: "")
        setData(view: a4View, lbltitle: others[3]["fieldName"] as? String ?? "", count: "")
        setData(view: a5View, lbltitle: others[4]["fieldName"] as? String ?? "", count: "")
        setData(view: b1View, lbltitle: others[5]["fieldName"] as? String ?? "", count: "")
        setData(view: b2View, lbltitle: others[6]["fieldName"] as? String ?? "", count: "")
        setData(view: b3View, lbltitle: others[7]["fieldName"] as? String ?? "", count: "")
        setData(view: b4View, lbltitle: others[8]["fieldName"] as? String ?? "", count: "")
        setData(view: b5View, lbltitle: others[9]["fieldName"] as? String ?? "", count: "")
        
        goal1View.isHidden = false
        stackView1.isHidden = false
        stackView2.isHidden = false
    }
    
    func updateAwayPlayers(_ players: [[String: Any]]) {
        guard players.count >= 11 else {
            goal2View.isHidden = true
            stackView3.isHidden = true
            stackView4.isHidden = true
            return
        }
        
        let goalkeeper = players[0]
        setData(view: goal2View, lbltitle: goalkeeper["fieldName"] as? String ?? "", count: "")
        
        let others = Array(players.dropFirst())
        
        setData(view: c1View, lbltitle: others[0]["fieldName"] as? String ?? "", count: "")
        setData(view: c2View, lbltitle: others[1]["fieldName"] as? String ?? "", count: "")
        setData(view: c3View, lbltitle: others[2]["fieldName"] as? String ?? "", count: "")
        setData(view: c4View, lbltitle: others[3]["fieldName"] as? String ?? "", count: "")
        setData(view: c5View, lbltitle: others[4]["fieldName"] as? String ?? "", count: "")
        setData(view: d1View, lbltitle: others[5]["fieldName"] as? String ?? "", count: "")
        setData(view: d2View, lbltitle: others[6]["fieldName"] as? String ?? "", count: "")
        setData(view: d3View, lbltitle: others[7]["fieldName"] as? String ?? "", count: "")
        setData(view: d4View, lbltitle: others[8]["fieldName"] as? String ?? "", count: "")
        setData(view: d5View, lbltitle: others[9]["fieldName"] as? String ?? "", count: "")
        
        goal2View.isHidden = false
        stackView3.isHidden = false
        stackView4.isHidden = false
    }
}
