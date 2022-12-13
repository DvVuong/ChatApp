//
//  ViewController.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class SiginViewController: UIViewController {
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPassword: UITextField!
    @IBOutlet private weak var btSigin: UIButton!
    @IBOutlet private weak var viewEmail: UIView!
    @IBOutlet private weak var viewPassword: UIView!
    @IBOutlet private weak var viewSignUp: UIView!
    @IBOutlet private weak var btSignUp: UIButton!
    @IBOutlet private weak var btCheckForSaveData: UIButton!
    
    private var selected: Bool = false
    lazy var presenter = SignInPresenter(with: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchUser()
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
        setupLable()
        setupView()
        setupUITextField()
        setupBtSigin()
        setupBtSaveData()
        setupBtSignUp()
    }
    private func setupView() {
        viewEmail.layer.cornerRadius = 8
        viewPassword.layer.cornerRadius = 8
        viewSignUp.layer.cornerRadius = 8
        tfEmail.text = "long@gmail.com"
        tfPassword.text = "123456"
    }
    
    private func setupLable() {
        lbTitle.text = "Message"
        lbTitle.textAlignment = .center
    }
    private func setupUITextField() {
        // Email
         let email = presenter.showUserInfo().email
            if email.isEmpty {
                tfEmail.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [.foregroundColor: UIColor.blue])
            } else {
                tfEmail.text = email
            }
        // Password
       let password = presenter.showUserInfo().password
           if password.isEmpty {
               tfPassword.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes: [.foregroundColor: UIColor.brown])
               tfPassword.isSecureTextEntry = true
           } else {
               tfPassword.text = password
               tfPassword.isSecureTextEntry = true
           }
}
    private func setupBtSigin() {
        btSigin.layer.cornerRadius = 8
        btSigin.addTarget(self, action: #selector(didTapSigin(_:)), for: .touchUpInside)
    }
    private func setupBtSaveData() {
        btCheckForSaveData.setTitle("", for: .normal)
        btCheckForSaveData.addTarget(self, action: #selector(didTapSaveData(_:)), for: .touchUpInside)
        
    }
    @objc func didTapSaveData(_ sender: UIButton) {
        if sender === btCheckForSaveData {
            selected = !selected
            if selected  {
                btCheckForSaveData.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                
            }else {
                btCheckForSaveData.setImage(UIImage(systemName: "square"), for: .normal)
            }
    }
}
    @objc func didTapSigin(_ sender: UIButton) {
        presenter.fetchUser()
        presenter.validateEmailPassword(tfEmail.text!, tfPassword.text!) { currentUser, bool in
            if bool {
                guard let currentUser = currentUser else { return }
                let vc = ListUserViewController.instance(currentUser)
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                return
            }
        }

    }
    private func setupBtSignUp() {
        btSignUp.addTarget(self, action: #selector(didTapSigup(_:)), for: .touchUpInside)
    }
    @objc func didTapSigup(_ sender: UIButton) {
        let vc  = RegisterViewcontroller.instance(presenter.userData())
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
        presenter.showUserResgiter(email, password: password)
        navigationController?.popViewController(animated: true)
    }
}
