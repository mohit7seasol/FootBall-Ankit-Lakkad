//
//  UIApplication+Extension.swift
//  Dual-WhatScan
//
//  Created by iMac on 10/06/23.
//

import Foundation
import UIKit

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "HasAtLeastLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "HasAtLeastLaunchedOnce")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
