//
//  SettingPresenterView.swift
//  ChatAppDemo
//
//  Created by BeeTech on 20/12/2022.
//

import UIKit
protocol SettingPresenterDelegate: NSObject {
    
}

class SettingPresenterView {
    private weak var view: SettingPresenterDelegate?
    private var user: User?
    private var avatarUrl: String = ""
    init(with view: SettingPresenterDelegate, user: User) {
        self.view = view
        self.user = user
    }
    
    func setStateUserForLogOut() {
        guard let user = user else  {return}
        FirebaseService.share.changeStateInActiveForUser(user)
    }
    
    func fetchNewAvatarUrl(_ image: UIImage) {
        FirebaseService.share.fetchAvatarUrl(image)
    }
    
    func changeAvatar() {
        guard let user = user else {return}
        FirebaseService.share.updateAvatar(user)
    }
    
    func changeName(name: String) {
        guard let user = user else {return}
        FirebaseService.share.updateName(user, name: name)
    }
    
    func changeEmail( email: String) {
        guard let user = user else {return}
        FirebaseService.share.updateEmail(user, email: email)
    }
    
    func changePassword( password: String) {
        guard let user = user else {return}
        FirebaseService.share.updatePassword(user, password: password)
    }
    
    
    func getUser() -> User? {
        return user
    }
    
}
