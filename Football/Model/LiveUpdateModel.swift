//
//  LiveUpdateModel.swift
//  Football
//
//  Created by Ronik Hirpara on 12/02/25.
//

import Foundation

struct Commentary {
    let time: String
    let text: String
    let player1Name: String
    let cardType: String
    let teamName: String
    
    init(dictionary: [String: Any]) {
        self.time = dictionary["time"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.player1Name = dictionary["player1Name"] as? String ?? ""
        self.cardType = dictionary["cardType"] as? String ?? ""
        self.teamName = dictionary["teamName"] as? String ?? ""
    }
}
