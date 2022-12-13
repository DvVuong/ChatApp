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
    func deleteUser(at index: Int)
}
class ListUserPresenter {
    private weak var view: ListUserPresenterDelegate?
    private var db = Firestore.firestore()
    var users = [UserRespone]()
    private var finalUser = [UserRespone]()
    private var currentUser: UserRespone?
    private var allMessages = [MessageRespone]()
    private var message = [String: MessageRespone]()
    private var lastMessage = [MessageRespone]()
    init(with view: ListUserPresenterDelegate) {
        self.view = view
    }
    convenience init(view: ListUserViewController, data: UserRespone) {
        self.init(with: view)
        self.currentUser = data
    }
    func getUser(_ completed: @escaping() -> Void) {
        self.message.removeAll()
        guard let currentID = currentUser?.id else { return }
        db.collection("user").getDocuments { querySnapshot, error in
            if error != nil {
                print("vuongdv", error!.localizedDescription)
            }else {
                guard let querySnapshot = querySnapshot else {
                    return
                }
                for doc in querySnapshot.documents {
                    let value = UserRespone(dict: doc.data())
                    if currentID != value.id {
                        self.users.append(value)
                        self.finalUser = self.users
                    }
                }
//                querySnapshot.documents.map { db in
//                    let value = UserRespone(name: db["name"] as? String ?? ""
//                                            , email: db["email"] as? String ?? ""
//                                            , password: db["password"] as? String ?? ""
//                                            , avatar: db["avatar"] as? String ?? ""
//                                            , id: db["id"] as? String ?? "")
//                    if self.currentUser?.id != db["id"] as? String ?? "" {
//                        self.users.append(value)
//                        self.finalUser = self.users
//                    }
//                }
                completed()
            }
        }
    }
    func getMessageForUser( completed: @escaping () -> Void) {
        self.allMessages.removeAll()
        guard let senderID = currentUser?.id else  { return }
        db.collection("message").addSnapshotListener { querySnapshot, error in
            if error != nil { return }
            guard let document = querySnapshot?.documents else { return }
            for doc in document {
                let message = MessageRespone(dict: doc.data())
                self.allMessages.append(message)
            }
            var temparr = [MessageRespone]()
            self.users.forEach { user in
                self.allMessages.forEach { message in
                    if (message.sendId == user.id && message.receiverID == senderID)
                        || (message.sendId == senderID && message.receiverID == user.id){
                        temparr.append(message)
                        self.allMessages = self.allMessages.sorted{
                            $0.time < $1.time
                        }
                    }
                    self.message[user.id] = temparr.last
                }
            }
            completed()
        }
    }
    func showMessageForUser(_ id: String) -> MessageRespone? {
        return message[id]
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
    func deleteUser(_ index: Int, completion: @escaping () -> Void) {
        self.finalUser.remove(at: index)
        completion()
    }
}
