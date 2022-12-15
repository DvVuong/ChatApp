//
//  SignUpViewcontroller.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

protocol RegisterViewcontrollerDelegate {
    func callBackAccountResgiter(_ vc: RegisterViewcontroller, email: String, password: String)
}

class RegisterViewcontroller: UIViewController {
    
    static func instance(_ data: [User]) -> RegisterViewcontroller {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpScreen") as! RegisterViewcontroller
        vc.presenter = ResgiterPresenterView(view: vc, user: data)
        return vc
    }
    
    @IBOutlet private weak var tfEmail: CustomTextField!
    @IBOutlet private weak var tfPassword: CustomTextField!
    @IBOutlet private weak var tfConfirmPassword: CustomTextField!
    @IBOutlet private weak var imgAvtar: CustomImage!
    @IBOutlet private weak var btSignUp: CustomButton!
    @IBOutlet private weak var tfName: CustomTextField!
    var delegate: RegisterViewcontrollerDelegate?
    private var imgPicker = UIImagePickerController()
    lazy private var presenter = ResgiterPresenterView(with: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        setupImgAvatar()
        setupBtSigup()
    }
    
    private func setupImgAvatar() {
        imgAvtar.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handelImage(_:)))
        imgAvtar.addGestureRecognizer(tapGes)
    }
    
    @objc private func handelImage(_ tapges: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image From", message: nil, preferredStyle: .actionSheet)
        
        let chooseImageFromLibrabriAction = UIAlertAction(title: "From Librabri", style: .default){ action in
            self.imgPicker.delegate = self
            self.imgPicker.sourceType = .photoLibrary
            self.present(self.imgPicker, animated: true)
        }
        let chooseImageFromCamera = UIAlertAction(title: "From Camera", style: .default) { action in
            self.imgPicker.delegate = self
            self.imgPicker.sourceType = .camera
            self.present(self.imgPicker, animated: true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(chooseImageFromLibrabriAction)
        alert.addAction(chooseImageFromCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    private func setupBtSigup() {
        btSignUp.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapSignUp(_ sender: UIButton) {
        presenter.validateEmaiPassoword(tfEmail.text!, password: tfPassword.text!, confirmPassword: tfConfirmPassword.text!, name: tfName.text!, avatar: self.presenter.avatarUrl())
    }
    
    func showAlertSuccess(_ title: String)  {
        let aler = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Xác nhận", style: .default) { action in
            self.delegate?.callBackAccountResgiter(self, email: self.tfEmail.text!, password: self.tfPassword.text!)
            self.presenter.createAccount(email: self.tfEmail.text!, password: self.tfPassword.text!, name: self.tfName.text!)
        }
        aler.addAction(action)
        present(aler, animated: true)
    }
    
    func showAlertFailure(_ title: String) {
        let aler = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Xác nhận", style: .cancel)
        aler.addAction(action)
        present(aler, animated: true)
    }
}
extension RegisterViewcontroller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgAvtar.image = img
        guard let img = img else { return }
        presenter.sendImage(img)
        self.imgPicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imgPicker.dismiss(animated: true)
    }
}
extension RegisterViewcontroller: ResgiterPresenterDelegate {
    func validateAccountResgiter(_ result: String?) {
        if let result = result {
            showAlertFailure(result)
        } else {
            showAlertSuccess(" Register success")
        }
    }
}


