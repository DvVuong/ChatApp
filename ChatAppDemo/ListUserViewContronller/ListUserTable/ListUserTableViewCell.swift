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
    
    func updateUI(_ currentUser: User?, message: Message?, reciverUser: User?) {
        guard let message = message else {return}
        guard let currentUser = currentUser else {return}
        guard let reciverUser = reciverUser else {return}
        // Show Avatar
        ImageService.share.fetchImage(with: currentUser.avatar) { image in
            DispatchQueue.main.async {
                self.imgAvt.image = image
            }
        }
        // Show Message and State message
        
        if message.sendId == currentUser.id || message.receiverID == reciverUser.id {
            lbMessage.text = "you: \(message.text)"
            lbNameUser.text = message.receivername
        } else {
            lbMessage.text = "\(message.nameSender) sent: \(message.text)"
            lbNameUser.text = message.nameSender
        }
        
        if !message.image.isEmpty {
            if message.sendId == currentUser.id {
                lbMessage.text = "you sent a Photo"
            }else {
                
                lbMessage.text = "\(message.nameSender) sent a Photo"
            }
            return
        }
       
    }
}
