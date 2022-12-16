//
//  DetailViewViewController.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/7/22.
//

import UIKit

class DetailViewViewController: UIViewController {
    static func instance(_ data: User, currentUser: User, messageKey: Message?) -> DetailViewViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreen") as! DetailViewViewController
        vc.presenter = DetailPresenter(with: vc, data: data, currentUser: currentUser, messageKey: messageKey)
        return vc
    }
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var tfMessage: UITextField!
    @IBOutlet private weak var btSendMessage: UIButton!
    @IBOutlet private weak var convertiontable: UITableView!
    
    
    private var imgPicker = UIImagePickerController()
    private var presenter: DetailPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.presenter.fetchMessage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.changeStateReadMessage()
    }
    private func setupUI() {
        setupMessageTextField()
        setupImage()
        setupBtSend()
        setupConvertionTable()
    }
    private func setupConvertionTable() {
        convertiontable.delegate = self
        convertiontable.dataSource = self
        convertiontable.separatorStyle = .none
        convertiontable.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    private func setupMessageTextField() {
        tfMessage.attributedPlaceholder = NSAttributedString(string: "Aa", attributes: [.foregroundColor:UIColor.white])
        tfMessage.layer.cornerRadius = 8
        tfMessage.delegate = self
        tfMessage.layer.masksToBounds = true
    }
    private func setupImage() {
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage(_:))))
        image.isUserInteractionEnabled = true
    }
    private func setupBtSend() {
        btSendMessage.setTitle(" ", for: .normal)
        btSendMessage.setImage(UIImage(named: "paperplane.fill"), for: .normal)
        btSendMessage.addTarget(self, action: #selector(didTapSend(_:)), for: .touchUpInside)
    }
    @objc private func didTapSend(_ sender: UIButton) {
        self.sendMessage()
    }
    
    private func sendMessage() {
        if tfMessage.text == "" {
            return
        }
        presenter.sendMessage(with: tfMessage.text!)
        tfMessage.text = ""
    }
    
    @objc private func chooseImage(_ tapGes: UITapGestureRecognizer) {
        self.imgPicker.delegate = self
        self.imgPicker.sourceType = .photoLibrary
        present(self.imgPicker, animated: true)
    }
    private func scrollToBottom() {
        DispatchQueue.main.async {
            if self.presenter.getNumberOfMessage() < 1 { return }
            let indexPath = IndexPath(row: self.presenter.getNumberOfMessage() - 1, section: 0)
            self.convertiontable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
extension DetailViewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = image else { return }
        DispatchQueue.main.async {
            self.presenter.sendImageMessage(with: image)
        }
        self.imgPicker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imgPicker.dismiss(animated: true)
    }
    
}
extension DetailViewViewController: DetailPresenterViewDelegate {
    func showMessage() {
        self.convertiontable.reloadData()
        self.scrollToBottom()
    }
}
extension DetailViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfMessage()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentId = presenter.getCurrentUserID()
        let sendId = presenter.messages[indexPath.item].sendId
        if currentId == sendId {
            guard let cell = convertiontable.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderUserCell else { return UITableViewCell() }
            let message = presenter.getCellForMessage(at: indexPath.row)
            cell.updateUI(with: message)
            return cell
            
        } else {
            guard let cell = convertiontable.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as? ReceiverUserCell else { return UITableViewCell() }
            let message = presenter.getCellForMessage(at: indexPath.item)
            cell.updateUI(with: message)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = presenter.getCellForMessage(at: indexPath.row)
        if message.text.isEmpty {
            return 180
        }
        else {
            return UITableView.automaticDimension
        }
    }
}
extension DetailViewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage()
        return true
    }
}
