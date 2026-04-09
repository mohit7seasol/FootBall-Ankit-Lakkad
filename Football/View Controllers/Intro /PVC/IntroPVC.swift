//
//  IntroPVC.swift
//  Football
//
//  Created by Ronik Hirpara on 15/04/25.
//

import UIKit

protocol IntroDelegate {
    func didPickItem(currentItem: Int)
}

class IntroPVC: UIPageViewController {

    var tabDelegate: IntroDelegate?
    var arrVc = [UIViewController]()
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.generateArrVc()
        self.setupPager()
    }
    
    private func setupPager() {
        dataSource = self
                delegate = self
        
        if let startingViewController = contentViewController(at: currentPageIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
            tabDelegate?.didPickItem(currentItem: 0)
        }
    }
    
    private func generateArrVc() {
        var index = 0
        let vc1 = IntroOneVC.instantiate(fromAppStoryboard: .Main)
        vc1.index = index
        arrVc.append(vc1)
        
        index += 1
        let vc2 = IntroTwoVC.instantiate(fromAppStoryboard: .Main)
        vc2.index = index
        arrVc.append(vc2)
        
        index += 1
        let vc3 = IntroNativeVC.instantiate(fromAppStoryboard: .Main)
        vc3.index = index
        arrVc.append(vc3)
        
    }
    
     private func contentViewController(at index: Int) -> UIViewController? {
        if index < 0 || index >= arrVc.count {
            return nil
        }
        if index < arrVc.count {
            return arrVc[index]
        }
        return nil
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

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension IntroPVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if let vc = viewController as? IntroOneVC {
            var index = vc.index
            index -= 1
            return contentViewController(at: index)
        } else if let vc = viewController as? IntroTwoVC {
            var index = vc.index
            index -= 1
            return contentViewController(at: index)
        } else if let vc = viewController as? IntroNativeVC {
            var index = vc.index
            index -= 1
            return contentViewController(at: index)
        }
        return nil

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let vc = viewController as? IntroOneVC {
            var index = (vc.index)
            index += 1
            return contentViewController(at: index)
        } else if let vc = viewController as? IntroTwoVC {
            var index = vc.index
            index += 1
            return contentViewController(at: index)
        } else if let vc = viewController as? IntroNativeVC{
            var index = vc.index
            index += 1
            return contentViewController(at: index)
        }
        return nil

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? IntroOneVC {
                currentPageIndex = contentViewController.index
                tabDelegate?.didPickItem(currentItem: contentViewController.index)
            } else if let contentViewController = pageViewController.viewControllers?.first as? IntroTwoVC {
                currentPageIndex = contentViewController.index
                tabDelegate?.didPickItem(currentItem: contentViewController.index)
            } else if let contentViewController = pageViewController.viewControllers?.first as? IntroNativeVC {
                currentPageIndex = contentViewController.index
                tabDelegate?.didPickItem(currentItem: contentViewController.index)
            }
        }
    }
    
}
