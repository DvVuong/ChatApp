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
    private var messages: [Message] = []
    private var db = Firestore.firestore()
    private var messageKey: Message?
    private var stateUser = [User]()
    private let _message = "message"
    private let like = "👍"
    
    init(with view: DetailPresenterViewDelegate, data: User, currentUser: User) {
        self.view = view
        self.receiverUser = data
        self.currentUser = currentUser
        
    }

    func sendMessage(with message: String) {
        guard let receiverUser = receiverUser else { return }
        guard let senderUser = currentUser else  {  return }
        FirebaseService.share.sendMessage(with: message, receiverUser: receiverUser, senderUser: senderUser)
        
    }
    func sendImageMessage(with image: UIImage) {
        guard let receiverUser = receiverUser else { return }
        guard let senderUser = currentUser else  {  return }
        FirebaseService.share.setImageMessage(image, receiverUser: receiverUser, senderUser: senderUser)
        
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
    
    func fetchMessage() {
        guard let reciverUser = receiverUser else {return}
        guard let senderUser = self.currentUser else { return }
        self.messages.removeAll()
        FirebaseService.share.fetchMessage(reciverUser, senderUser: senderUser) { [weak self] message in
            message.forEach { mess in
                if mess.receiverID == reciverUser.id || mess.receiverID == senderUser.id {
                    self?.messages.append(mess)
                    self?.messages = self?.messages.sorted {
                        $0.time < $1.time
                    } ?? []
                }
            }
            self?.view?.showMessage()
        }
    }
    
    func sendLikeSymbols() {
        guard let receiverUser = receiverUser else { return }
        guard let senderUser = currentUser else  {  return }
        FirebaseService.share.sendMessage(with: like, receiverUser: receiverUser, senderUser: senderUser)
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
    
    func getReciverUserID() -> User? {
    
        return receiverUser
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
}
