//
//  ListUserTableViewCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage

class ListUserTableViewCell: UITableViewCell {
    @IBOutlet weak var lbNameUser: UILabel!
    @IBOutlet private weak var lbMessage: UILabel!
    @IBOutlet private weak var imgAvt: UIImageView!
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var imgState: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvt.contentMode = .scaleToFill
        imgAvt.layer.cornerRadius = imgAvt.frame.height / 2
        imgAvt.layer.masksToBounds = true
        imgState.isHidden = true
        // Setup BubbleView
        bubbleView.layer.borderWidth = 1
        bubbleView.layer.borderColor = UIColor.black.cgColor
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateUI(_ user: User?, message: Message?) {
        guard let user = user else { return }
        guard let message = message else {return}
        // Show Avatar
        ImageService.share.fetchImage(with: user.avatar) { image in
            DispatchQueue.main.async {
                self.imgAvt.image = image
            }
        }
        // Show Message and State message
        lbNameUser.text = user.name
        if message.text.isEmpty {
            lbMessage.text = "No new message"
        } else {
            lbMessage.text = message.text
        }
        
        if message.receiverID == user.id {
            lbMessage.text = "you: \(message.text)"
        }
        
       
    }
}
