//
//  ViewController.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPasswork: UITextField!
    @IBOutlet private weak var btSigin: UIButton!
    @IBOutlet private weak var viewEmail: UIView!
    @IBOutlet private weak var viewPasswork: UIView!
    @IBOutlet private weak var viewSignUp: UIView!
    @IBOutlet private weak var btSignUp: UIButton!

    lazy var presenter = SignInPresenter(with: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        presenter.ftechUser()
    }
    private func setupUI() {
        setupLable()
        setupView()
        setupUITextField()
        setupBtSigin()
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
        tfEmail.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [.foregroundColor: UIColor.blue])
        // Passwork
        tfPasswork.attributedPlaceholder = NSAttributedString(string: "Enter Your Passwork", attributes: [.foregroundColor: UIColor.brown])
    }
    private func setupBtSigin() {
        btSigin.layer.cornerRadius = 8
        btSigin.addTarget(self, action: #selector(didTapSigin(_:)), for: .touchUpInside)
    }
    @objc func didTapSigin(_ sender: UIButton) {
        for item in presenter.users {
            if tfEmail.text == item.email, tfPasswork.text == item.password {
                let vc = ListUserViewController.instance()
                
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                print("vuongdv","tai khoan khong ton tai")
            }
        }
    }
    private func setupBtSignUp() {
        btSignUp.addTarget(self, action: #selector(didTapSigup(_:)), for: .touchUpInside)
    }
    @objc func didTapSigup(_ sender: UIButton) {
        
    }
    


}
extension ViewController: SignInPresenterDelegate {
    
}
