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
        // Setup BubbleView
        bubbleView.layer.borderWidth = 1
        bubbleView.layer.borderColor = UIColor.black.cgColor
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ user: User?, message: Message?) {
        guard let user = user else { return }
        self.lbNameUser.text = user.name
        if let message = message {
            self.lbMessage.text = message.text
            if message.receiverID == user.id {
                lbMessage.text = "you:\(message.text)"
                
            }
            else {
                lbMessage.text = "\(user.name): \(message.text)"
            }
            
            if !message.image.isEmpty {
                if message.receiverID == user.id {
                    lbMessage.text = "you sent a photo"
                }
                else {
                    lbMessage.text = "\(user.name) sent a photo:"
                }
            }
            if message.read == true {
                self.imgState.isHidden = true
            }
            else {
                self.imgState.isHidden = false
            }
            
        }else {
            lbMessage.text = "Tap to chat"
            self.imgState.isHidden = true
        }
        ImageService.share.fetchImage(with: user.avatar) { image in
            DispatchQueue.main.async {
                self.imgAvt.image = image
            }
            
        }
        
         
    }

}
