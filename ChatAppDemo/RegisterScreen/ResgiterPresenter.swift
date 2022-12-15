//
//  ResgiterPresenter.swift
//  ChatAppDemo
//
//  Created by BeeTech on 12/12/2022.
//

import Firebase

protocol ResgiterPresenterDelegate: NSObject {
    func validateAccountResgiter(_ result: String)
   
}
class ResgiterPresenterView {
    private weak var view: ResgiterPresenterDelegate?
    private var imgUrl: String = ""
    private var db = Firestore.firestore()
    private var user = [User]()
    
    init(with view: ResgiterPresenterDelegate) {
        self.view = view
    }
    convenience init(view: ResgiterPresenterDelegate, user: [User]) {
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
            "name": name,
            "isActive": false
        ])
    }
    func validateEmaiPassoword(_ email: String, password: String, confirmPassword: String, name: String, avatar: String, completion:(Bool) -> Void)  {
        var isvalid: Bool = true
        if name.isEmpty {
            isvalid = false
            self.view?.validateAccountResgiter(State.emptyName.rawValue)
        }
        else if avatar.isEmpty {
            isvalid = false
            self.view?.validateAccountResgiter(State.emptyAvatarUrl.rawValue)
        }
       else if email.isEmpty {
            isvalid = false
            self.view?.validateAccountResgiter(State.emptyEmail.rawValue)
            return
        }
        else if password.isEmpty {
            isvalid = false
            self.view?.validateAccountResgiter(State.emptPassword.rawValue)
            return
        }
        else if password != confirmPassword {
            isvalid = false
            self.view?.validateAccountResgiter(State.passwordNotincorrect.rawValue)
        }
        self.user.forEach { user in
            if email == user.email {
                self.view?.validateAccountResgiter(State.emailAlreadyExist.rawValue)
                isvalid = false
            }
        }
        completion(isvalid)
    }
    func avatarUrl() -> String {
        return imgUrl
    }
    
}
