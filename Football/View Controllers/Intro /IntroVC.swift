//
//  IntroVC.swift
//  Football
//
//  Created by Ronik Hirpara on 15/04/25.
//

import UIKit

class IntroVC: UIViewController {

    private weak var pagerVc: IntroPVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logAnalyticAction(title: "", status: AnalyticEvent.Intro)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(naviToNative(noti:)), name: NSNotification.Name(rawValue: "naviToNative"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(naviToIntro3(noti:)), name: NSNotification.Name(rawValue: "naviToIntro3"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? IntroPVC {
            pagerVc = pageViewController
            pagerVc?.tabDelegate = self
        }
    }
    
    @objc func naviToNative(noti: Notification) {
        pagerVc?.moveToPage(index: 1, animated: true)
    }
    
    @objc func naviToIntro3(noti: Notification) {
        pagerVc?.moveToPage(index: 2, animated: true)
    }

}

extension IntroVC: IntroDelegate {
    
    func didPickItem(currentItem: Int) {
        if currentItem == 0 {
            
            pagerVc?.moveToPage(index: 0, animated: true)
            
        } else if currentItem == 1 {
            
            pagerVc?.moveToPage(index: 1, animated: true)
            
        } else if currentItem == 2 {
            
            pagerVc?.moveToPage(index: 2, animated: true)
            
        }
    }
    
}
