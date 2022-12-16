//
//  ResgiterPresenter.swift
//  ChatAppDemo
//
//  Created by BeeTech on 12/12/2022.
//

import Firebase

protocol ResgiterPresenterDelegate: NSObject {
    func validateName(_ result: String?)
    func validateEmail(_ result: String?)
    func validatePassword(_ result: String?)
    func validateConfirmPassword(_ result: String?)
    func isEnabledButton(_ result: Bool)
}
class ResgiterPresenterView {
    private weak var view: ResgiterPresenterDelegate?
    private var imgUrl: String = ""
    private var db = Firestore.firestore()
    private var user = [User]()
    private var nameError: String?
    private var emailError: String?
    private var passwordError: String?
    private var confirmPasswordError: String?
    private let _user = "user"
    
    
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
        fireBaseStorage.child("Avatar").child(imgKey).putData(img) {[weak self] (metadata, error) in
            if error != nil  {return}
            
            imgFloder.downloadURL {  url, error in
                if error != nil  {return}
                guard let url = url else  { return }
                self?.imgUrl = url.absoluteString
                print("self.imgUrl", self?.imgUrl)
            }
        }
    }
    func createAccount( email: String,  password: String, name: String) {
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
    
    func vaidateName(_ name: String) {
        if name.isEmpty {
            self.view?.validateName(State.emptyName.rawValue)
        }else  {
            self.view?.validateName(nil)
        }
        enableButton()
    }
    
    func validateEmail(_ email: String)  {
        if email.isEmpty {
         self.view?.validateEmail(State.emptyName.rawValue)
        } else if !isValidEmail(email: email) {
            self.view?.validateEmail(State.emailInvalidate.rawValue)
        } else {
            self.view?.validateEmail(nil)
        }
        enableButton()
    }
    func validatePassword(_ password: String) {
        if password.isEmpty {
            self.view?.validatePassword(State.emptPassword.rawValue)
        } else if password.count < 8 {
            self.view?.validatePassword(State.weakPassword.rawValue)
        }else {
            self.view?.validatePassword(nil)
        }
        enableButton()
        
    }
    
    func validateConfirmPassword(_ confirmPassword: String, password: String) {
        if confirmPassword != password {
            self.view?.validateConfirmPassword(State.passwordNotincorrect.rawValue)
        }else {
            self.view?.validateConfirmPassword(nil)
        }
        enableButton()
    }
    
    func enableButton() {
        if nameError == "" && emailError == "" && passwordError == "" && confirmPasswordError == "" {
            self.view?.isEnabledButton(true)
        } else {
            self.view?.isEnabledButton(false)
        }
        
    }
    
    
   private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func avatarUrl() -> String {
        return imgUrl
    }
    
    func setNameError(_ name: String?) {
        guard let name = name else { return }
        nameError = name
    }
    
    func setEmaiError(_ email: String) {
        emailError = email
    }
    
    func setPasswordError(_ password: String) {
        passwordError = password
    }
    
    func setConfirmPassword(_ confirmPassword: String) {
        confirmPasswordError = confirmPassword
    }
    
    
}
