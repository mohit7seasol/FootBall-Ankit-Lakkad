//
//  AnalyticsWrapper.swift
//  CineBuzz
//
//  Created by Parthiv Akbari on 23/07/25.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

enum AnalyticEvent: String {
    
    case Home
    case Settings
    case Language
    case Privacy
    case AboutUs
    case Terms
    case Eula
    case Premium
    case Match
    case Series
    case MatchDetails
    case News
    case NewsDetails
    case Intro
    
}

func logAnalyticView(title: String, Screen: String) {
    Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: title, AnalyticsParameterScreenClass: Screen])
}

func logAnalyticAction(title: String, status: AnalyticEvent) {
    Analytics.logEvent(status.rawValue, parameters: ["name": title, "status": status])
}

func logAnalyticActionWithParams(_ name: AnalyticEvent, parameters: [String : Any]?)
{
    Analytics.logEvent(name.rawValue, parameters: parameters)
}
