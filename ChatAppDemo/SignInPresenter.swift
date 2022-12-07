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
    
}
class SignInPresenter {
    private weak var view: SignInPresenterDelegate?
     var users = [UserRespone]()
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
                    self.users.append(value)
                }
            }
        }
    }
    func numberOfUser() -> Int {
        return users.count
    }
    func cellForUser(_ index: Int)  -> UserRespone? {
        if index >= 0 && index < numberOfUser() {
            return nil
        }
        return users[index]
    }
}
