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
    func showUserList()
    func showNewUser(email: String, password: String)
}
class SignInPresenter {
    private weak var view: SignInPresenterDelegate?
    private var users = [UserRespone]()
    private var currentUser: UserRespone?
    private let db = Firestore.firestore()
    init(with view: SignInPresenterDelegate) {
        self.view = view
    }

    func ftechUser() {
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
//                _ =  querySnapshot.documents.map { db in
//                    let value = UserRespone(name: db["name"] as? String ?? ""
//                                            , email: db["email"] as? String ?? ""
//                                            , password: db["password"] as? String ?? ""
//                                            , avatar: db["avatar"] as? String ?? ""
//                                            , id: db["id"] as? String ?? "")
//                    self.users.append(value)
//                }
            }
        }
    }
    func validateEmailPassword(_ email: String, _ password: String, completion: (_ currentUser: UserRespone?, Bool) -> Void) {
        var currentUser: UserRespone?
        var isvalid: Bool = false
        users.forEach { user in
            if user.email == email && user.password == password {
                currentUser = user
                //DataManager.shareInstance.saveUser(currentUser!)
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
    func getNewUser(_ email: String, password: String) {
        view?.showNewUser(email: email, password: password)
    }
}
