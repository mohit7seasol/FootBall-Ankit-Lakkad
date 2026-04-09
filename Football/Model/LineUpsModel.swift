//
//  LineUpsModel.swift
//  Football
//
//  Created by Ronik Hirpara on 13/02/25.
//

import Foundation

struct LineupResponse: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: MatchResult
}

struct MatchResult: Codable {
    let m_id: String
    let lineup_updates: LineupUpdates
}

struct LineupUpdates: Codable {
    let t1_formation: String
    let t2_formation: String
    let t1_Squad: [Player]
    let t2_Squad: [Player]
}

struct Player: Codable {
    let playerName: String
    let position: String
    let image: String
    let shirtnumber:Int
}
