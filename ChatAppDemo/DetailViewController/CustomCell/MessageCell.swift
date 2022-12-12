//
//  MessageCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 12/12/2022.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var lbMessage: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbMessage.textAlignment = .right
        lbMessage.layer.cornerRadius = 6
        lbMessage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(with message: MessageRespone) {
        lbMessage.text = message.text
    }
    
}
