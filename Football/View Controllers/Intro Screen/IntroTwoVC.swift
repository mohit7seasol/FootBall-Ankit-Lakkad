//
//  IntroTwoVC.swift
//  Football
//
//  Created by Ronik Hirpara on 26/02/25.
//

import UIKit
import GoogleMobileAds
import Lottie

class IntroTwoVC: UIViewController {

    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var animationImg: UIImageView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var nextBtn: Button!
    
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.topImg.image = UIImage(named: "intro2_ic_ipad")
        } else {
            self.topImg.image = UIImage(named: "intro2_ic")
        }
        self.designSetUP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topLbl.text = "Football Series & News".localized()
        self.bottomLbl.text = "Stay informed on football series, team updates, and match results. Get the latest highlights and breaking news.".localized()
        self.nextBtn.setTitle("Next".localized(), for: .normal)
    }
    
    func designSetUP() {
        let jsonName = "Swipe_Left.json"
        let animationVal = LottieAnimation.named(jsonName)
        let animationView = LottieAnimationView(animation: animationVal)
        animationView.frame = self.animationImg.bounds
        self.animationImg.contentMode = .scaleAspectFit
        self.animationImg.addSubview(animationView)
        
        // Play the animation
        animationView.play()
        animationView.loopMode = .loop
    }
    
    @IBAction func clickOnNext(_ sender: Any) {
        //setIsIntroTwo(status: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "naviToIntro3"), object: nil)
    }
    

}

