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
    @IBOutlet private weak var tfPasswork: UITextField!
    @IBOutlet private weak var btSigin: UIButton!
    @IBOutlet private weak var viewEmail: UIView!
    @IBOutlet private weak var viewPasswork: UIView!
    @IBOutlet private weak var viewSignUp: UIView!
    @IBOutlet private weak var btSignUp: UIButton!
    @IBOutlet private weak var btCheckForSaveData: UIButton!
    
    private var selected: Bool = true
    lazy var presenter = SignInPresenter(with: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.ftechUser()
    }
    override func viewWillAppear(_ animated: Bool) {
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
        
        setupLable()
        setupView()
        setupUITextField()
        setupBtSigin()
        setupBtSaveData()
    }
    private func setupView() {
        viewEmail.layer.cornerRadius = 8
        viewPasswork.layer.cornerRadius = 8
        viewSignUp.layer.cornerRadius = 8
    }
    
    private func setupLable() {
        lbTitle.text = "Message"
        lbTitle.textAlignment = .center
    }
    private func setupUITextField() {
        // Email
         let email = presenter.showUserInfo().email
            print("vuongdv", email)
            if email.isEmpty {
                tfEmail.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [.foregroundColor: UIColor.blue])
                print("vuongdv", email)
            } else {
                tfEmail.text = email
            }
        // Password
       let password = presenter.showUserInfo().password
           print("vuongdv", password)
           if password.isEmpty {
               tfPasswork.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes: [.foregroundColor: UIColor.brown])
               tfPasswork.isSecureTextEntry = true
               print("vuongdv", password)
           } else {
               tfPasswork.text = password
               tfPasswork.isSecureTextEntry = true
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
        presenter.validateEmailPassword(tfEmail.text!, tfPasswork.text!) { currentUser in
            let vc = ListUserViewController.instance(currentUser)
            navigationController?.pushViewController(vc, animated: true)
        } Failure: {
            return
        }
    }
    private func setupBtSignUp() {
        btSignUp.addTarget(self, action: #selector(didTapSigup(_:)), for: .touchUpInside)
    }
    @objc func didTapSigup(_ sender: UIButton) {
        
    }
}
extension SiginViewController: SignInPresenterDelegate {
    func showUserList() {
        
    }
}
