//
//  MessageRespone.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
struct Message: Codable {
    let image: String
    let nameSender: String
    let receiverID: String
    let receivername: String
    let sendId: String
    let text: String
    let time: Double
    let read: Bool
    let messageKey: String
    init(dict: [String: Any]) {
        self.image = dict["image"] as? String ?? ""
        self.nameSender = dict["nameSender"] as? String ?? ""
        self.receiverID = dict["receiverID"] as? String ?? ""
        self.receivername = dict["receivername"] as? String ?? ""
        self.sendId = dict["sendId"] as? String ?? ""
        self.text = dict["text"] as? String ?? ""
        self.time = dict["time"] as? Double ?? 0
        self.read = dict["read"] as? Bool ?? false
        self.messageKey = dict["messageKey"] as? String ?? ""
    }
}
