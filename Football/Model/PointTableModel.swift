//
//  PointTableModel.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import Foundation

struct Team: Codable {
    let tname: String
    let P: Int
    let W: Int
    let L: Int
    let D: Int
    let PTS: Int
}

struct Standings: Codable {
    let standings: [Team]
}

struct TeamStandingsResponse: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: ResultData?
    
    struct ResultData: Codable {
        let team_standings: [Standings]?
    }
}
