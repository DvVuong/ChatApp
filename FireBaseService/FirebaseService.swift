//
//  FirebaseService.swift
//  ChatAppDemo
//
//  Created by BeeTech on 16/12/2022.
//

import Firebase

class FirebaseService {
    
    static var share = FirebaseService()
    private let db = Firestore.firestore()
    private var users = [User]()
    private var messages = [Message]()
    private var imgUrl = ""
    private let _user = "user"
    private let _message = "message"
    private let _imageMessage = "ImageMessage"
    
    func fetchUser(_ completed: @escaping ([User]) -> Void) {
        self.users.removeAll()
        db.collection(_user).addSnapshotListener { (querySnapshot, error) in
            if error != nil {return}
            guard let querySnapshot = querySnapshot?.documentChanges else { return }
            querySnapshot.forEach { doc in
                if doc.type == .added || doc.type == .removed {
                    let value = User(dict: doc.document.data())
                    self.users.append(value)
                }
            }
            completed(self.users)
        }
    }
    
    func fetchMessage(_ completed: @escaping ([Message]) -> Void) {
        self.messages.removeAll()
        db.collection(_message).addSnapshotListener { querySnapshot, error in
            if error != nil { return }
            querySnapshot?.documentChanges.forEach({ doc in
                if doc.type == .added {
                    let message = Message(dict: doc.document.data())
                    self.messages.append(message)
                    self.messages = self.messages.sorted {
                        $0.time < $1.time
                    }
                }
            })
            completed(self.messages)
        }
    }
    
    func sendImageMessage(_ image: UIImage, receiverUser: User, senderUser: User) {
        let autoKey = self.db.collection(_message).document().documentID
        let storeRef = Storage.storage().reference()
        let imageKey = NSUUID().uuidString
        let image = image.jpegData(compressionQuality: 0.5)!
        let imgFolder = storeRef.child(_imageMessage).child(imageKey)
        storeRef.child(_imageMessage).child(imageKey).putData(image) { (metadat, error) in
            if error != nil { return}
            imgFolder.downloadURL { url, error in
                if error != nil {return}
                guard let url = url else {return}
                self.imgUrl = "\(url)"
                self.db.collection(self._message).document(autoKey).setData([
                    "nameSender": senderUser.name,
                    "sendId": senderUser.id,
                    "text": "",
                    "image": self.imgUrl,
                    "receivername": receiverUser.name,
                    "receiverID": receiverUser.id,
                    "time": Date().timeIntervalSince1970,
                    "read": false,
                    "messageKey": autoKey
                ])
            }
        }
    }
    
    func sendMessage(with message: String, receiverUser: User, senderUser: User) {
        let autoKey = self.db.collection(_message).document().documentID
        db.collection(_message).document(autoKey).setData([
            "nameSender": senderUser.name,
            "receivername": receiverUser.name,
            "text": message,
            "image": imgUrl,
            "sendId": senderUser.id,
            "receiverID": receiverUser.id,
            "time": Date().timeIntervalSince1970,
            "read": false,
            "messageKey": autoKey
        ])
    }
    
    func changeStateReadMessage(with messageKey: Message, completed: @escaping () -> Void) {
        self.db.collection(_message)
            .whereField("read", isEqualTo: false)
            .getDocuments { querydata, error in
                if error != nil { return }
                guard let doc = querydata?.documents else { return }
                
                doc.forEach { [weak self] doc in
                    let value = Message(dict: doc.data())
                    if messageKey.messageKey == value.messageKey {
                        self?.db.collection(self!._message).document(messageKey.messageKey).updateData(["read" : true])
                    }
                }
                completed()
            }
    }
    
}
