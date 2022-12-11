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
    func showSearchUser()
}
class ListUserPresenter {
    private weak var view: ListUserPresenterDelegate?
    private var db = Firestore.firestore()
    var users = [UserRespone]()
    private var finalUser = [UserRespone]()
    private var currentUser: UserRespone?
    init(with view: ListUserPresenterDelegate) {
        self.view = view
    }
    convenience init(view: ListUserViewController, data: UserRespone) {
        self.init(with: view)
        self.currentUser = data
    }
    func getUser() {
        db.collection("user").getDocuments { querySnapshot, error in
            if error != nil {
                print("vuongdv", error!.localizedDescription)
            }else {
                guard let querySnapshot = querySnapshot else {
                    return
                }
                _ =  querySnapshot.documents.map { db in
                    let value = UserRespone(name: db["name"] as? String ?? ""
                                            , email: db["email"] as? String ?? ""
                                            , password: db["password"] as? String ?? ""
                                            , avatar: db["avatar"] as? String ?? ""
                                            , id: db["id"] as? String ?? "")
                    if self.currentUser?.id != db["id"] as? String ?? "" {
                        self.users.append(value)
                        self.finalUser = self.users
                        self.view?.showUsersList()
                    }
                }
            }
        }
    }
    func searchUser(_ text: String) {
        let lowcaseText = text.lowercased()
        if text.isEmpty {
            self.finalUser = self.users
        } else {
            self.finalUser = self.users.filter{$0.name
                                                .folding(options: .diacriticInsensitive, locale: nil)
                                                .lowercased()
                                                .contains(lowcaseText)
            }
        }
        view?.showSearchUser()
    }
    func currentUserId() -> UserRespone?{
        return currentUser
    }
    func numberOfUser() -> Int {
        return finalUser.count
    }
    func cellForUsers(at index: Int) -> UserRespone? {
        if index <= 0 && index > numberOfUser() {
            return nil
        }
        return finalUser[index]
    }
}
