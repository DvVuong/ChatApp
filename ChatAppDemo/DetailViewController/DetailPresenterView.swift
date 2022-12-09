//
//  DetailPresenterView.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
protocol DetailPresenterViewDelegate: NSObject {
    func showMessage()
}
class DetailPresenterView {
    private weak var view: DetailPresenterViewDelegate?
    private var imgUrl:String = ""
    var receiverID: String = ""
    var receivername: String = ""
    var currentUser: UserRespone?
    var message:[MessageRespone] = []
    private weak var db = Firestore.firestore()
    init(with view: DetailPresenterViewDelegate) {
        self.view = view
    }
    func sendMessage(with message: String) {
        let autoKey = self.db?.collection("Message").document().documentID
        guard let keyDocument = autoKey else { return }
        if #available(iOS 15, *) {
            db!.collection("Message").document(keyDocument).setData([
                "nameSender": self.currentUser!.name,
                "receivername": receivername,
                "text": message,
                "image": imgUrl,
                "sendId": self.currentUser!.id,
                "receiverID": receiverID,
                "time": Date.now.timeIntervalSince1970
            ])
        }
    }
    @available(iOS 15, *)
    func sendImageMessage(with image: UIImage) {
        let storeRef = Storage.storage().reference()
        let imageKey = NSUUID().uuidString
        let image = image.jpegData(compressionQuality: 0.5)!
        let imgFolder = storeRef.child("ImageMessage").child(imageKey)
        storeRef.child("ImageMessage").child(imageKey).putData(image) { (metadat, error) in
            if error != nil { return}
                imgFolder.downloadURL { url, error in
                    if error != nil {return}
                    guard let url = url else {return}
                    self.imgUrl = "\(url)"
                        let autoKey = self.db?.collection("Message").document().documentID
                        guard let keyDocument = autoKey else { return }
                        self.db!.collection("Message").document(keyDocument).setData([
                            "nameSender": self.currentUser!.name,
                            "sendId": self.currentUser!.id,
                            "text": "",
                            "image": self.imgUrl,
                            "receivername": self.receivername,
                            "receiverID": self.receiverID,
                            "time": Date.now.timeIntervalSince1970
                        ])
                    }
                }
            }
    
    func getMessage() {
        message.removeAll()
        self.db?.collection("Message").getDocuments(completion: { querySnapshot, error in
            if error != nil {
                print("vuongdv", error!.localizedDescription)
            }else {
                guard let document = querySnapshot?.documents else { return }
                for item in document {
                    let value = MessageRespone(dict: item.data())
                    self.message.append(value)
                    self.sortMessage()
                    self.view?.showMessage()
                }
            }
        })
    }
    func listentDataChange() {
        db?.collection("Message").document().addSnapshotListener({ doccumentSnapshot, error in
            guard let document = doccumentSnapshot else { return }
            let data = document.data()
            print("vuongdv", data as Any)
        })
        
        
    }
    func sortMessage() {
        var timer: [Double] = []
        var messageBytime = [MessageRespone]()
        self.message.forEach { message in
            timer.append(message.time)
        }
        timer.sort{
            $0 < $1
        }
        timer.forEach { time in
            message.forEach { message in
                if message.time == time {
                    messageBytime.append(message)
                }
            }
        }
        self.message = messageBytime
    }
    func numberOfMessage() -> Int {
        return message.count
    }
    func cellForMessage(at index: Int) -> MessageRespone {
        return message[index]
    }
}
