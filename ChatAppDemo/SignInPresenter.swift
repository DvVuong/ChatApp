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
}
class SignInPresenter {
    private weak var view: SignInPresenterDelegate?
    private var users: UserRespone?
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
                for document in querySnapshot.documents {
                    let dictionary = document.data() as [String: Any]
                    let value = UserRespone(dict: dictionary)
                    self.users = value
                }
            }
        }
    }
    func validateEmailPassword(_ email: String, _ password: String, completion: () -> Void, Failure: () -> Void) {
        guard let  email = users?.email, let password = users?.password else { return }
        if email == email, password == password {
            completion()
        }else {
            Failure()
        }
        
    }
    
}
