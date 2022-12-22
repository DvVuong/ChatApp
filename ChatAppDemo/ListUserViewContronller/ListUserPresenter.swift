//
//  ListUserPresenter.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/7/22.
//

import Firebase

protocol ListUserPresenterDelegate: NSObject {
    func showSearchUser()
    func showStateMassage()
    func deleteUser(at index: Int)
}

class ListUserPresenter {
    // properties phai set private
    private weak var view: ListUserPresenterDelegate?
    private var db = Firestore.firestore()
    private var reciverUser = [User]()
    private var finalUser = [User]()
    private var currentUser: User?
    private var message = [Message]()
    private var allMessages = [String: Message]()
    private var lastMessage = [Message]()
    private var temparr = [Message]()
    private var messageByUser = [String: Message]()
    
    init(with view: ListUserPresenterDelegate, data: User) {
        self.view = view
        self.currentUser = data
    }
    
    func fetchUser(_ completed: @escaping() -> Void) {
        guard let currentID = currentUser?.id else { return }
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            if error != nil {return}
            guard let snapshot = querySnapshot else { return }
            self.reciverUser.removeAll()
            snapshot.documents.forEach { doc in
                let value = User(dict: doc.data())
                if value.id != currentID {
                    self.reciverUser.append(value)
                    self.finalUser = self.reciverUser
                }
                
            }
            completed()
        }
    }
    
    func fetchMessageForUser( completed: @escaping () -> Void) {
        guard let currentUser = currentUser else {return}
        reciverUser.forEach { user in
            
            FirebaseService.share.fetchMessage(user, senderUser: currentUser) {[weak self] message in
                message.forEach { mess in
                    if mess.receiverID == user.id || mess.receiverID == currentUser.id {
                        self?.allMessages[user.id] = mess
                        self?.message = Array((self?.allMessages.values)!)
                        self?.message = self?.message.sorted {
                            return $0.time < $1.time
                        } ?? []
                    }
                    completed()
                }
            }
        }
    }
    func setState(_ sender: User, reciverUser: User) {
        FirebaseService.share.changeStateReadMessage(sender, revicerUser: reciverUser)
        self.view?.showStateMassage()
    }
    
    func searchUser(_ text: String) {
        let lowcaseText = text.lowercased()
        if text.isEmpty {
            self.finalUser = self.reciverUser
        } else {
            self.finalUser = self.reciverUser.filter{$0.name
                    .folding(options: .diacriticInsensitive, locale: nil)
                    .lowercased()
                    .contains(lowcaseText)
            }
        }
        view?.showSearchUser()
    }
    
    func getUsers(_ index: Int) -> User? {
        return reciverUser[index]
    }

    func getMessageKeyForState(_ index: Int) -> Message? {
        return message[index]
    }
    
    func getcurrentUser() -> User?{
        return currentUser
    }
    
    func getNumberOfUser() -> Int {
        return finalUser.count
    }
    
    func getNumberOfMessage() -> Int {
        
        return message.count
    } 
    
    func cellForMessage(_ index: Int) -> Message? {
        return message[index]
    } 
    
    func getAllMessage(_ id: String) -> Message? {
        return allMessages[id]
    }
    
    func getCellForUsers(at index: Int) -> User? {
        if index < 0 && index > getNumberOfUser() {
            return nil
        }
        return finalUser[index]
    }
    
    func deleteUser(_ index: Int, completion:() -> Void) {
        self.finalUser.remove(at: index)
        completion()
    }
    
}
