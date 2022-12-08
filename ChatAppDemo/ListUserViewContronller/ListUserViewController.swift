//
//  ListUserViewController.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class ListUserViewController: UIViewController {
    static func instance() -> ListUserViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listUserScreen") as! ListUserViewController
        return vc
    }
     lazy var presenter = ListUserPresenter(with: self)
    @IBOutlet private var userTableView: UITableView!
    @IBOutlet private weak var searchUser: UITextField!
    var currentUser: UserRespone?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.getUser()
        presenter.currentUser = currentUser
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    private func setupUI() {
        setupUITable()
        setupSearchUser()
    }
    private func setupUITable() {
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tableFooterView = UIView()
    }
    private func setupSearchUser() {
        searchUser.layer.cornerRadius = 8
        searchUser.layer.masksToBounds = true
        searchUser.attributedPlaceholder = NSAttributedString(string: "Search User", attributes: [.foregroundColor: UIColor.brown])
        searchUser.addTarget(self, action: #selector(handelTextField(_:)), for: .editingChanged)
        
    }
    @objc func handelTextField(_ textfield: UITextField)  {
        presenter.searchUser(textfield.text!)
    }
}
extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUser()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! ListUserTableViewCell
        if let index = presenter.cellForUsers(at: indexPath.row) {
            cell.updateUI(index)
        }
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewViewController.instance()
        guard let item = presenter.cellForUsers(at: indexPath.row) else { return}
        vc.title = item.name
        vc.receivername = item.name
        vc.receiverID = item.id
        vc.currentUser = currentUser
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ListUserViewController: ListUserPresenterDelegate {
    func showUsersList() {
        self.userTableView.reloadData()
    }
}
extension ListUserViewController: ListUserTableViewCellDelegate {
    func showAvatar() {
        self.userTableView.reloadData()
    }
}
