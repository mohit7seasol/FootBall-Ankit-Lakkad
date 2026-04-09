//
//  MatchResultAll.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import Foundation

struct MatchResultAll {
    let m_name: String
    let result_str: String
    let t1_sname: String
    let t2_sname: String
    let t1_flag: String
    let t2_flag: String
    let t1_goal: Int
    let t2_goal: Int
    let strt_time_ts: Int
    let gameState: String
    let time: String
    let m_id: String
    let l_id: String
}

extension MatchResultAll: Comparable {
    
    static func < (lhs: MatchResultAll, rhs: MatchResultAll) -> Bool {
        return lhs.strt_time_ts < rhs.strt_time_ts
    }
}
