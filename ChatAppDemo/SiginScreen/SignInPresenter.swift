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
        self.users.removeAll()
        FirebaseService.share.fetchUser { user in
            self.users.append(contentsOf: user)
        }
    }
    
    func registerSocialMediaAccount(_ result: [String: Any]) {
        let email = result["email"] as? String ?? ""
        let name = result["name"] as? String ?? ""
        let id = result["id"] as? String ?? ""
        let pictureData: [String: Any] = result["picture"] as? [String: Any] ?? [:]
        let pictureUrl: [String: Any] = pictureData["data"] as? [String: Any] ?? [:]
        let url = pictureUrl["url"] as? String ?? ""
    
        FirebaseService.share.registerSocialMedia(name, email: email, id: id, picture: url)
    }
    func loginZalo(_ vc: SiginViewController, completed:@escaping (User?) -> Void) {
        ZaloService.shared.login(vc) { email, name, id, url in
            let user = User(name: name, id: id, picture: url, email: email, password: "", isActive: false)
            FirebaseService.share.registerSocialMedia(name, email: email, id: id, picture: url)
            completed(user)
        }
    }
    
    func validateSocialMediaAccount(_ email: String, completion: (_ socialMediaUser : User?, Bool) -> Void) {
        var currentUser: User?
        var isvalid: Bool = false
        users.forEach { user in
            if user.email == email {
                currentUser = user
                isvalid = true
            }
        }
        completion(currentUser, isvalid)
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
    
    func changeStateUser(_ currentUser: User) {
       
        FirebaseService.share.changeStateActiveForUser(currentUser)
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
