//
//  MatchTabModel.swift
//  Football
//
//  Created by Ronik Hirpara on 11/02/25.
//

import Foundation

struct MatchTabsResponse: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: ResultDataLive?
}
//
//struct ResultDataLive: Codable {
//    let t1_scr: Int?
//    let t2_scr: Int?
//    let t1_cornerKicks: Int?
//    let t1_penalties: Int?
//    let t1_redCards: Int?
//    let t1_yellowCards: Int?
//    let t2_cornerKicks: Int?
//    let t2_penalties: Int?
//    let t2_redCards: Int?
//    let t2_yellowCards: Int?
//    let result_str: String?
//    let time: String?
//}


struct ResultDataLive: Codable {
    let t1_scr: Int?
    let t2_scr: Int?
    let t1_cornerKicks: Int?
    let t1_penalties: Int?
    let t1_redCards: Int?
    let t1_yellowCards: Int?
    let t2_cornerKicks: Int?
    let t2_penalties: Int?
    let t2_redCards: Int?
    let t2_yellowCards: Int?
    let result_str: String?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case t1_scr, t2_scr, t1_cornerKicks, t1_penalties, t1_redCards, t1_yellowCards
        case t2_cornerKicks, t2_penalties, t2_redCards, t2_yellowCards, result_str, time
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        t1_scr = try? ResultDataLive.decodeInt(from: container, forKey: .t1_scr)
        t2_scr = try? ResultDataLive.decodeInt(from: container, forKey: .t2_scr)
        t1_cornerKicks = try? ResultDataLive.decodeInt(from: container, forKey: .t1_cornerKicks)
        t1_penalties = try? ResultDataLive.decodeInt(from: container, forKey: .t1_penalties)
        t1_redCards = try? ResultDataLive.decodeInt(from: container, forKey: .t1_redCards)
        t1_yellowCards = try? ResultDataLive.decodeInt(from: container, forKey: .t1_yellowCards)
        t2_cornerKicks = try? ResultDataLive.decodeInt(from: container, forKey: .t2_cornerKicks)
        t2_penalties = try? ResultDataLive.decodeInt(from: container, forKey: .t2_penalties)
        t2_redCards = try? ResultDataLive.decodeInt(from: container, forKey: .t2_redCards)
        t2_yellowCards = try? ResultDataLive.decodeInt(from: container, forKey: .t2_yellowCards)
        result_str = try? container.decode(String.self, forKey: .result_str)
        time = try? container.decode(String.self, forKey: .time)
    }

    static func decodeInt(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Int {
        if let intValue = try? container.decode(Int.self, forKey: key) {
            return intValue
        }
        if let stringValue = try? container.decode(String.self, forKey: key), let intValue = Int(stringValue) {
            return intValue
        }
        throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Int but couldn't convert value"))
    }
}
