//
//  Enum.swift
//  ChatAppDemo
//
//  Created by BeeTech on 15/12/2022.
//

import Foundation

public enum State: String {
    case emptyEmail = "Email must not be empty"
    case emptyName = " Name must not be empty"
    case emailAlreadyExist = " Email already exist  "
    case emptPassword = "Password must not be empty"
    case emptyAvatarUrl = "You have not selected a profile picture"
    case passwordNotincorrect = "Confirm Password incorrect"
}
