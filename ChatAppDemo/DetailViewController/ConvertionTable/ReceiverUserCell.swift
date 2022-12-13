//
//  ReceiverUserCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit

class ReceiverUserCell: UITableViewCell {
    private var lbMessage: CustomLabel = {
        let lbMessage = CustomLabel()
        lbMessage.textAlignment = .right
        lbMessage.numberOfLines = 0
        lbMessage.textColor = .white
        lbMessage.layer.cornerRadius = 6
        lbMessage.layer.masksToBounds = true
        lbMessage.backgroundColor = .systemGray
        lbMessage.translatesAutoresizingMaskIntoConstraints = false
        return lbMessage
    }()
    private var imgMessage: UIImageView = {
       let imgMessage = UIImageView()
        imgMessage.contentMode = .scaleToFill
        imgMessage.layer.cornerRadius = 8
        imgMessage.layer.masksToBounds = true
        imgMessage.isHidden = true
        imgMessage.translatesAutoresizingMaskIntoConstraints = false
        return imgMessage
    }()
    private var lbTime: UILabel = {
       let lbTime = UILabel()
        lbTime.textColor = .systemGray
        lbTime.textAlignment = .right
        lbTime.font = UIFont.systemFont(ofSize: 12)
        lbTime.translatesAutoresizingMaskIntoConstraints = false
        return lbTime
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup contrains LbMessage
        contentView.addSubview(lbMessage)
        lbMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        lbMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        lbMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        lbMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        //SetupContrain imgMessage
        contentView.addSubview(imgMessage)
        imgMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        imgMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        imgMessage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imgMessage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        //Setup Contrains lbTime
        contentView.addSubview(lbTime)
        lbTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        lbTime.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lbTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        lbTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    func updateUI(with message: MessageRespone) {
        lbMessage.text = message.text
        // Setup Time
        let time = Date(timeIntervalSince1970: TimeInterval(message.time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        lbTime.text = dateFormatter.string(from: time)
        ImageService.share.fetchImage(with: message.image) { image in
            DispatchQueue.main.async {
                self.imgMessage.image = image
            }
        }
        if message.text.isEmpty {
            self.imgMessage.isHidden = false
        }else{
            self.imgMessage.isHidden = true
        }
    }

}
