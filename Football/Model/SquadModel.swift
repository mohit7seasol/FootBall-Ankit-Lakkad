//
//  SquadModel.swift
//  Football
//
//  Created by Ronik Hirpara on 07/02/25.
//

import Foundation

struct Squad: Codable {
    var imageURL: String
    let role: String
    let name: String
}

struct SquadResponse: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: ResultData?
}

struct ResultData: Codable {
    let t1_squad: [Squad]
    let t2_squad: [Squad]
}
