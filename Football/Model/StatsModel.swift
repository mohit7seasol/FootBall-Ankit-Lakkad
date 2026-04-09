//
//  StatsModel.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import Foundation

struct MatchStat: Codable {
    let typeId: Int
    let t1Stats: Int
    let t2Stats: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case typeId
        case t1Stats = "t1_Stats"
        case t2Stats = "t2_Stats"
        case type
    }
}

struct MatchStatsResponse: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: MatchStatsResult?
}

struct MatchStatsResult: Codable {
    let mId: String
    let t1Id: Int
    let t1Name: String
    let t2Id: Int
    let t2Name: String
    let matchStats: [MatchStat]?
    
    enum CodingKeys: String, CodingKey {
        case mId = "m_id"
        case t1Id = "t1_id"
        case t1Name = "t1_name"
        case t2Id = "t2_id"
        case t2Name = "t2_name"
        case matchStats = "match_stats"
    }
}
