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
    private let _avatar = "Avatar"
    
    func fetchUser(_ completed: @escaping ([User]) -> Void) {
        self.users.removeAll()
        db.collection(_user).addSnapshotListener {[weak self] (querySnapshot, error) in
            if error != nil {return}
            guard let querySnapshot = querySnapshot?.documentChanges else { return }
            self?.users.removeAll()
            querySnapshot.forEach { doc in
                if doc.type == .added || doc.type == .modified  {
                    let value = User(dict: doc.document.data())
                    self?.users.append(value)
                }
            }
            completed(self?.users ?? [])
        }
    }
    
    func fetchMessage(_ completed: @escaping ([Message]) -> Void) {
        self.messages.removeAll()
        db.collection(_message).addSnapshotListener { querySnapshot, error in
            if error != nil { return }
            querySnapshot?.documentChanges.forEach({ [weak self] doc in
                if doc.type == .added || doc.type == .modified {
                    let message = Message(dict: doc.document.data())
                    self?.messages.append(message)
                    self?.messages = self?.messages.sorted {
                        $0.time < $1.time
                    } ?? []
                }
            })
            completed(self.messages)
        }
    }
    
    func sendImageMessage(_ image: UIImage, receiverUser: User, senderUser: User) {
        let autoKey = self.db.collection(_message).document().documentID
        let storeRef = Storage.storage().reference()
        let imageKey = NSUUID().uuidString
    
        guard  let image = image.jpegData(compressionQuality: 0.5) else {return}
        let imgFolder = storeRef.child(_imageMessage).child(imageKey)
        storeRef.child(_imageMessage).child(imageKey).putData(image) { [weak self] (metadat, error) in
            if error != nil { return}
            imgFolder.downloadURL { url, error in
                if error != nil {return}
                guard let url = url else {return}
                self?.imgUrl = "\(url)"
                self?.db.collection(self?._message ?? "").document(autoKey).setData([
                    "nameSender": senderUser.name,
                    "sendId": senderUser.id,
                    "text": "",
                    "image": self?.imgUrl as Any,
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
    
    func changeStateReadMessage(_ senderUser: User, revicerUser: User) {
        self.db.collection(_message)
            .whereField("read", isEqualTo: false)
            .getDocuments { querydata, error in
                if error != nil { return }
                guard let doc = querydata?.documents else { return }
                doc.forEach { [weak self] doc in
                    let value = Message(dict: doc.data())
                    if value.sendId == revicerUser.id && value.receiverID == senderUser.id {
                        self?.db.collection(self!._message).document(value.messageKey).updateData(["read" : true])
                    }
                }
            }
    }
    
    func createAccount(email: String,  password: String, name: String) {
        let autoKey = self.db.collection(_user).document().documentID
        var imgUrl = ""
        if self.imgUrl.isEmpty {
            imgUrl = "https://firebasestorage.googleapis.com/v0/b/chatapp-9c3f7.appspot.com/o/Avatar%2FplaceholderAvatar.jpeg?alt=media&token=7d7eab97-abae-4bc9-8ed7-35569c485423"
            self.db.collection("user").document(autoKey).setData([
                "email": email,
                "password": password,
                "avatar": imgUrl,
                "id": autoKey,
                "name": name,
                "isActive": false
            ])
            return
        }
        
        imgUrl = self.imgUrl
        self.db.collection(_user).document(autoKey).setData([
            "email": email,
            "password": password,
            "avatar": imgUrl,
            "id": autoKey,
            "name": name,
            "isActive": false
        ])
    }
    
    func fetchAvatarUrl(_ image: UIImage) {
        let fireBaseStorage = Storage.storage().reference()
        guard let img = image.jpegData(compressionQuality: 0.5) else {return}
        let imgKey = NSUUID().uuidString
        let imgFloder = Storage.storage().reference().child(_avatar).child(imgKey)
        fireBaseStorage.child(_avatar).child(imgKey).putData(img) {[weak self] (metadata, error) in
            if error != nil  {return}
            imgFloder.downloadURL {  url, error in
                if error != nil  {return}
                guard let url = url else  { return }
                self?.imgUrl = url.absoluteString
            }
        }
    }
    
    func changeStateActiveForUser(_ currentUser: User) {
        self.db.collection(_user)
        self.db.collection(self._user).document(currentUser.id).updateData(["isActive" : true])
    }
    
    func changeStateInActiveForUser(_ currentUser: User) {
        self.db.collection(_user)
        self.db.collection(self._user).document(currentUser.id).updateData(["isActive" : false])
    }
    
    func updateAvatar(_ currentUser: User) {
        self.db.collection(_user)
        self.db.collection(self._user).document(currentUser.id).updateData(["avatar" : self.imgUrl])
    }
    
    func updateName(_ currentUser: User, name: String) {
        self.db.collection(_user)
        self.db.collection(self._user).document(currentUser.id).updateData(["name" : name])
    }
    
    func updateEmail(_ currentUser: User, email: String) {
        self.db.collection(_user)
        self.db.collection(self._user).document(currentUser.id).updateData(["email" : email])
    }
    
    func updatePassword(_ currentUser: User, password: String) {
        self.db.collection(_user)
        self.db.collection(self._user).document(currentUser.id).updateData(["password" : password])
    }
}
