//
//  ScoreDetailsPVC.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import UIKit

protocol ScoreDelegate {
    func didPickItem(currentItem: Int)
}

class ScoreDetailsPVC: UIPageViewController {

    var tabDelegate: ScoreDelegate?  // This matches the protocol name
    var arrVc = [UIViewController]()
    var currentPageIndex = 0
    var m_idMain: String?
    var l_idMain: String?
    var Aname: String?
    var Bname: String?
    var Aimg: String?
    var Bimg: String?
    
    // Data for child VCs
    var matchDetails: MatchDetails?
    var stats: [MatchStatModel] = []
    var eventsUpdates: [MatchSummaryEvent] = []
    var standings: [Standing] = []
    var h2hMatches: [H2HMatch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateArrVc()
        self.setupPager()
    }
    
    private func setupPager() {
        if let startingViewController = contentViewController(at: currentPageIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
            tabDelegate?.didPickItem(currentItem: 0)
        }
    }
    
    private func generateArrVc() {
        var index = 0
        
        if isComeFromUpcoming == true {
            // For upcoming matches - different tabs
            let vc1 = SquadVC.instantiate(fromAppStoryboard: .Main)
            vc1.index = index
            vc1.m_id = self.m_idMain
            vc1.l_id = self.l_idMain
            vc1.Aname = self.Aname
            vc1.Bname = self.Bname
            arrVc.append(vc1)
            
            index += 1
            let vc2 = InfoVC.instantiate(fromAppStoryboard: .Main)
            vc2.index = index
            vc2.m_id = self.m_idMain
            vc2.l_id = self.l_idMain
            vc2.matchDetails = self.matchDetails
            arrVc.append(vc2)
            
            index += 1
            let vc3 = PointTableVC.instantiate(fromAppStoryboard: .Main)
            vc3.index = index
            vc3.m_id = self.m_idMain
            vc3.l_id = self.l_idMain
            vc3.standings = self.standings
            arrVc.append(vc3)
            
        } else {
            // For live/completed matches - full tabs
            let vc1 = LiveUpdateVC.instantiate(fromAppStoryboard: .Main)
            vc1.index = index
            vc1.m_id = self.m_idMain
            vc1.l_id = self.l_idMain
            vc1.eventsUpdates = self.eventsUpdates
            arrVc.append(vc1)
            
            index += 1
            let vc2 = OverViewVC.instantiate(fromAppStoryboard: .Main)
            vc2.index = index
            vc2.m_id = self.m_idMain
            vc2.l_id = self.l_idMain
            vc2.eventsUpdates = self.eventsUpdates
            arrVc.append(vc2)
            
            index += 1
            let vc3 = LineUpsVC.instantiate(fromAppStoryboard: .Main)
            vc3.index = index
            vc3.m_id = self.m_idMain
            vc3.l_id = self.l_idMain
            vc3.Aname = self.Aname
            vc3.Bname = self.Bname
            vc3.Aimg = self.Aimg
            vc3.Bimg = self.Bimg
            vc3.matchDetails = self.matchDetails
            arrVc.append(vc3)
            
            index += 1
            let vc4 = StatsVC.instantiate(fromAppStoryboard: .Main)
            vc4.index = index
            vc4.m_id = self.m_idMain
            vc4.l_id = self.l_idMain
            vc4.stats = self.stats
            arrVc.append(vc4)
            
            index += 1
            let vc5 = HeadToHeadDetailsVC.instantiate(fromAppStoryboard: .Main)
            vc5.index = index
            vc5.m_id = self.m_idMain
            vc5.l_id = self.l_idMain
            vc5.Aname = self.Aname
            vc5.Bname = self.Bname
            vc5.matchDetails = self.matchDetails
            vc5.h2hMatches = self.h2hMatches
            arrVc.append(vc5)
            
            index += 1
            let vc6 = InfoVC.instantiate(fromAppStoryboard: .Main)
            vc6.index = index
            vc6.m_id = self.m_idMain
            vc6.l_id = self.l_idMain
            vc6.matchDetails = self.matchDetails
            arrVc.append(vc6)
            
            index += 1
            let vc7 = PointTableVC.instantiate(fromAppStoryboard: .Main)
            vc7.index = index
            vc7.m_id = self.m_idMain
            vc7.l_id = self.l_idMain
            vc7.standings = self.standings
            arrVc.append(vc7)
        }
    }
    
    private func contentViewController(at index: Int) -> UIViewController? {
        if index < 0 || index >= arrVc.count {
            return nil
        }
        return arrVc[index]
    }
    
    func moveToPage(index: Int, animated: Bool) {
        if currentPageIndex != index {
            if index > currentPageIndex {
                if let nextVc = contentViewController(at: index) {
                    setViewControllers([nextVc], direction: .forward, animated: animated, completion: nil)
                }
            } else {
                if let nextVc = contentViewController(at: index) {
                    setViewControllers([nextVc], direction: .reverse, animated: animated, completion: nil)
                }
            }
            currentPageIndex = index
            tabDelegate?.didPickItem(currentItem: currentPageIndex)
        }
    }
}
