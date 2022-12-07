//
//  User.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation
struct UserRespone {
    let name: String
    let email: String
    let password: String
    init(dict: [String: Any]) {
        self.email = dict["email"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.password = dict["password"] as? String ?? ""
    }
}
