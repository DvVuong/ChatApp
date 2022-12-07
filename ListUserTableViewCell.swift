//
//  ListUserTableViewCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {
    @IBOutlet  weak var lbNameUser: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ user: UserRespone) {
        self.lbNameUser.text = user.name
         
    }

}
