//
//  MatchLiveAll.swift
//  Football
//
//  Created by Ronik Hirpara on 04/02/25.
//

import Foundation
import UIKit

struct MatchLiveAll{
    let m_name: String
    let t1_sname: String
    let t2_sname: String
    let t1_flag: String
    let t2_flag: String
    let strt_time_ts: Int
    let m_id: String
    let l_id: String
}

extension MatchLiveAll: Comparable {
    
    static func < (lhs: MatchLiveAll, rhs: MatchLiveAll) -> Bool {
        return lhs.strt_time_ts < rhs.strt_time_ts
    }
}
