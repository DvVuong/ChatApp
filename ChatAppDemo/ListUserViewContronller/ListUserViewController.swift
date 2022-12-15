//
//  ListUserViewController.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class ListUserViewController: UIViewController {
    static func instance(_ currentUser: User) -> ListUserViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listUserScreen") as! ListUserViewController
        vc.presenter = ListUserPresenter(with: vc, data: currentUser)
        return vc
    }
    
    private var presenter: ListUserPresenter!
    lazy var presenterCell = ListCellPresenter()
    @IBOutlet private var userTableView: UITableView!
    @IBOutlet private weak var searchUser: UITextField!
    @IBOutlet private var avatar: UIImageView!
    @IBOutlet private var btSetting: UIButton!
    @IBOutlet private var lbNameUser: UILabel!
    @IBOutlet private var imgState: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        setupUITable()
        setupSearchUser()
        setupImageForCurrentUser()
        setupBtSetting()
        setupLbNameUser()
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.presenter.fetchUser {
                self.presenter.fetchMessageForUser {
                    self.userTableView.reloadData()
                }
            }
        }
    }
    private func setupUITable() {
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorStyle = .none
    }
    
    private func setupSearchUser() {
        searchUser.layer.cornerRadius = 8
        searchUser.layer.masksToBounds = true
        searchUser.attributedPlaceholder = NSAttributedString(string: "Search User", attributes: [.foregroundColor: UIColor.brown])
        searchUser.addTarget(self, action: #selector(handelTextField(_:)), for: .editingChanged)
        
    }
    private func setupImageForCurrentUser() {
        guard let currentuser = presenter.getcurrentUser() else { return }
        avatar.layer.cornerRadius = avatar.frame.height / 2
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.contentMode = .scaleToFill
        ImageService.share.fetchImage(with: currentuser.avatar) { image in
            DispatchQueue.main.async {
                self.avatar.image = image
            }
        }
    }
    
    private func setupLbNameUser() {
        guard let currentuser = presenter.getcurrentUser() else { return }
        lbNameUser.text = currentuser.name
    }
    
    private func setupBtSetting() {
        btSetting.setTitle("", for: .normal)
        btSetting.addTarget(self, action: #selector(didTapSetting(_:)), for: .touchUpInside)
    }
   
    @objc func handelTextField(_ textfield: UITextField)  {
        presenter.searchUser(textfield.text!)
    }
    
    @objc func didTapSetting(_ sender: Any) {
        let vc = SettingViewController.instance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfUser()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! ListUserTableViewCell
        cell.updateUI(presenter.getCellForUsers(at: indexPath.row), message: presenter.getMessageForUserId(presenter.users[indexPath.row].id))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = presenter.getCellForUsers(at: indexPath.row) else { return}
        guard let currentUser = presenter.getcurrentUser() else { return }
        let messageKey = presenter.getMessageKeyForState(presenter.users[indexPath.row].id)
        let vc = DetailViewViewController.instance(data, currentUser: currentUser, messageKey: messageKey)
        vc.title = data.name
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { action, _, _ in
            self.presenter.deleteUser(indexPath.row) {
                self.userTableView.reloadData()
            }
        }
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .red
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
}
extension ListUserViewController: ListUserPresenterDelegate {
    func showSearchUser() {
        self.userTableView.reloadData()
    }
    func deleteUser(at index: Int) {
        self.userTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        self.userTableView.reloadData()
    }
    
}

