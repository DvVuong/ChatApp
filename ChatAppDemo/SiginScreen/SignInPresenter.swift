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
    private var users = [UserRespone]()
    var currentUser: UserRespone?
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
                    let dictionary = document.data()
                    let value = UserRespone(dict: dictionary)
                    self.users.append(value)
                    print(self.users)
                }
            }
        }
    }
    func validateEmailPassword(_ email: String, _ password: String, completion: (_ currentUser: UserRespone) -> Void, Failure: () -> Void) {
        
        var currentUser: UserRespone?
        users.forEach { user in
            if user.email == email && user.password == password {
                currentUser = user
                completion(currentUser!)
            }
            else {
                Failure()
            }
        }
    }
    
}
