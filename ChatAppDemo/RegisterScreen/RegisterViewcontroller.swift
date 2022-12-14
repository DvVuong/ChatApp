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
    @IBOutlet private weak var viewEmail: UIView!
    @IBOutlet private weak var viewPassword: UIView!
    @IBOutlet private weak var viewConfirmPassword: UIView!
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPassword: UITextField!
    @IBOutlet private weak var tfConfirmPassword: UITextField!
    @IBOutlet private weak var imgAvtar: UIImageView!
    @IBOutlet private weak var btSignUp: UIButton!
    @IBOutlet private weak var tfName: UITextField!
    var delegate: RegisterViewcontrollerDelegate?
    private  var imgPicker = UIImagePickerController()
    lazy var presenter = ResgiterPresenterView(with: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    private func setupUI() {
        setupView()
        setupImgAvatar()
        setupBtSigup()
    }
    private func setupView() {
        viewEmail.layer.cornerRadius = 6
        viewPassword.layer.cornerRadius = 6
        viewConfirmPassword.layer.cornerRadius = 6
        // TextField
        tfName.attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [.foregroundColor: UIColor.brown])
        tfEmail.attributedPlaceholder = NSAttributedString(string: "Enter your email", attributes: [NSAttributedString.Key.foregroundColor:UIColor.brown ])
        tfPassword.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [.foregroundColor: UIColor.brown])
        tfConfirmPassword.attributedPlaceholder = NSAttributedString(string: "ConfirmPassword", attributes: [.foregroundColor: UIColor.brown])
        
    }
    private func setupImgAvatar() {
        imgAvtar.layer.cornerRadius = imgAvtar.frame.height / 2
        imgAvtar.layer.masksToBounds = true
        imgAvtar.isUserInteractionEnabled = true
        imgAvtar.contentMode = .scaleToFill
        imgAvtar.layer.borderWidth = 1
        imgAvtar.layer.borderColor = UIColor.black.cgColor
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
        alert.addAction(chooseImageFromLibrabriAction)
        alert.addAction(chooseImageFromCamera)
        present(alert, animated: true)
    }
    private func setupBtSigup() {
        btSignUp.layer.cornerRadius = 6
        btSignUp.layer.masksToBounds = true
        btSignUp.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    @objc private func didTapSignUp(_ sender: UIButton) {
        if tfEmail.text == "" && tfPassword.text != tfConfirmPassword.text {
            showAlertFailure("Email không được rỗng")
            return
        }else if tfPassword.text == "" {
            showAlertFailure("Password không được rỗng")
            return
        }
        else {
            presenter.validateEmaiPassoword(tfEmail.text!, password: tfPassword.text!) { bool in
                if bool {
                    presenter.createAccount(email: tfEmail.text!, password: tfPassword.text!, name: tfName.text!)
                    showAlertSuccess("Đăng ký thành công")
                }else {
                    showAlertFailure("Email đã tồn tại")
                    
                }
            }
        }
    }
    func showAlertSuccess(_ title: String)  {
        let aler = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Xác nhận", style: .default) { action in
            self.delegate?.callBackAccountResgiter(self, email: self.tfEmail.text!, password: self.tfPassword.text!)
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
    
}


