//
//  SignInPresenter.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import Firebase

protocol SignInPresenterDelegate: NSObject {
    func showUserRegiter(_ email: String, password: String)
}
class SignInPresenter {
    private weak var view: SignInPresenterDelegate?
    private var users = [User]()
    private var currentUser: User?
    private let db = Firestore.firestore()
    init(with view: SignInPresenterDelegate) {
        self.view = view
    }

    func fetchUser() {
        FirebaseService.share.fetchUser { user in
            self.users.append(contentsOf: user)
        }
    }
    
    func validateEmailPassword(_ email: String, _ password: String, completion: (_ currentUser: User?, Bool) -> Void) {
        var currentUser: User?
        var isvalid: Bool = false
        users.forEach { user in
            if user.email == email && user.password == password {
                currentUser = user
                isvalid = true
            }
        }
        completion(currentUser, isvalid)
    }
    
    func getUserData() -> [User] {
        return users
    }
    
    func showUserInfo() -> (email: String, password: String )  {
        var email: String = ""
        var password: String = ""
        let info = DataManager.shareInstance.getUser()
        _ = info.map { item in
            email = item.email
            password = item.password
        }
        return (email, password)
    }
    
    func showUserResgiter(_ email: String, password: String) {
        view?.showUserRegiter(email, password: password)
    }
}
