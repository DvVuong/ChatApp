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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.getUser()
        
    }
    private func setupUI() {
        setupUITable()
    }
    private func setupUITable() {
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tableFooterView = UIView()
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewViewController.instance()
        guard let item = presenter.cellForUsers(at: indexPath.row) else { return}
        vc.title = item.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ListUserViewController: ListUserPresenterDelegate {
    func showUsersList() {
        self.userTableView.reloadData()
    }
}
