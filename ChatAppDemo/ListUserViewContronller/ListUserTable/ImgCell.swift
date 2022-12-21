//
//  ImgCell.swift
//  ChatAppDemo
//
//  Created by BeeTech on 21/12/2022.
//

import UIKit

class ImgCell: UITableViewCell {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ message: Message?) {
        guard let message = message else {return}
        ImageService.share.fetchImage(with: message.image) { image in
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
    }
    func setupForSender() {
        stackView.alignment = .trailing
    }
    
    func setupForReciver() {
        stackView.alignment = .leading
    }
    
}
