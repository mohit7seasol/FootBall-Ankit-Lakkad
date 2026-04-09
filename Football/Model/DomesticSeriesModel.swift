//
//  DomesticSeriesModel.swift
//  Football
//
//  Created by Ronik Hirpara on 14/02/25.
//

import Foundation

struct MatchInfoSerie: Codable {
    let venue: String
    let m_name: String
    let l_name: String
}

struct MatchSeries: Codable {
    let l_id: String
    let show_series_section: Bool
    let cat: String
    let m_id: String
    let m_name: String
    let strt_time_ts: Int
    let strt_time: String
    let t1_name: String
    let t1_id: String
    let t1_sname: String
    let t1_flag: String
    let t2_id: String
    let t2_name: String
    let t2_sname: String
    let t2_flag: String
    let pos: Int
    let slug: String
    let series_slug: String
    let match_info: MatchInfoSerie
}

struct LeagueSeries: Codable {
    let l_id: String
    let series_slug: String
    let l_name: String
    let show_series_section: Bool
    let matches: [MatchSeries]
}

struct MatchesDataSeries: Codable {
    let date: String
    let leagues: [LeagueSeries]
}

struct CategoryDataSeries: Codable {
    let category: String
    let position: Int
}

struct ResultDataSeries: Codable {
    let categoryData: [CategoryDataSeries]
    let matchesData: [MatchesDataSeries]
}

struct APIResponseSeries: Codable {
    let statusCode: Int
    let status: Bool
    let message: String
    let result: ResultDataSeries
}
