//
//  SettingViewController.swift
//  ChatAppDemo
//
//  Created by BeeTech on 15/12/2022.
//

import UIKit


final class SettingViewController: UIViewController {
    static func instance() -> SettingViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingScreen") as! SettingViewController
        return vc
    }
    
    @IBOutlet private weak var tfName: UITextField!
    @IBOutlet private var imgAvatar: UIImageView!
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPassword: UITextField!
    @IBOutlet private weak var btLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        setUpBtLogOut()
    }
    
    private func setUpBtLogOut() {
        btLogout.setTitle("Log Out", for: .normal)
        btLogout.addTarget(self, action: #selector(didTapLogOut(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapLogOut(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}

