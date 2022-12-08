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
        let keyDb = self.receiverID
        let autoKey = self.db?.collection("Message").document().documentID
        guard let keyDocument = autoKey else { return }
        db!.collection("Message").document(keyDocument).setData([
            "nameSender": self.currentUser!.name,
            "receivername": receivername,
            "text": message,
            "image": imgUrl,
            "sendId": self.currentUser!.id,
            "receiverID": receiverID
        ]) { error in
            if let error = error {
                print("vuongdv", error.localizedDescription)
            }else {
                print("vuongdv", "Send successfully")
            }
        }
    }
    func sendImageMessage(with image: UIImage) {
        let storeRef = Storage.storage().reference()
        let imageKey = NSUUID().uuidString
        let image = image.jpegData(compressionQuality: 0.5)!
        let imgFolder = storeRef.child("ImageMessage").child(imageKey)
        storeRef.child("ImageMessage").child(imageKey).putData(image) { (metadat, error) in
            if error != nil {
                print("vuongdv",error!.localizedDescription)
            }else {
                imgFolder.downloadURL { url, error in
                    if error != nil {
                        print("vuongdv", error!.localizedDescription)
                    }
                    else {
                        guard let url = url else {
                            return
                        }
                        self.imgUrl = "\(url)"
                        let keyDb = self.receiverID
                        let autoKey = self.db?.collection("Message").document().documentID
                        guard let keyDocument = autoKey else { return }
                        self.db!.collection("Message").document(keyDocument).setData([
                            "nameSender": self.currentUser!.name,
                            "receivername": self.receivername,
                            "text": "",
                            "image": self.imgUrl,
                            "sendId": self.currentUser!.id,
                            "receiverID": self.receiverID
                        ]) { error in
                            if let error = error {
                                print("vuongdv", error.localizedDescription)
                            }else {
                                print("vuongdv", "Send successfully")
                            }
                        }
                    }
                }
            }
        }
    }
    func getMessage() {
        self.db?.collection("Message").getDocuments(completion: { querySnapshot, error in
            if error != nil {
                print("vuongdv", error!.localizedDescription)
            }else {
                guard let document = querySnapshot?.documents else { return }
                for item in document {
                    let value = MessageRespone(dict: item.data())
                    self.message.append(value)
                    self.view?.showMessage()
                }
            }
        })
    }
    func numberOfMessage() -> Int {
        return message.count
    }
    func cellForMessage(at index: Int) -> MessageRespone? {
        guard index <= 0 && index > numberOfMessage() else {
            return nil
        }
        return message[index]
    }
}
