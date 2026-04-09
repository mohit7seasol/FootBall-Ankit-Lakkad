//
//  NewsModel.swift
//  Football
//
//  Created by Ronik Hirpara on 06/02/25.
//

import Foundation

struct NewsResponse: Decodable {
    let message: String
    let data: [NewsModel]
}

struct NewsModel: Decodable {
    let id: String
    let title: String
    let imageUrl: String
    let subDesc: String
    let article: String
}
