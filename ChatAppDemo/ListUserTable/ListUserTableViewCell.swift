//
//  ListUserTableViewCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {
    @IBOutlet weak var lbNameUser: UILabel!
    @IBOutlet private weak var lbMessage: UILabel!
    @IBOutlet private weak var imgAvt: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvt.contentMode = .scaleToFill
        imgAvt.layer.cornerRadius = imgAvt.frame.height / 2
        imgAvt.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ user: UserRespone?, message: MessageRespone?) {
        guard let user = user else { return }
        self.lbNameUser.text = user.name
        if let message = message {
            self.lbMessage.text = message.text
        }
        
        ImageService.share.fetchImage(with: user.avatar) { image in
            DispatchQueue.main.async {
                self.imgAvt.image = image
            }
        }
         
    }

}
