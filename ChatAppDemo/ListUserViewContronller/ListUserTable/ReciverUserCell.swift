//
//  ReciverUserCell.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/21/22.
//

import UIKit

class ReciverUserCell: UITableViewCell {
    
    private  var lbMessage: CustomLabel = {
       let lbMessage = CustomLabel()
        lbMessage.translatesAutoresizingMaskIntoConstraints = false
        lbMessage.backgroundColor = .systemGray
        lbMessage.numberOfLines = 0
        lbMessage.layer.cornerRadius = 6
        lbMessage.layer.masksToBounds = true
        return lbMessage
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.addSubview(lbMessage)
        lbMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        lbMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        lbMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        lbMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ message: Message?) {
        guard let message = message else {return}
        lbMessage.text = message.text
        if message.text == "👍" {
            lbMessage.backgroundColor = .clear
        }
    }
    
}
