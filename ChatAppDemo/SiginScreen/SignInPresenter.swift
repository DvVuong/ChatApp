//
//  SignInPresenter.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation
import Firebase
import FirebaseFirestore
protocol SignInPresenterDelegate: NSObject {
    func showUserRegiter(_ email: String, password: String)
    
}
class SignInPresenter {
    private weak var view: SignInPresenterDelegate?
    private var users = [UserRespone]()
    private var currentUser: UserRespone?
    private let db = Firestore.firestore()
    init(with view: SignInPresenterDelegate) {
        self.view = view
    }

    func fetchUser() {
        db.collection("user").getDocuments() { (querySnapshot, error) in
            if error != nil {
                print("vuongdv",error!.localizedDescription)
            }
            else {
                guard let querySnapshot = querySnapshot else { return }
                for doc in querySnapshot.documents {
                let value = UserRespone(dict: doc.data())
                self.users.append(value)
                }
            }
        }
    }
    
    func validateEmailPassword(_ email: String, _ password: String, completion: (_ currentUser: UserRespone?, Bool) -> Void) {
        var currentUser: UserRespone?
        var isvalid: Bool = false
        users.forEach { user in
            if user.email == email && user.password == password {
                currentUser = user
                isvalid = true
            }
        }
        completion(currentUser, isvalid)
    }
    
    func userData() -> [UserRespone] {
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
