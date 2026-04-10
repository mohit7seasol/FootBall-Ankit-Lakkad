//
//  CategoryPVC.swift
//  Football
//
//  Created by Ronik Hirpara on 05/02/25.
//

import UIKit

protocol CategoryDelegate {
    func didPickItem(currentItem: Int)
}

class CategoryPVC: UIPageViewController {

    var tabDelegate: CategoryDelegate?
    var arrVc = [UIViewController]()
    var currentPageIndex = 0
    weak var parentVC: FootballVC?
    
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
        let vc1 = LiveVC.instantiate(fromAppStoryboard: .Main)
        vc1.index = index
        arrVc.append(vc1)
        
        index += 1
        let vc2 = UpcomingVC.instantiate(fromAppStoryboard: .Main)
        vc2.index = index
        arrVc.append(vc2)
        
        index += 1
        let vc3 = CompletedVC.instantiate(fromAppStoryboard: .Main)
        vc3.index = index
        arrVc.append(vc3)
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
