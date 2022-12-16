//
//  ListUserPresenter.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/7/22.
//

import Firebase

protocol ListUserPresenterDelegate: NSObject {
    func showSearchUser()
    func deleteUser(at index: Int)
}

class ListUserPresenter {
    // properties phai set private
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
        FirebaseService.share.fetchUser { user in
            user.forEach { user in
                if currentID != user.id {
                    self.users.append(user)
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
        FirebaseService.share.fetchMessage { mess in
            self.allMessages.append(contentsOf: mess)
            
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
    func getUsersId(_ index: Int) -> User? {
        return users[index]
    }
    func getMessageForUserId(_ id: String) -> Message? {
        return message[id]
    }
    func getMessageKeyForState(_ id: String) -> Message? {
        return message[id]
    }
    func getcurrentUser() -> User?{
        return currentUser
    }
    func getNumberOfUser() -> Int {
        return finalUser.count
    }
    func getCellForUsers(at index: Int) -> User? {
        if index <= 0 && index > getNumberOfUser() {
            return nil
        }
        return finalUser[index]
    }
    func deleteUser(_ index: Int, completion:() -> Void) {
        self.finalUser.remove(at: index)
        completion()
    }
    
}
