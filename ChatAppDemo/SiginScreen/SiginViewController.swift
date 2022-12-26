//
//  ViewController.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import ZaloSDK
import GoogleSignIn

class SiginViewController: UIViewController {
    @IBOutlet private weak var tfEmail: CustomTextField!
    @IBOutlet private weak var tfPassword: CustomTextField!
    @IBOutlet private weak var btSaveData: CustomButton!
    @IBOutlet private weak var btSigin: UIButton!
    @IBOutlet weak var btSignup: CustomButton!
    
    @IBOutlet weak var btLoginFaceBook: FBLoginButton!
    
    private var selected: Bool = false
    lazy var presenter = SignInPresenter(with: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.fetchUser() 
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupUI() {
        setupUITextField()
        setupBtSigin()
        setupBtSaveData()
        setupBtSignUp()
        setupButtonLoginFaceBook()
    }
    
    private func setupUITextField() {
        //
        tfEmail.textColor = .white
        
        tfEmail.text = "long@gmail.com"
        tfPassword.text = "123456"
        // TextField Email
        tfEmail.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [.foregroundColor: UIColor.white])
        
        // TextField Password
        tfPassword.textColor = .white
        tfPassword.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes: [.foregroundColor: UIColor.white])
        
}
    private func setupButtonLoginFaceBook() {
        btLoginFaceBook.setTitle("", for: .normal)
        btLoginFaceBook.addTarget(self, action: #selector(loginWithFacebook(_:)), for: .touchUpInside)
    }
    
    private func setupBtSigin() {
        btSigin.layer.cornerRadius = 8
        btSigin.addTarget(self, action: #selector(didTapSigin(_:)), for: .touchUpInside)
    }
    
    private func setupBtSaveData() {
        btSaveData.setTitle("", for: .normal)
        btSaveData.addTarget(self, action: #selector(didTapSaveData(_:)), for: .touchUpInside)
    }
    
    private func setupBtSignUp() {
        btSignup.addTarget(self, action: #selector(didTapSigup(_:)), for: .touchUpInside)
    }
    
    // MARK: Action
    @objc func didTapSaveData(_ sender: UIButton) {
        if sender === btSaveData {
            selected = !selected
            if selected  {
                btSaveData.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                
            }else {
                btSaveData.setImage(UIImage(systemName: "square"), for: .normal)
            }
    }
}
    @objc func didTapSigin(_ sender: UIButton) {
        presenter.validateEmailPassword(tfEmail.text!, tfPassword.text!) { currentUser, bool in
            if bool {
                guard let currentUser = currentUser else { return }
                let vc = ListUserViewController.instance(currentUser)
                presenter.changeStateUser(currentUser)
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                return
            }
        }

    }
   
    @objc func didTapSigup(_ sender: UIButton) {
        let vc  = RegisterViewcontroller.instance(presenter.getUserData())
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginWithFacebook(_ sender: Any) {
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
        } else {
            btLoginFaceBook.delegate = self
            btLoginFaceBook.permissions = ["public_profile", "email"]
        }
    }
    
    @IBAction private func didTapLoginWithGoogle(_ sender: Any) {
        presenter.loginWithGoogle(self) {[weak self] user in
            let vc = ListUserViewController.instance(user)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction private func loginWithZalo(_ sender: Any) {
        presenter.loginZalo(self) {[weak self] user in
            guard let user = user else {return}
            let vc = ListUserViewController.instance(user)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SiginViewController: SignInPresenterDelegate {
    func showUserRegiter(_ email: String, password: String) {
        self.tfEmail.text = email
        self.tfPassword.text = password
    }

}

extension SiginViewController: RegisterViewcontrollerDelegate {
    func callBackAccountResgiter(_ vc: RegisterViewcontroller, email: String, password: String) {
        self.presenter.showUserResgiter(email, password: password)
        self.navigationController?.popViewController(animated: true)
    }
}

extension SiginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        presenter.loginWithFacebook(loginButton, didCompleteWith: result, error: error) {[weak self] user in
            self?.presenter.validateSocialMediaAccount(user.email, completion: { socialMediaUser, bool in
                if bool {
                    guard let socialMediaUser = socialMediaUser else {return}
                    let vc = ListUserViewController.instance(socialMediaUser)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("LogOut")
    }
}

