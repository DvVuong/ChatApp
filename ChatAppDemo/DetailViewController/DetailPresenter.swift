//
//  DetailPresenterView.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import Firebase

protocol DetailPresenterViewDelegate: NSObject {
    func showMessage()
}

class DetailPresenter {
    private weak var view: DetailPresenterViewDelegate?
    private var imgUrl:String = ""
    private var currentUser: User?
    private var receiverUser: User?
    private var messages :[Message] = []
    private var db = Firestore.firestore()
    private var messageKey: Message?
    private var stateUser = [User]()
    private let _message = "message"
    
    init(with view: DetailPresenterViewDelegate, data: User, currentUser: User, messageKey: Message?) {
        self.view = view
        self.receiverUser = data
        self.currentUser = currentUser
        self.messageKey = messageKey
    }

    func sendMessage(with message: String) {
        guard let receiverUser = receiverUser else { return }
        guard let senderUser = currentUser else  {  return }
        FirebaseService.share.sendMessage(with: message, receiverUser: receiverUser, senderUser: senderUser)
        
    }
    func sendImageMessage(with image: UIImage) {
        guard let receiverUser = receiverUser else { return }
        guard let senderUser = currentUser else  {  return }
        FirebaseService.share.sendImageMessage(image, receiverUser: receiverUser, senderUser: senderUser)
        
    }
    
    func changeStateUser(_ completed:@escaping ([User]?) -> Void) {
        self.stateUser.removeAll()
        guard let reciverUser = receiverUser else  {return}
        FirebaseService.share.fetchUser { [weak self] user in
            self?.stateUser.removeAll()
            user.forEach { user in
                if user.id == reciverUser.id {
                    self?.stateUser.append(user)
                }
            }
            completed(self?.stateUser)
        }
    }

    func getCurrentUserID() -> String? {
        guard let id = currentUser?.id else { return nil }
        return id
    }
    
    func fetchMessage() {
        guard let reciverUser = receiverUser else {return}
        guard let senderUser = self.currentUser else { return }
        self.messages.removeAll()
        self.db.collection(_message).addSnapshotListener { [weak self] querySnapshot, error in
            if error != nil {return}
            querySnapshot?.documentChanges.forEach({ [weak self] docChange in
                if docChange.type == .added {
                    let data = Message(dict: docChange.document.data())
                    if ( data.receiverID == reciverUser.id && data.sendId == senderUser.id)
                        || (data.receiverID == senderUser.id && data.sendId == reciverUser.id) {
                        self?.messages.append(data)
                        guard var message = self?.messages else {return}
                        message = message.sorted {
                            $0.time < $1.time
                        }
                    }
                }
                self?.view?.showMessage()
            })
        }
    }
    
    func getNumberOfMessage() -> Int {
        return messages.count
    }
    func getCellForMessage(at index: Int) -> Message {
        return messages[index]
    }
    func getMessage(_ index: Int) -> Message {
        return messages[index]
    }
    
    func getReciverUser() -> [User] {
        return stateUser
    }
}
