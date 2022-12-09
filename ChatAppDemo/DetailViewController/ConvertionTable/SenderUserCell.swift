//
//  CurrentUserCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit

class SenderUserCell: UITableViewCell {
    @IBOutlet private weak var lbMessage: UILabel!
   

    private var imgMessage: UIImageView = {
       let imgMessage = UIImageView()
        imgMessage.contentMode = .scaleToFill
        imgMessage.layer.cornerRadius = 8
        imgMessage.layer.masksToBounds = true
        imgMessage.isHidden = true
        imgMessage.translatesAutoresizingMaskIntoConstraints = false
        return imgMessage
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        lbMessage.backgroundColor = .systemBlue
        lbMessage.translatesAutoresizingMaskIntoConstraints = false
        lbMessage.numberOfLines = 0
        lbMessage.layer.cornerRadius = 8
        lbMessage.layer.masksToBounds = true
        
        // Setup contrains LbMessage
        contentView.addSubview(lbMessage)
        lbMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        lbMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        lbMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        lbMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        //SetupContrain imgMessage
        contentView.addSubview(imgMessage)
        imgMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        imgMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        imgMessage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imgMessage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    func updateUI(with message: MessageRespone) {
        lbMessage.text = message.text
        ImageService.share.fetchImage(with: message.image) { image in
            DispatchQueue.main.async {
                self.imgMessage.image = image
            }
        }
        if message.text.isEmpty {
            self.imgMessage.isHidden = false
            //self.bubleView.isHidden = true
        }else {
            self.imgMessage.isHidden = true
        }
    }

}
