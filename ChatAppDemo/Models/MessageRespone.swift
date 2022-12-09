//
//  MessageRespone.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
struct MessageRespone: Codable {
    let image: String
    let nameSender: String
    let receiverID: String
    let recevernmae: String
    let sendId: String
    let text: String
    let time: Double
    init(dict: [String: Any]) {
        self.image = dict["image"] as? String ?? ""
        self.nameSender = dict["nameSender"] as? String ?? ""
        self.receiverID = dict["receiverID"] as? String ?? ""
        self.recevernmae = dict["recevernmae"] as? String ?? ""
        self.sendId = dict["sendId"] as? String ?? ""
        self.text = dict["text"] as? String ?? ""
        self.time = dict["time"] as? Double ?? 0
    }
}
