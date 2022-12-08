//
//  ListUserPresenter.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/7/22.
//

import Foundation
import FirebaseFirestore
protocol ListUserPresenterDelegate: NSObject {
    func showUsersList()
}
class ListUserPresenter {
    private weak var view: ListUserPresenterDelegate?
    private var db = Firestore.firestore()
    var users = [UserRespone]()
    private var finalUser = [UserRespone]()
    var currentUser: UserRespone?
    init(with view: ListUserPresenterDelegate) {
        self.view = view
    }
    func getUser() {
        db.collection("user").getDocuments { querySnapshot, error in
            if error != nil {
                print("vuongdv", error!.localizedDescription)
            }else {
                guard let querySnapshot = querySnapshot else {
                    return
                }
                for document in querySnapshot.documents {
                    let dictionary = document.data()
                    let value = UserRespone(dict: dictionary)
                    if self.currentUser?.id != value.id {
                        self.users.append(value)
                        self.view?.showUsersList()
                    }
                }
            }
        }
    }
    func searchUser(_ text: String) {
        self.finalUser = self.users
        if text.isEmpty {
            self.finalUser = self.users
        } else {
            self.finalUser = self.users.map({$0.name.})
        }
    }
    func numberOfUser() -> Int {
        return users.count
    }
    func cellForUsers(at index: Int) -> UserRespone? {
        if index <= 0 && index > numberOfUser() {
            return nil
        }
        return users[index]
    }
}
