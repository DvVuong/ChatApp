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
     lazy var presenter = SignInPresenter(with: self)
    @IBOutlet private var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
        
    }
    private func setupUI() {
        setupUITable()
    }
    private func setupUITable() {
        userTableView.delegate = self
        userTableView.dataSource = self
    }
}
extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUser()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! ListUserTableViewCell
        if let index = presenter.cellForUser(indexPath.row) {
            cell.updateUI(index)
        }
        
        return cell
    }
}
extension ListUserViewController: SignInPresenterDelegate {
   
}
