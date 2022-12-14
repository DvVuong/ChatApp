//
//  ListUserPresenter.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/7/22.
//

import Foundation
import FirebaseFirestore
protocol ListUserPresenterDelegate: NSObject {
    func showSearchUser()
    func deleteUser(at index: Int)
}
class ListUserPresenter {
    private weak var view: ListUserPresenterDelegate?
    private var db = Firestore.firestore()
    var users = [User]()
    private var finalUser = [User]()
    private var currentUser: User?
    private var allMessages = [Message]()
    private var message = [String: Message]()
    private var lastMessage = [Message]()
    private var temparr = [Message]()
    private var messageKey = [String: Message]()
    init(with view: ListUserPresenterDelegate, data: User) {
        self.view = view
        self.currentUser = data
    }
    func fetchUser(_ completed: @escaping() -> Void) {
        guard let currentID = currentUser?.id else { return }
        db.collection("user").getDocuments{ querySnapshot, error in
            if error != nil {return}
            guard let querySnapshot = querySnapshot else {return}
            self.users.removeAll()
            for doc in querySnapshot.documents {
                let value = User(dict: doc.data())
                if currentID != value.id {
                    self.users.append(value)
                }
                self.finalUser = self.users
            }
            completed()
        }
    }
    
    func fetchMessageForUser( completed: @escaping () -> Void) {
        self.message.removeAll()
        self.allMessages.removeAll()
        guard let senderID = currentUser?.id else  { return }
        db.collection("message").addSnapshotListener { querySnapshot, error in
            if error != nil { return }
            guard let document = querySnapshot?.documentChanges else { return }
            
            for doc in document {
                if doc.type == .added {
                    let message = Message(dict: doc.document.data())
                    self.allMessages.append(message)
                }
            }
            
            self.users.forEach { user in
                self.temparr.removeAll()
                self.allMessages.forEach { message in
                    if (message.sendId == user.id && message.receiverID == senderID)
                        || (message.sendId == senderID && message.receiverID == user.id){
                        self.temparr.append(message)
                        self.temparr = self.temparr.sorted{
                            $0.time < $1.time
                        }
                    }
                }
                self.message[user.id] = self.temparr.last
                self.messageKey["messageKey"] = self.temparr.last
            }
            completed()
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
    func usersId(_ index: Int) -> User? {
        return users[index]
    }
    func showMessageForUserId(_ id: String) -> Message? {
        return message[id]
    }
    func messageKeyForState() -> Message? {
        print(self.messageKey["messageKey"])
    return messageKey["messageKey"]
    }
    func currentUserId() -> User?{
        return currentUser
    }
    func numberOfUser() -> Int {
        return finalUser.count
    }
    func cellForUsers(at index: Int) -> User? {
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
