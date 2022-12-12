//
//  ResgiterPresenter.swift
//  ChatAppDemo
//
//  Created by BeeTech on 12/12/2022.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
protocol ResgiterPresenterDelegate: NSObject {
   
}
class ResgiterPresenterView {
    private weak var view: ResgiterPresenterDelegate?
    private var imgUrl: String = ""
    private  var db = Firestore.firestore()
    private var user = [UserRespone]()
    init(with view: ResgiterPresenterDelegate) {
        self.view = view
    }
    convenience init(view: ResgiterPresenterDelegate, user: [UserRespone]) {
        self.init(with: view)
        self.user = user
    }
    func sendImage(_ image: UIImage) {
        let fireBaseStorage = Storage.storage().reference()
        let img = image.jpegData(compressionQuality: 0.5)!
        let imgKey = NSUUID().uuidString
        let imgFloder = Storage.storage().reference().child("Avatar").child(imgKey)
        fireBaseStorage.child("Avatar").child(imgKey).putData(img) { (metadata, error) in
            if error != nil  {return}
            imgFloder.downloadURL {  url, error in
                if error != nil  {return}
                guard let url = url else  { return }
                self.imgUrl = url.absoluteString
            }
        }
    }
    func createAccount( email: String,  password: String, name: String) {
        let autoKey = self.db.collection("user").document().documentID
        self.db.collection("user").document(autoKey).setData([
            "email": email,
            "password": password,
            "avatar": self.imgUrl,
            "id": autoKey,
            "name": name
        ])
    }
    func validateEmaiPassoword(_ email: String, password: String, completion:(Bool) -> Void)  {
        var isvalid: Bool = true
        self.user.forEach { user in
            if email == user.email {
                isvalid = false
            }
        }
        completion(isvalid)
    }
    
}
