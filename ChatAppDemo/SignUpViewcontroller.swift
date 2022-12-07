//
//  SignUpViewcontroller.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class SignUpViewcontroller: UIViewController {
    static func instance() -> SignUpViewcontroller {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpScreen") as! SignUpViewcontroller
        return vc
    }
    @IBOutlet private weak var viewEmail: UIView!
    @IBOutlet private weak var viewPasswork: UIView!
    @IBOutlet private weak var viewConfirmPasswork: UIView!
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPasswork: UITextField!
    @IBOutlet private weak var tfConfirmPasswork: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    private func setupUI() {
        setupView()
    }
    private func setupView() {
        viewEmail.layer.cornerRadius = 8
        
    }
    

  

}
