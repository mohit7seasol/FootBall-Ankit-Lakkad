//
//  OverViewModel.swift
//  Football
//
//  Created by Ronik Hirpara on 13/02/25.
//

import Foundation

struct MatchOverviewResponse: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: MatchResultOverView
}

struct MatchResultOverView: Codable {
    let m_id: String
    let t1_id: Int
    let t1_name: String
    let t2_id: Int
    let t2_name: String
    let events_updates: [EventUpdate]
}

struct EventUpdate: Codable {
    let time: Int
    let t_id: Int
    let playerInName: String
    let playerOutName: String
    let text: String
    let card: String
    
}
